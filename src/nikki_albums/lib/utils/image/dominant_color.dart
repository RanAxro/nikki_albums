
import "package:flutter/painting.dart";
import "dart:math";
import "dart:typed_data";
import "dart:ui" as ui;

/// 通过图片字节获取主色调
/// [imageBytes] 图片字节数据
/// [k] K-Means聚类数量，默认3
/// 返回主色 Color
Future<Color?> getDominantColor(Uint8List imageBytes, {int k = 3}) async{
  // 将字节解码为Flutter Image
  final ui.Codec codec = await ui.instantiateImageCodec(imageBytes, targetWidth: 150, targetHeight: 150);
  final ui.FrameInfo frame = await codec.getNextFrame();
  final ui.Image image = frame.image;

  // 读取像素数据
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  if(byteData == null) throw Exception("无法读取像素数据");

  final Uint8List pixels = byteData.buffer.asUint8List();

  // 收集RGB像素（跳过Alpha通道）
  final List<List<int>> rgbPixels = <List<int>>[];
  for(int i = 0; i < pixels.length; i += 4){
    rgbPixels.add([
      pixels[i],     // R
      pixels[i + 1], // G
      pixels[i + 2], // B
    ]);
  }

  // K-Means聚类
  final List<List<List<int>>> clusters = _kMeans(rgbPixels, k);

  // 找到最大簇
  int maxCount = 0;
  List<int>? dominantColor;

  for(final List<List<int>> cluster in clusters){
    if(cluster.length > maxCount){
      maxCount = cluster.length;
      dominantColor = _calculateCentroid(cluster);
    }
  }

  // 释放资源
  image.dispose();

  if(dominantColor == null){
    return null;
  }

  return Color.fromRGBO(
    dominantColor[0],
    dominantColor[1],
    dominantColor[2],
    1.0,
  );
}

/// K-Means聚类算法
List<List<List<int>>> _kMeans(List<List<int>> pixels, int k){
  final Random random = Random();
  final int n = pixels.length;

  // 随机初始化中心点
  final List<List<double>> centroids = List<List<double>>.generate(k, (_){
    final int idx = random.nextInt(n);
    return [
      pixels[idx][0].toDouble(),
      pixels[idx][1].toDouble(),
      pixels[idx][2].toDouble(),
    ];
  });

  final List<List<List<int>>> clusters = List<List<List<int>>>.generate(k, (_) => []);

  // 迭代优化（最多10次）
  for(int iter = 0; iter < 10; iter++){
    // 清空簇
    for(int i = 0; i < k; i++){
      clusters[i].clear();
    }

    // 分配像素到最近中心
    for(final List<int> pixel in pixels){
      double minDist = double.infinity;
      int bestCluster = 0;

      for(int i = 0; i < k; i++){
        final double dist = _euclideanDistance(pixel, centroids[i]);
        if(dist < minDist){
          minDist = dist;
          bestCluster = i;
        }
      }

      clusters[bestCluster].add(pixel);
    }

    // 更新中心点
    bool changed = false;
    for(int i = 0; i < k; i++){
      if(clusters[i].isEmpty) continue;

      final List<double> newCentroid = _calculateCentroidDouble(clusters[i]);
      if(_distance(centroids[i], newCentroid) > 0.01){
        changed = true;
      }
      centroids[i] = newCentroid;
    }

    if(!changed) break;
  }

  return clusters;
}

/// 欧几里得距离
double _euclideanDistance(List<int> a, List<double> b){
  final double d0 = a[0] - b[0];
  final double d1 = a[1] - b[1];
  final double d2 = a[2] - b[2];
  return sqrt(d0 * d0 + d1 * d1 + d2 * d2);
}

/// 计算整数中心点
List<int> _calculateCentroid(List<List<int>> cluster){
  int r = 0, g = 0, b = 0;
  for(final List<int> pixel in cluster){
    r += pixel[0];
    g += pixel[1];
    b += pixel[2];
  }
  final int n = cluster.length;
  return [r ~/ n, g ~/ n, b ~/ n];
}

/// 计算浮点中心点
List<double> _calculateCentroidDouble(List<List<int>> cluster){
  double r = 0.0, g = 0.0, b = 0.0;
  for(final List<int> pixel in cluster){
    r += pixel[0];
    g += pixel[1];
    b += pixel[2];
  }
  final int n = cluster.length;
  return [r / n, g / n, b / n];
}

/// 中心点变化距离
double _distance(List<double> a, List<double> b){
  return sqrt((a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1]) + (a[2] - b[2]) * (a[2] - b[2]));
}

double sqrt(double x) => x <= 0 ? 0 : exp(0.5 * log(x));