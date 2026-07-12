
import "../model/cloth_diy.dart";
import "package:nikki_albums/modules/nuan5_params/domain/database.dart";
import "package:nikki_albums/src/rust/nuan5_database/model.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/nikki_photo_params.dart";

import "dart:math";


const List<int> defaultSortingBasis = [
  0, 10, 90, 20, 30, 41, 50, 60,
  71, 72, 73, 74, 75, 76, 77, 92, 93, 94, 95, 96, 97, 78, 79,
  80,
  81, 82, 83, 84, 85, 86,
];


class ClothDiyHandler{
  const ClothDiyHandler();

  List<ClothParams> getSortedCloth(List<ClothParams> cloth, [List<int> basis = defaultSortingBasis]){
    final List<ClothParams?> res = List.filled(basis.length, null);

    for(final ClothParams clothParams in cloth){
      if(clothParams.cloth.id % 100 == 42){
        continue;
      }

      final int index = basis.indexOf(clothParams.cloth.clothType);
      if(index == -1){
        res.add(clothParams);
      }else{
        res[index] = clothParams;
      }
    }

    return res.nonNulls.toList();
  }

  int? getDyeZone(Nuan5DatabaseReaderV1 reader, int id, int featureTag, int targetGroupId){
    final Map<int, Nuan5DatabaseItem> read = reader.getSync(category: Nuan5DatabaseCategory.clothDyeArea, ids: [id]);
    final Nuan5ClothDyeArea? data = read[id]?.whenOrNull(
      clothDyeArea: (Nuan5ClothDyeArea d) => d,
    );

    if(data == null){
      return null;
    }

    int zone;
    if(featureTag == 3){
      zone = data.maxColorAreaNum + targetGroupId;
    }else{
      zone = targetGroupId;
    }

    if(featureTag == 1 || featureTag == 3){
      if(data.customAreaOrder.contains(zone)){
        zone = 1 + data.customAreaOrder.indexOf(zone);
      }else{
        zone += data.customAreaOrder.where((int t) => t > zone).length;
      }
    }

    return zone;
  }

  int getColorPalette(int grid){
    return grid == -1 ? -1 : 1 + grid ~/ 8;
  }

  int? getColorSwatch(int grid){
    return grid == -1 ? null : grid % 8 == 0 ? 8 : grid % 8;
  }

  (double, double, double, double)? getSwatchRGBAColor(Nuan5DatabaseReaderV1 reader, int grid){
    final Map<int, Nuan5DatabaseItem> read = reader.getSync(category: Nuan5DatabaseCategory.clothDiySwatchColor, ids: [grid]);

    final Nuan5ClothDiySwatchColor? data = read[grid]?.whenOrNull(
      clothDiySwatchColor: (Nuan5ClothDiySwatchColor d) => d,
    );
    if(data == null){
      return null;
    }

    return (data.rgba[0], data.rgba[1], data.rgba[2], data.rgba[3]);
  }

  int _generateAvailableId(int id){
    const int outfitSize = 10000;
    const int clothTypeSize = 100;
    const int stateSize = 10;
    const int speciesSize = 1000;

    final int outfitFeature = id % outfitSize;
    id ~/= outfitSize;

    final int clothType = id % clothTypeSize;
    id ~/= clothTypeSize;

    final int state = id % stateSize;
    id ~/= stateSize;

    final int species = id % speciesSize;

    int availableState = switch(state){
      1 => 1,
      9 => 9,
      _ => 0,
    };
    int availableId = 0;
    availableId = availableId * speciesSize + species;
    availableId = availableId * stateSize + availableState;
    availableId = availableId * clothTypeSize + clothType;
    availableId = availableId * outfitSize + outfitFeature;
    return availableId;
  }

