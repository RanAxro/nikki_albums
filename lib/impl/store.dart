
abstract interface class Store<T>{
  T load();

  void save(T source);
}