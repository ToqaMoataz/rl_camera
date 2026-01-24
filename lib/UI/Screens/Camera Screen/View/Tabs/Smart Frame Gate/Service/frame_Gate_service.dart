import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;


class FrameGateFunctions {

  static const double _sharpnessThreshold = 0.1;
  static const double _motionThreshold = 0.4;
  static const double _exposureLow = 0.1;
  static const double _exposureHigh = 0.7;


  static Uint8List convertYUV420ToJpg(CameraImage image) {
    try {
      final int width = image.width;
      final int height = image.height;
      final img.Image resultImage = img.Image(width: width, height: height);

      final plane = image.planes[0];
      final bytes = plane.bytes;
      final int rowStride = plane.bytesPerRow;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int pixelIndex = y * rowStride + x;
          final int greyValue = bytes[pixelIndex];
          resultImage.setPixelRgb(x, y, greyValue, greyValue, greyValue);
        }
      }
      final img.Image rotatedImage = img.copyRotate(resultImage, angle: 90);

      return Uint8List.fromList(img.encodeJpg(rotatedImage, quality: 85));
    } catch (e) {
      return Uint8List(0);
    }
  }

  static double calculateSharpnessNormalized(CameraImage image) {
    final bytes = image.planes[0].bytes;
    double sum = 0;
    double sumSquared = 0;
    const int step = 8;

    for (int i = 0; i < bytes.length; i += step) {
      double val = bytes[i].toDouble();
      sum += val;
      sumSquared += val * val;
    }

    int count = bytes.length ~/ step;
    double mean = sum / count;
    double variance = (sumSquared / count) - (mean * mean);

    // تعديل: رفع المعامل لـ 10000 لزيادة نطاق القياس
    return (variance / 10000.0).clamp(0.0, 1.0);
  }

  static double calculateMotionNormalized(CameraImage current, CameraImage? previous) {
    if (previous == null) return 0.0;

    final currBytes = current.planes[0].bytes;
    final prevBytes = previous.planes[0].bytes;

    double totalDifference = 0;
    const int step = 15;

    for (int i = 0; i < currBytes.length; i += step) {
      totalDifference += (currBytes[i] - prevBytes[i]).abs();
    }

    double avgDiff = totalDifference / (currBytes.length / step);
    return (avgDiff / 80.0).clamp(0.0, 1.0);
  }

  static double calculateExposureNormalized(CameraImage image) {
    final bytes = image.planes[0].bytes;
    int sum = 0;
    const int step = 20;

    for (int i = 0; i < bytes.length; i += step) {
      sum += bytes[i];
    }

    double average = sum / (bytes.length / step);
    return average / 255.0;
  }

  static double calculateTotalScore(double exp, double sharp, double stab) {
    return (exp + sharp + stab) / 3.0;
  }

  static bool returnAccepted({
    required double sharpness,
    required double exposure,
    required double motion,
  }) {
    return (sharpness >= _sharpnessThreshold && //0.1
        exposure >= _exposureLow &&
        exposure <= _exposureHigh && // 0.1   0.7
        motion <= _motionThreshold); //0.4
  }
}
