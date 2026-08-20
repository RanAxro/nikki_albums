# 开发常用命令

* 当rust代码变更, 使用此命令生成胶水代码
```bash
flutter_rust_bridge_codegen generate
```


* 当注解代码变更, 使用此命令生成对应的 Dart 代码文件
```bash
flutter pub run build_runner build  
```