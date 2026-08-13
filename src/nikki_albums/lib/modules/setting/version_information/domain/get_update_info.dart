
import "package:nikki_albums/info.dart";
import "../model/update_info.dart";

import "package:dio/dio.dart";


Future<UpdateInfo?> getUpdateInfo() async{
  try{
    final response = await Dio().get<Map>(
      apiUrl,
      options: Options(
        headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"},
        responseType: ResponseType.json,
      ),
    );

    if(response.statusCode != 200 || response.data == null) return null;

    final Map json = response.data!;

    return UpdateInfo.fromJson(json);
  }catch(e){
    return null;
  }
}