fn main(){
  // 1. 告诉 Cargo 去哪里找 .lib 文件
  println!(r"cargo:rustc-link-search=native=./lib/windows");

  // 2. 告诉 Cargo 链接哪个库（不要加前缀 lib 和后缀 .lib）
  println!("cargo:rustc-link-lib=dylib=nuan5_decryption");
}