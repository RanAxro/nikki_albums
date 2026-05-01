
abstract interface class SerDe<T, U>{
  U serialize(T source);

  T deserialize(U source);
}