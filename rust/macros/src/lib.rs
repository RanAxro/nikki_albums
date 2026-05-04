use proc_macro::TokenStream;
use proc_macro2::Span;
use quote::{format_ident, quote};
use syn::{
  DeriveInput, Ident, LitInt, LitStr, Token, Type,
  parse::{Parse, ParseStream},
  parse_macro_input,
  spanned::Spanned,
};

/// 维度控制结构
#[derive(Debug, Clone, Copy)]
struct DimControl(u8);

impl DimControl {
  fn new(val: u8, name: &str, span: Span) -> syn::Result<Self> {
    if val > 3 {
      return Err(syn::Error::new(
        span,
        format!("`{}` must be 0, 1, 2, or 3", name),
      ));
    }
    Ok(Self(val))
  }

  fn val(&self) -> u8 {
    self.0
  }
}

/// 宏参数结构
struct Args {
  pre_rename: String,
  pre_field: String,
  ty: Type,
  loc: DimControl,
  scale: DimControl,
  rot: DimControl,
}

impl Default for Args {
  fn default() -> Self {
    Self {
      pre_rename: String::new(),
      pre_field: String::new(),
      ty: syn::parse_str("f64").expect("default type should be valid"),
      loc: DimControl(3),
      scale: DimControl(3),
      rot: DimControl(3),
    }
  }
}

impl Parse for Args {
  fn parse(input: ParseStream) -> syn::Result<Self> {
    let mut args = Args::default();

    while !input.is_empty() {
      let key: Ident = input.parse()?;
      let key_str = key.to_string();

      let _: Token![=] = input.parse()?;

      match key_str.as_str() {
        "pre_rename" | "pre_field" => {
          let val: LitStr = input.parse()?;
          let value = val.value();

          // 验证标识符合法性
          if !value.is_empty() {
            if let Err(_) = syn::parse_str::<Ident>(&format!("_{}", value)) {
              return Err(syn::Error::new(
                val.span(),
                format!("`{}` must be a valid identifier prefix", key_str),
              ));
            }
          }

          match key_str.as_str() {
            "pre_rename" => args.pre_rename = value,
            _ => args.pre_field = value,
          }
        }
        "ty" => {
          let val: LitStr = input.parse()?;
          args.ty = val
            .parse()
            .map_err(|e| syn::Error::new(val.span(), format!("invalid type: {}", e)))?;
        }
        "loc" | "scale" | "rot" => {
          let val: LitInt = input.parse()?;
          let n: u8 = val.base10_parse().map_err(|e| {
            syn::Error::new(val.span(), format!("expected integer: {}", e))
          })?;

          let ctrl = DimControl::new(n, &key_str, val.span())?;
          match key_str.as_str() {
            "loc" => args.loc = ctrl,
            "scale" => args.scale = ctrl,
            "rot" => args.rot = ctrl,
            _ => unreachable!(),
          }
        }
        _ => {
          return Err(syn::Error::new(
            key.span(),
            format!(
              "unknown attribute `{}`, expected one of: pre_rename, pre_field, ty, loc, scale, rot",
              key_str
            ),
          ));
        }
      }

      // 处理可选逗号
      if !input.is_empty() {
        input.parse::<Token![,]>()?;
      }
    }

    Ok(args)
  }
}

/// 字段定义辅助结构
struct FieldDef {
  json_suffix: &'static str, // JSON序列化名后缀
  rust_suffix: &'static str, // Rust字段名后缀
}

fn get_loc_fields(dim: u8) -> &'static [FieldDef] {
  match dim {
    0 => &[],
    1 => &[FieldDef {
      json_suffix: "Loc",
      rust_suffix: "loc",
    }],
    2 => &[
      FieldDef {
        json_suffix: "LocX",
        rust_suffix: "loc_x",
      },
      FieldDef {
        json_suffix: "LocY",
        rust_suffix: "loc_y",
      },
    ],
    3 => &[
      FieldDef {
        json_suffix: "LocX",
        rust_suffix: "loc_x",
      },
      FieldDef {
        json_suffix: "LocY",
        rust_suffix: "loc_y",
      },
      FieldDef {
        json_suffix: "LocZ",
        rust_suffix: "loc_z",
      },
    ],
    _ => unreachable!(),
  }
}

