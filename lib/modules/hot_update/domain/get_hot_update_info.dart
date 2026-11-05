import "package:nikki_albums/info.dart";
import "../model/hot_update_info.dart";

import "package:dio/dio.dart";

Future<List<HotUpdateInfo>> getUpdateInfo() async {
  final List<HotUpdateInfo> res = [];
  final Dio dio = Dio(
    BaseOptions(
      headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  try {
    final response = await dio.get<List>(
      hotUpdateApi,
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode != 200 || response.data == null) return res;

    final List json = response.data!;

    res.addAll(json.map(HotUpdateInfo.fromJson).whereType<HotUpdateInfo>());

    return res;
  } catch (e) {
    return res;
  } finally {
    dio.close();
  }
}
