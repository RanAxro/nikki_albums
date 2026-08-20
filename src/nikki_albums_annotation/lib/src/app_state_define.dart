class AppStateDefine{
  final String? description;
  final String? rename;

  const AppStateDefine(
    this.description, {
    this.rename,
  });
}

class AppStateItemDefine<T, P>{
  final T defaultValue;
  final T? Function(P)? ref;
  final T Function(T, P)? readPersistent;
  final P Function(T, P)? writePersistent;

  const AppStateItemDefine({
    required this.defaultValue,
    this.ref,
    this.readPersistent,
    this.writePersistent,
  });
}