  int? getColorPaletteSerialNumber(Nuan5DatabaseReaderV1 reader, int id, int palette){
    final int availableId = _generateAvailableId(id);

    final Map<int, Nuan5DatabaseItem> read = reader.getSync(category: Nuan5DatabaseCategory.clothDyePalette, ids: [availableId]);

    final Nuan5ClothDyePalette? data = read[availableId]?.whenOrNull(
      clothDyePalette: (Nuan5ClothDyePalette d) => d,
    );

    if(data == null){
      return null;
    }

    int serialNumber = 0;
    for(final List<int> currentData in [
      data.directly,
      data.complete,
      data.growUp,
      data.evolution1,
      data.evolution2,
    ]){
      for(final int currentPalette in currentData){
        serialNumber++;
        if(currentPalette == palette){
          return serialNumber;
        }
      }
    }

    return null;
  }

  String? getColorPaletteSerialNumberStr(Nuan5DatabaseReaderV1 reader, int id, int palette){
    final int? serialNumber = getColorPaletteSerialNumber(reader, id, palette);
    if(serialNumber == null){
      return null;
    }

    return serialNumber.toString().padLeft(2, "0");
  }

  DyeCondition? getClothDyeCondition(Nuan5DatabaseReaderV1 reader, ClothParams clothParams){
    if(clothParams.diy == null){
      return DyeCondition.directly;
    }

    final DiyData diyData = clothParams.diy!;

    if(diyData.specialEffect.isNotEmpty){
      return DyeCondition.evolution_3;
    }

    if(diyData.outfitDye.isEmpty){
      return DyeCondition.directly;
    }

    final int availableId = _generateAvailableId(clothParams.cloth.id);
    final Map<int, Nuan5DatabaseItem> read = reader.getSync(category: Nuan5DatabaseCategory.clothDyePalette, ids: [availableId]);

    final Nuan5ClothDyePalette? data = read[availableId]?.whenOrNull(
      clothDyePalette: (Nuan5ClothDyePalette d) => d,
    );

    if(data == null){
      return null;
    }

    final List<List<int>> clothDyePaletteData = [
      data.directly,
      data.complete,
      data.growUp,
      data.evolution1,
      data.evolution2,
    ];

    int condition = 0;
    for(final OutfitDyeData outfitDyeData in diyData.outfitDye){
      if(condition == -1){
        return DyeCondition.evolution_3;
      }

      outfitDyeData.when(
        hair: (OutfitDyeHairData outfitDyeHairData){
          final int palette0 = getColorPalette(outfitDyeHairData.color0.colorGrid);
          condition = _updateCondition(clothDyePaletteData, palette0, condition);

          if(outfitDyeHairData.color1 != null){
            final int palette1 = getColorPalette(outfitDyeHairData.color1!.colorGrid);
            condition = _updateCondition(clothDyePaletteData, palette1, condition);
          }
        },
        general: (OutfitDyeGeneralData outfitDyeGeneralData){
          final int palette = getColorPalette(outfitDyeGeneralData.color.colorGrid);
          condition = _updateCondition(clothDyePaletteData, palette, condition);
        }
      );
    }

    const Map<int, DyeCondition> map = {
      -1: DyeCondition.evolution_3,
      0: DyeCondition.directly,
      1: DyeCondition.complete,
      2: DyeCondition.growUp,
      3: DyeCondition.evolution_1,
      4: DyeCondition.evolution_2,
    };

    return map[condition];
  }

  int _updateCondition(List<List<int>> clothDyePaletteData, int palette, int old){
    if(palette == -1 || old == -1){
      return -1;
    }

    if(old == clothDyePaletteData.length - 1){
      return old;
    }

    for(final (index, currentData) in clothDyePaletteData.indexed){
      if(currentData.contains(palette)){
        return max(old, index);
      }
    }
    return old;
  }

  DyeCondition? getDyeCondition(Nuan5DatabaseReaderV1 reader, List<ClothParams> cloth){
    DyeCondition? res;

    for(final ClothParams clothParams in cloth){
      final DyeCondition? condition = getClothDyeCondition(reader, clothParams);

      if(condition == null){
        continue;
      }

      if(res == null){
        res = condition;
      }else{
        res = res > condition ? res : condition;
      }
    }

    return res;
  }
}


