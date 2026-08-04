
extension NullableLet<T> on T?{
  R? let<R>(R Function(T) f) => this == null ? null : f(this as T);
}