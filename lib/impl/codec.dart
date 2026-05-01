
abstract interface class Codec<T, U>{
  U encode(T source);

  T decode(U source);
}