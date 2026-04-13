part of "../../lib/uid_note.dart";

abstract class UidNoteSerDe{
  Map<String, String?>? serialize(UidNote? source){
    if(source == null) return null;

    return {
      "installPath": source.installPath,
      "value": source.value,
      "note": source.note,
    };
  }

  UidNote? deserialize(dynamic source){
    if(source is! Map) return null;

    if(source case {
      "installPath": String installPath,
      "value": String value,
      "note": String note,
    }){
      return UidNote._(note: note, installPath: installPath, value: value);
    }

    return null;
  }
}