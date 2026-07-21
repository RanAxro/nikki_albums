
import "package:nikki_albums/modules/nuan5_params/domain/config.dart";
import "package:nikki_albums/modules/nuan5_params/domain/tree_node_generator.dart";
import "package:nikki_albums/widgets/app/component.dart";

import "package:flutter/material.dart";


abstract class SelectorHandler{
  const SelectorHandler();

  int? getInitValue(Nuan5Config config, Object? raw);

  List<int> getType(Nuan5Config config);

  String getTypeText(int type);

  List<int> getValue(Nuan5Config config, int? type);

  String getValueText(int value);

  String getValueImageUrl(Nuan5Config config, int value);

  Widget imageErrorWidget(BuildContext context, String url, Object error){
    return Center(
      child: AppText("?"),
    );
  }

  int? getValueType(Nuan5Config config, int value){
    final List<int> allType = getType(config);

    for(final int type in allType){
      final List<int> allValue = getValue(config, type);
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
  int? getInitValue(Nuan5Config config, Object? raw){
    if(raw == null){
      return null;
    }

    if(raw is int){
      return raw;
    }

    if(raw is String){
      for(final MapEntry<int, Nuan5Light> entry in config.light.entries){
        final Nuan5Light data = entry.value;

        if(raw == data.paramId || raw == data.stringId){
          return entry.key;
        }
      }
    }

    return null;
  }

  @override
  List<int> getType(Nuan5Config config){
    return config.table?.lightType ?? config.lightType.keys.toList();
  }

  @override
  String getTypeText(int type){
    return trText(type.toString(), category: "light_type");
  }

  @override
  List<int> getValue(Nuan5Config config, int? type){
    if(type == null){
      return [];
    }

    return config.lightType[type]?.light ?? [];
  }

  @override
  String getValueImageUrl(Nuan5Config config, int value){
    return config.getImageUrl(config.networkImage?.light, value) ?? "";
  }

  @override
  String getValueText(int value){
    return trText(value.toString(), category: "light");
  }
}


class FilterSelectorHandler extends SelectorHandler{
  const FilterSelectorHandler();

  @override
  int? getInitValue(Nuan5Config config, Object? raw){
    if(raw == null){
      return null;
    }

    if(raw is int){
      return raw;
    }

    if(raw is String){
      for(final MapEntry<int, Nuan5Filter> entry in config.filter.entries){
        final Nuan5Filter data = entry.value;

        if(raw == data.paramId || raw == data.stringId){
          return entry.key;
        }
      }
    }

    return null;
  }

  @override
  List<int> getType(Nuan5Config config){
    return config.table?.filterType ?? config.filterType.keys.toList();
  }

  @override
  String getTypeText(int type){
    return trText(type.toString(), category: "filter_type");
  }

  @override
  List<int> getValue(Nuan5Config config, int? type){
    if(type == null){
      return [];
    }

    return config.filterType[type]?.filter ?? [];
  }

  @override
  String getValueImageUrl(Nuan5Config config, int value){
    return config.getImageUrl(config.networkImage?.filter, value) ?? "";
  }

  @override
  String getValueText(int value){
    return trText(value.toString(), category: "filter");
  }
}


class MomoPoseSelectorHandler extends SelectorHandler{
  const MomoPoseSelectorHandler();

  @override
  int? getInitValue(Nuan5Config config, Object? raw){
    if(raw == null){
      return null;
    }

    if(raw is int){
      return raw == 0 ? null : raw;
    }

    return null;
  }

  @override
  List<int> getType(Nuan5Config config){
    return [];
  }

  @override
  String getTypeText(int type){
    return type.toString();
  }

  @override
  List<int> getValue(Nuan5Config config, int? type){
    return config.momoPose.keys.toList();
  }

  @override
  String getValueImageUrl(Nuan5Config config, int value){
    return config.getImageUrl(config.networkImage?.momoPose, value) ?? "";
  }

  @override
  Widget imageErrorWidget(BuildContext context, String url, Object error){
    return Padding(
      padding: const EdgeInsets.all(smallPadding),
      child: Stack(
        children: [
          Positioned.fill(child: AppIcon("momo_default", isDye: false)),
          Center(child: AppText("?")),
        ],
      ),
    );
  }

  @override
  String getValueText(int value){
    return value == 0 ?
      trBool(false, index: 2) :
      trText(value.toString(), category: "momo_pose");
  }
}

