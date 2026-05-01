class IncorrectUidFormatException implements Exception{
  final String raw;

  IncorrectUidFormatException(this.raw);

  @override
  String toString() => "IncorrectUidFormatException: '$raw' is not in the correct uid format. The expected uid format consists of 9 digits.";
}