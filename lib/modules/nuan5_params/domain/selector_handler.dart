
import "package:nikki_albums/src/rust/nuan5_database/model.dart";
import "package:nikki_albums/src/rust/nuan5_database/reader_v1.dart";
import "package:nikki_albums/modules/nuan5_params/model/image.dart";


abstract class SelectorHandler{
  const SelectorHandler();

  int? getInitValue(Nuan5DatabaseReaderV1 reader, Object? raw);

  List<int> getType(Nuan5DatabaseReaderV1 reader);

  String getTypeText(Nuan5DatabaseReaderV1 reader, int type);

  List<int> getValue(Nuan5DatabaseReaderV1 reader, int? type);

  String getValueText(Nuan5DatabaseReaderV1 reader, int value);

  String getValueImageUrl(Nuan5DatabaseReaderV1 reader, int value);

  int? getValueType(Nuan5DatabaseReaderV1 reader, int value){
    final List<int> allType = getType(reader);

    for(final int type in allType){
      final List<int> allValue = getValue(reader, type);
      if(allValue.contains(value)){
        return type;
      }
    }

    return null;
  }
}


class LightSelectorHandler extends SelectorHandler{
  const LightSelectorHandler();

  @override
  int? getInitValue(Nuan5DatabaseReaderV1 reader, Object? raw){
    if(raw == null){
      return null;
    }

    if(raw is int){
      return raw;
    }

    if(raw is String){
      final List<int> light = reader.listSync(category: Nuan5DatabaseCategory.light, from: BigInt.zero, max: -1);
      final Map<int, Nuan5DatabaseItem> lightData = reader.getSync(category: Nuan5DatabaseCategory.light, ids: light);

      for(final MapEntry<int, Nuan5DatabaseItem> entry in lightData.entries){
        final Nuan5Light? data = entry.value.whenOrNull(light: (d) => d);

        if(data != null && (raw == data.paramId || raw == data.stringId)){
          return entry.key;
        }
      }
    }

    return null;
  }

  @override
  List<int> getType(Nuan5DatabaseReaderV1 reader){
    return reader.listSync(category: Nuan5DatabaseCategory.lightType, from: BigInt.zero, max: -1);
  }

  @override
  String getTypeText(Nuan5DatabaseReaderV1 reader, int type){
    return type.toString();
  }

  @override
  List<int> getValue(Nuan5DatabaseReaderV1 reader, int? type){
    if(type == null){
      return [];
    }

    final Map<int, Nuan5DatabaseItem> data = reader.getSync(category: Nuan5DatabaseCategory.lightType, ids: [type]);

    return data[type]?.whenOrNull(
      lightType: (d) => d.light,
    ) ?? [];
  }

  @override
  String getValueImageUrl(Nuan5DatabaseReaderV1 reader, int value){
    return Nuan5Image.light(value);
  }

  @override
  String getValueText(Nuan5DatabaseReaderV1 reader, int value){
    return value.toString();
  }
}


class FilterSelectorHandler extends SelectorHandler{
  const FilterSelectorHandler();

  @override
  int? getInitValue(Nuan5DatabaseReaderV1 reader, Object? raw){
    if(raw == null){
      return null;
    }

    if(raw is int){
      return raw;
    }

    if(raw is String){
      final List<int> filter = reader.listSync(category: Nuan5DatabaseCategory.filter, from: BigInt.zero, max: -1);
      final Map<int, Nuan5DatabaseItem> filterData = reader.getSync(category: Nuan5DatabaseCategory.filter, ids: filter);

      for(final MapEntry<int, Nuan5DatabaseItem> entry in filterData.entries){
        final Nuan5Filter? data = entry.value.whenOrNull(filter: (d) => d);

        if(data != null && (raw == data.paramId || raw == data.stringId)){
          return entry.key;
        }
      }
    }

    return null;
  }

  @override
  List<int> getType(Nuan5DatabaseReaderV1 reader){
    return reader.listSync(category: Nuan5DatabaseCategory.filterType, from: BigInt.zero, max: -1);
  }

  @override
  String getTypeText(Nuan5DatabaseReaderV1 reader, int type){
    return type.toString();
  }

  @override
  List<int> getValue(Nuan5DatabaseReaderV1 reader, int? type){
    if(type == null){
      return [];
    }

    final Map<int, Nuan5DatabaseItem> data = reader.getSync(category: Nuan5DatabaseCategory.filterType, ids: [type]);

    return data[type]?.whenOrNull(
      filterType: (d) => d.filter,
    ) ?? [];
  }

  @override
  String getValueImageUrl(Nuan5DatabaseReaderV1 reader, int value){
    return Nuan5Image.filter(value);
  }

  @override
  String getValueText(Nuan5DatabaseReaderV1 reader, int value){
    return value.toString();
  }
}


class MomoPoseSelectorHandler extends SelectorHandler{
  const MomoPoseSelectorHandler();

  @override
  int? getInitValue(Nuan5DatabaseReaderV1 reader, Object? raw){
    if(raw == null){
      return null;
    }

    if(raw is int){
      return raw == 0 ? null : raw;
    }

    return null;
  }

  @override
  List<int> getType(Nuan5DatabaseReaderV1 reader){
    return [];
  }

  @override
  String getTypeText(Nuan5DatabaseReaderV1 reader, int type){
    return type.toString();
  }

  @override
  List<int> getValue(Nuan5DatabaseReaderV1 reader, int? type){
    return reader.listSync(category: Nuan5DatabaseCategory.momoPose, from: BigInt.zero, max: -1);
  }

  @override
  String getValueImageUrl(Nuan5DatabaseReaderV1 reader, int value){
    return Nuan5Image.momoPose(value);
  }

  @override
  String getValueText(Nuan5DatabaseReaderV1 reader, int value){
    return value.toString();
  }
}

