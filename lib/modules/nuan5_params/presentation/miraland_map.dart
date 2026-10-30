
import "package:nikki_albums/modules/nuan5_params/domain/config.dart";

import "package:flutter/material.dart";
import "dart:math" as math;

import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";


class MiralandMap extends StatelessWidget{
  final Offset? markerPoint;
  final Nuan5WorldMapTileInfo info;
  final void Function()? onSecondaryTap;

  const MiralandMap({super.key, this.markerPoint, required this.info, this.onSecondaryTap});

  @override
  Widget build(BuildContext context) {
    final MiralandCoords mc = MiralandCoords(
      zoom: info.maxZoom,
      width: info.mapWidthOfMaxZoom,
      height: info.mapHeightOfMaxZoom,
      originalPointX: info.originalPointX,
      originalPointY: info.originalPointY,
      pxPreUnit: info.pxPreUnit,
    );

    return FlutterMap(
      options: MapOptions(
        crs: const CrsSimple(),
        initialCenter: mc.coordsToLatLng(x: markerPoint!.dx, y: markerPoint!.dy),
        initialZoom: info.maxZoom.toDouble(),
        minZoom: 0,
        maxZoom: info.maxZoom + 2,
        cameraConstraint: CameraConstraint.containCenter(
          bounds: mc.getMaxBounds(),
        ),
        onSecondaryTap: (_, _){
          onSecondaryTap?.call();
        }
      ),
      children: [
        TileLayer(
          urlTemplate: info.urlTemplate,
          maxNativeZoom: info.maxZoom,
          minNativeZoom: info.minZoom,
        ),
        MarkerLayer(
          markers: [
            if(markerPoint != null)
              Marker(
                point: mc.coordsToLatLng(x: markerPoint!.dx, y: markerPoint!.dy),
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.red),
              ),
          ],
        ),
      ],
    );
  }
}

class MiralandCoords {
  final int zoom;
  final int width;
  final int height;
  final double originalPointX;
  final double originalPointY;
  final double pxPreUnit;

  const MiralandCoords({
    required this.zoom,
    required this.width,
    required this.height,
    required this.originalPointX,
    required this.originalPointY,
    required this.pxPreUnit,
  }) : assert(zoom >= 0),
       assert(width > 0),
       assert(height > 0),
       assert(pxPreUnit > 0);

  LatLng pixelToLatLng({required double x, required double y}) {
    final double scale = 256 * math.pow(2, zoom).toDouble();
    return LatLng(-y / scale, x / scale);
  }

  LatLng coordsToLatLng({required double x, required double y}) {
    return pixelToLatLng(
      x: originalPointX + x * pxPreUnit,
      y: originalPointY + y * pxPreUnit,
    );
  }

  LatLngBounds getMaxBounds() {
    return LatLngBounds(
      pixelToLatLng(x: width.toDouble(), y: height.toDouble()),
      pixelToLatLng(x: 0, y: 0),
    );
  }
}
