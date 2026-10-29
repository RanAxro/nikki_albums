
import "dart:typed_data";

import "package:win32_registry/win32_registry.dart";


final int HKEY_CLASSES_ROOT = RegistryHive.classesRoot.value;
final int HKEY_CURRENT_USER = RegistryHive.currentUser.value;
final int HKEY_LOCAL_MACHINE = RegistryHive.localMachine.value;
final int HKEY_USERS = RegistryHive.allUsers.value;
final int HKEY_PERFORMANCE_DATA = RegistryHive.performanceData.value;
final int HKEY_CURRENT_CONFIG = RegistryHive.currentConfig.value;

String? readString(int hkey, String path, String name){
  return _readValue(hkey, path, (RegistryKey key){
    return key.getStringValue(name);
  });
}

List<String>? readMultiString(int hkey, String path, String name){
  return _readValue(hkey, path, (RegistryKey key){
    return key.getStringArrayValue(name);
  });
}

int? readInt(int hkey, String path, String name){
  return _readValue(hkey, path, (RegistryKey key){
    return key.getIntValue(name);
  });
}

Uint8List? readBinary(int hkey, String path, String name){
  return _readValue(hkey, path, (RegistryKey key){
    return key.getBinaryValue(name);
  });
}

T _readValue<T>(int hkey, String path, T Function(RegistryKey) callback){
  final RegistryHive hive = RegistryHive.fromWin32(hkey);
  final RegistryKey key = Registry.openPath(hive, path: path, desiredAccessRights: AccessRights.readOnly);
  final T value = callback(key);
  key.close();
  return value;
}