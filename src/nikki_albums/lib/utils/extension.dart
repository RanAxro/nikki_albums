
extension NullableLet<T> on T?{
  R? let<R>(R Function(T) f) => this == null ? null : f(this as T);
}

extension IterableFirstWhere<E> on Iterable<E>{
  E? firstWhereOrNull(bool Function(E) test){
    for(E element in this){
      if(test(element)){
        return element;
      }
    }
    return null;
  }
}