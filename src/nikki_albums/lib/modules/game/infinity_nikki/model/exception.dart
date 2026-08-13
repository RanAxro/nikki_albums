import "album_type.dart";

enum QueryAlbumInfoErrorCode{
  lackUid,
}

class QueryAlbumInfoException implements Exception{
  final AlbumType target;
  final QueryAlbumInfoErrorCode errorCode;

  const QueryAlbumInfoException(this.target, this.errorCode);

  @override
  String toString() => switch(errorCode){
    QueryAlbumInfoErrorCode.lackUid => "The path of '$target' cannot be obtained. Because of the lack of uid data",
  };
}


class IncorrectUidFormatException implements Exception{
  final String raw;

  IncorrectUidFormatException(this.raw);

  @override
  String toString() => "IncorrectUidFormatException: '$raw' is not in the correct uid format. The expected uid format consists of 9 digits.";
}