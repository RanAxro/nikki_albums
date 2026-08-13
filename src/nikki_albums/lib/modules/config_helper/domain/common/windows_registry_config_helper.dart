
export "package:nikki_albums/src/rust/config/common/windows_registry_config.dart";

import "package:nikki_albums/src/rust/config/common/windows_registry_config.dart";
import "package:nikki_albums/utils/extension.dart";

import "dart:convert";

import "package:win32/win32.dart";
import "package:win32_registry/win32_registry.dart";


abstract final class WindowsRegistryConfigHelper{
  static T? _read<T>(WindowsRegistryConfig config, T? Function(RegistryKey) reader){
    late final T? value;
    try{
      final RegistryKey key = Registry.openPath(
        _toRegistryHive(config.hive),
        path: config.path,
        desiredAccessRights: AccessRights.readOnly,
      );
      value = reader(key);
      try{
        key.close();
      }catch(e){
        // RegistryKey 释放失败
      }
    }on WindowsException catch(e){
      // 键值/路径不存在 ERROR_FILE_NOT_FOUND == 2
      if(e.hr == ERROR_FILE_NOT_FOUND){
        value = null;
      }
      // 其他异常
      else{
        value = null;
      }
    }catch(e){
      // 读取注册表失败
    }
    return value;
  }

  static RegistryHive _toRegistryHive(WindowsRegistryHive hive){
    return switch(hive){
      WindowsRegistryHive.classesRoot => RegistryHive.classesRoot,
      WindowsRegistryHive.currentUser => RegistryHive.currentUser,
      WindowsRegistryHive.localMachine => RegistryHive.localMachine,
      WindowsRegistryHive.allUsers => RegistryHive.allUsers,
      WindowsRegistryHive.performanceData => RegistryHive.performanceData,
      WindowsRegistryHive.currentConfig => RegistryHive.currentConfig,
    };
  }

  static RegistryValue? resolveByConfig(WindowsRegistryConfig config){
    return _read(config, (key) => key.getValue(config.valueName));
  }

  static Object? resolveByConfigAsObject(WindowsRegistryConfig config){
    return _read(config, (key) => switch(config.valueType){
      WindowsRegistryValueType.binary => key.getBinaryValue(config.valueName),
      WindowsRegistryValueType.int => key.getIntValue(config.valueName),
      WindowsRegistryValueType.string => key.getStringValue(config.valueName),
      WindowsRegistryValueType.stringArray => key.getStringArrayValue(config.valueName),
    });
  }

  static String? resolveByConfigAsString(WindowsRegistryConfig config){
    return _read(config, (key) => switch(config.valueType){
      WindowsRegistryValueType.binary => key.getBinaryValue(config.valueName).let(utf8.decode),
      WindowsRegistryValueType.int => key.getIntValue(config.valueName).toString(),
      WindowsRegistryValueType.string => key.getStringValue(config.valueName),
      WindowsRegistryValueType.stringArray => key.getStringArrayValue(config.valueName)?.firstOrNull,
    });
  }
}