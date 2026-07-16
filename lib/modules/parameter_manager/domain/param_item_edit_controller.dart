
import "code_parser.dart";
import "../model/param_item.dart";
import "../model/param_type.dart";
import "package:nikki_albums/src/rust/nuan5_params/structs/building_params.dart";

import "package:flutter/material.dart";


class ParamItemEditController extends ChangeNotifier{
  final String? initName;
  final String? initCode;
  final ParamItemCover? initCover;
  final ParamType? initParamType;
  final bool createMode;

  ParamItemEditController({
    this.initName,
    this.initCode,
    this.initCover,
    this.initParamType,
    this.createMode = false,
  }){
    _init();
  }


  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController codeTextController = TextEditingController();
  dynamic _param;
  final ValueNotifier<ParamItemCover?> cover = ValueNotifier(null);
  ParamType _paramType = ParamType.camera;

  void onCodeTextChanged(){
    tryDeCodeDebounce(codeTextController.text, onFinished: _setParam);
  }

  Future<void> _init() async{
    if(initCode == null){
      if(initParamType != null) _paramType = initParamType!;
      if(initName != null) nameTextController.text = initName!;
      if(initCover != null) cover.value = initCover!;
    }else{
      codeTextController.text = initCode!;
      if(initParamType == null){
        final dynamic param = await tryDeCode(initCode!);
        _setParam(param);
      }else{
        await setParamType(initParamType!);
      }

      if(initName != null){
        nameTextController.text = initName!;
      }
      if(initCover != null){
        cover.value = initCover;
      }
    }

    codeTextController.addListener(onCodeTextChanged);
  }

  String get code => codeTextController.text;
  dynamic get param => _param;
  ParamType get paramType => _paramType;

  Future<void> setParamType(ParamType newParamType) async{
    if(newParamType == _paramType){
      return;
    }

    _paramType = newParamType;

    final dynamic newParam = await tryDeByType(_paramType, codeTextController.text);
    _setParam(newParam);
  }

  void _setParam(dynamic newParam){
    _param = newParam;
    final ParamType? newType = getTypeByParam(newParam);
    if(newType != null){
      _paramType = newType;
    }

    /// 自动填充家园建造参数的方案名与方案名陈
    if(newType == ParamType.home){
      final RichBuildingParams homeBuildingParams = newParam as RichBuildingParams;

      nameTextController.text = homeBuildingParams.name;
      if(homeBuildingParams.coverImage != null){
        cover.value = NetworkParamItemCover(path: homeBuildingParams.coverImage!);
      }
    }

    notifyListeners();
  }

  @override
  void dispose(){
    nameTextController.dispose();
    codeTextController.dispose();
    cover.dispose();
    super.dispose();
  }
}