fn get_scale_fields(dim: u8) -> &'static [FieldDef] {
  match dim {
    0 => &[],
    1 => &[FieldDef {
      json_suffix: "Scale",
      rust_suffix: "scale",
    }],
    2 => &[
      FieldDef {
        json_suffix: "ScaleX",
        rust_suffix: "scale_x",
      },
      FieldDef {
        json_suffix: "ScaleY",
        rust_suffix: "scale_y",
      },
    ],
    3 => &[
      FieldDef {
        json_suffix: "ScaleX",
        rust_suffix: "scale_x",
      },
      FieldDef {
        json_suffix: "ScaleY",
        rust_suffix: "scale_y",
      },
      FieldDef {
        json_suffix: "ScaleZ",
        rust_suffix: "scale_z",
      },
    ],
    _ => unreachable!(),
  }
}

fn get_rot_fields(dim: u8) -> &'static [FieldDef] {
  match dim {
    0 => &[],
    1 => &[FieldDef {
      json_suffix: "Rot",
      rust_suffix: "rot",
    }],
    2 => &[
      FieldDef {
        json_suffix: "RotX",
        rust_suffix: "rot_x",
      },
      FieldDef {
        json_suffix: "RotY",
        rust_suffix: "rot_y",
      },
    ],
    3 => &[
      FieldDef {
        json_suffix: "RotYaw",
        rust_suffix: "rot_yaw",
      },
      FieldDef {
        json_suffix: "RotPitch",
        rust_suffix: "rot_pitch",
      },
      FieldDef {
        json_suffix: "RotRoll",
        rust_suffix: "rot_roll",
      },
    ],
    _ => unreachable!(),
  }
}

#[proc_macro_attribute]
pub fn with_transform_fields(args: TokenStream, input: TokenStream) -> TokenStream {
  let args = parse_macro_input!(args as Args);
  let input = parse_macro_input!(input as DeriveInput);

  // 验证必须是结构体
  let data_struct = match &input.data {
    syn::Data::Struct(s) => s,
    _ => {
      return syn::Error::new(
        input.span(),
        "`with_transform_fields` can only be applied to structs",
      )
        .to_compile_error()
        .into();
    }
  };

  let (vis, name, generics) = (&input.vis, &input.ident, &input.generics);
  let (impl_generics, type_generics, where_clause) = generics.split_for_impl();

  // 构建前缀
  let field_prefix = if args.pre_field.is_empty() {
    String::new()
  } else {
    format!("{}_", args.pre_field)
  };

  let ty = &args.ty;

  // 生成所有字段
  let mut all_fields = Vec::new();

  // 添加 Loc 字段
  for field_def in get_loc_fields(args.loc.val()) {
    let json_name = format!("{}{}", args.pre_rename, field_def.json_suffix);
    let field_name = format_ident!("{}{}", field_prefix, field_def.rust_suffix);
    all_fields.push(quote! {
            #[serde(rename = #json_name)]
            #vis #field_name: #ty
        });
  }

  // 添加 Scale 字段
  for field_def in get_scale_fields(args.scale.val()) {
    let json_name = format!("{}{}", args.pre_rename, field_def.json_suffix);
    let field_name = format_ident!("{}{}", field_prefix, field_def.rust_suffix);
    all_fields.push(quote! {
            #[serde(rename = #json_name)]
            #vis #field_name: #ty
        });
  }

  // 添加 Rot 字段
  for field_def in get_rot_fields(args.rot.val()) {
    let json_name = format!("{}{}", args.pre_rename, field_def.json_suffix);
    let field_name = format_ident!("{}{}", field_prefix, field_def.rust_suffix);
    all_fields.push(quote! {
            #[serde(rename = #json_name)]
            #vis #field_name: #ty
        });
  }

  // 保留原有字段
  let existing_fields = match &data_struct.fields {
    syn::Fields::Named(named) => {
      let fields = &named.named;
      quote! { #fields }
    }
    syn::Fields::Unit => quote! {},
    syn::Fields::Unnamed(_) => {
      return syn::Error::new(data_struct.fields.span(), "tuple structs are not supported")
        .to_compile_error()
        .into();
    }
  };

  let attrs = &input.attrs;

  let expanded = quote! {
        #(#attrs)*
        #vis struct #name #impl_generics #type_generics #where_clause {
            #(#all_fields,)*
            #existing_fields
        }
    };

  expanded.into()
}
