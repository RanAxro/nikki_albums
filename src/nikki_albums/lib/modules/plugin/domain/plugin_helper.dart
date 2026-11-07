
import "package:uuid/validation.dart";


abstract final class PluginHelper{
  static bool isValidUuid(String uuid){
    return UuidValidation.isValidUUID(fromString: uuid);
  }

  static void isValidUuidOrThrow(String uuid){
    UuidValidation.isValidOrThrow(fromString: uuid);
  }
}