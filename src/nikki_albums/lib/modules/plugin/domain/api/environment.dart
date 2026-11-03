
import "dart:io";


int getAppVersion(){
  return 0;
}

int getApiVersion(){
  return 0;
}

String? getEnv(String key){
  return Platform.environment[key];
}

String getLocalHostname(){
  return Platform.localHostname;
}