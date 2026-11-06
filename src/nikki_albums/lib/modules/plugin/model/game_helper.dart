
import "package:uuid/validation.dart";


abstract final class GameHelper{
  static String generateUniqueId(String ownership, String uuid){
    return "$ownership|$uuid";
  }

  static String getOwnershipByUniqueId(String uniqueId){
    final String ownership = uniqueId.split("|").first;
    UuidValidation.isValidOrThrow(fromString: ownership);
    return ownership;
  }

  static String getUuidByUniqueId(String uniqueId){
    final String uuid = uniqueId.split("|").last;
    UuidValidation.isValidOrThrow(fromString: uuid);
    return uuid;
  }
}