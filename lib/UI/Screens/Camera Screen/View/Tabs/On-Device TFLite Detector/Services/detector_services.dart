import 'dart:math';

import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';

class DetectorServices {
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

  static img.Image resizeImage(int targetSize, img.Image src){
    int srcWidth=src.width;
    int srcHeight=src.height;

    double ratio = min(targetSize / srcWidth, targetSize / srcHeight);

    int newWidth=(ratio * srcWidth).round();
    int newHeight=(ratio * srcHeight).round();

    img.Image resizedImage=img.copyResize(src, width: newWidth, height: newHeight);

    img.Image canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(0, 0, 0));

    int xOff = (targetSize - newWidth) ~/ 2;
    int yOff = (targetSize - newHeight) ~/ 2;

    return img.compositeImage(canvas, resizedImage, dstX: xOff, dstY: yOff);

  }

  static Uint8List convertToUint8Tensor(img.Image letterboxedImage) {
    var buffer = Uint8List(1 * 300 * 300 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 300; y++) {
      for (int x = 0; x < 300; x++) {
        var pixel = letterboxedImage.getPixel(x, y);
        buffer[pixelIndex++] = pixel.r.toInt();
        buffer[pixelIndex++] = pixel.r.toInt();
        buffer[pixelIndex++] = pixel.r.toInt();
      }
    }
    return buffer;
  }
}