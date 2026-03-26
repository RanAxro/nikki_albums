





// ==================== 核心抽象 ====================

enum FieldType{
  integer,      // TemplateId
  number,       // Rotation (double)
  string,       // 普通字符串
  boolean,      // GiantState
  list,         // RegionPictures (数组)
  object,       // oriCustomData (嵌套对象)
  map,          // InteractivePhoto (键值对)
  unknown,      // 未识别类型
}


// class Field<T>{
//   final String jsonKey;           // JSON 中的键名
//   final String displayNameKey;    // 本地化键名（如 "template_id" → "模板ID"）
//   final FieldType type;           // 值类型，决定如何渲染
//   final bool visible;             // 是否对用户可见
//   final T? defaultValue;          // 默认值
//   final List<Field>? children; // 嵌套结构（用于对象/列表）
//
//   const Field({
//     required this.jsonKey,
//     required this.displayNameKey,
//     required this.type,
//     this.visible = true,
//     this.defaultValue,
//     this.children,
//   });
//
//   String get iconName => "image_addition/$jsonKey";
//   String get name => displayNameKey;
// }


class Field{
  const Field();
}

class IntField extends Field{

}
class DoubleField extends Field{

}
class StringField extends Field{

}
class BoolField extends Field{

}
class NullField extends Field{

}
class IterableField extends Field{

}