import "../album_type.dart";

enum AlbumPathProviderExceptionEnum{
  lackUid,
}

class AlbumPathProviderException implements Exception{
  final AlbumType targetType;
  final AlbumPathProviderExceptionEnum exceptionType;

  const AlbumPathProviderException(this.exceptionType, this.targetType);

  @override
  String toString() => switch(exceptionType){
    AlbumPathProviderExceptionEnum.lackUid => "The path of '$targetType' cannot be obtained. Because of the lack of uid data",
  };
}