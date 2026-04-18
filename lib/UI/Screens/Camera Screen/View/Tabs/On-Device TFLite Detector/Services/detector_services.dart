import 'dart:math';

import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';

import '../Model/detector_result_model.dart';
import '../Model/resize_result.dart';

class DetectorServices {
  // PreProcessing
  static ResizeResult resizeImageIsolate((int, img.Image) args) {
    return resizeImage(args.$1, args.$2);
  }

  static img.Image convertCameraImage(CameraImage frame) {
    final int width = frame.width;
    final int height = frame.height;

    var destImage = img.Image(width: width, height: height);

    final yPlane = frame.planes[0].bytes;
    final uPlane = frame.planes[1].bytes;
    final vPlane = frame.planes[2].bytes;

    final int yRowStride = frame.planes[0].bytesPerRow;
    final int uvRowStride = frame.planes[1].bytesPerRow;
    final int uvPixelStride = frame.planes[1].bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex = (uvPixelStride * (x / 2).floor()) + (uvRowStride * (y / 2).floor());
        final int yIndex = (y * yRowStride) + x;

        final int yp = yPlane[yIndex];
        final int up = uPlane[uvIndex];
        final int vp = vPlane[uvIndex];

        int r = (yp + (1.370705 * (vp - 128))).round().clamp(0, 255);
        int g = (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128))).round().clamp(0, 255);
        int b = (yp + (1.732446 * (up - 128))).round().clamp(0, 255);

        destImage.setPixelRgb(x, y, r, g, b);
      }
    }
    return img.copyRotate(destImage, angle: 90);
  }

  static ResizeResult resizeImage(int targetSize, img.Image src) {
    int srcWidth  = src.width;
    int srcHeight = src.height;

    double ratio = min(targetSize / srcWidth, targetSize / srcHeight);

    int newWidth  = (ratio * srcWidth).round();
    int newHeight = (ratio * srcHeight).round();

    img.Image resizedImage = img.copyResize(src, width: newWidth, height: newHeight);

    img.Image canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(0, 0, 0));

    int xOff = (targetSize - newWidth)  ~/ 2;
    int yOff = (targetSize - newHeight) ~/ 2;

    img.Image finalImage = img.compositeImage(canvas, resizedImage, dstX: xOff, dstY: yOff);

    return ResizeResult(        // ✅ return everything
      image: finalImage,
      ratio: ratio,
      xOff: xOff,
      yOff: yOff,
      newWidth: newWidth,
      newHeight: newHeight,
    );
  }

  static Uint8List convertToUint8Tensor(img.Image letterboxedImage) {
    var buffer = Uint8List(1 * 300 * 300 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 300; y++) {
      for (int x = 0; x < 300; x++) {
        var pixel = letterboxedImage.getPixel(x, y);
        buffer[pixelIndex++] = pixel.r.toInt();
        buffer[pixelIndex++] = pixel.g.toInt();
        buffer[pixelIndex++] = pixel.b.toInt();
      }
    }
    return buffer;
  }

  // PostProcessing

  static List<Recognition> applyNMS(List<Recognition> detections,double ratio){
    detections.sort((a, b) => b.score.compareTo(a.score));
    List<Recognition> box=[];
    while(detections.isNotEmpty){
      final bestScore = detections.removeAt(0);
      box.add(bestScore);
     detections.removeWhere((location)=> _iou(bestScore.location, location.location) > ratio);

    }
    return box;
  }

 static double _iou(Rect a, Rect b) {
    final intersection = a.intersect(b);
    if (intersection.isEmpty) return 0.0;
    final interArea = intersection.width * intersection.height;
    final unionArea = (a.width * a.height) + (b.width * b.height) - interArea;
    return unionArea <= 0 ? 0.0 : interArea / unionArea;
  }
}