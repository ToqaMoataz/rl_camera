import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Scan%20Mode/Model/image_scan_result.dart';

import '../../../../Connector/connector.dart';

class ScanViewModel extends ChangeNotifier {
  Connector? connector;
  ScanResultModel? result;
  ScanMetrics? metrics;
  XFile? originalImage;
  XFile? processed;

  Future<void> captureImage(CameraController controller) async {
    connector!.onLoading();
    try {
      final XFile capturedImage = await controller.takePicture();
      final bytes = await capturedImage.readAsBytes();

      img.Image original = img.decodeImage(bytes)!;
      final XFile processedImage = await _processImage(original);
      originalImage=capturedImage;
      processed=processedImage;
      if(metrics!=null){
      result = ScanResultModel(
          original: capturedImage,
          processed: processedImage,
          metrics: metrics!
      );}
      notifyListeners();
      connector!.removeLoading();
      connector!.showSuccess();
    } catch (e) {
      connector!.removeLoading();
      connector!.showError(e.toString());
    }
  }


  Future<XFile> _processImage(img.Image image) async {
    final startTime = DateTime.now();
    //grayscale
    img.Image processed = img.grayscale(image);
    //processed=deskew(image);
    //crop content
    processed = cropSquareWithScale(processed);
    //Contrast
    processed = img.adjustColor(processed, contrast: 1.5);
    //Threshold
    processed = img.luminanceThreshold(processed, threshold: 0.5);
    final endTime = DateTime.now();
    final processingTime = endTime.difference(startTime).inMilliseconds;
    //save in specific path
    final jpgBytes = img.encodeJpg(processed);
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/scan_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final file = File(path);
    await file.writeAsBytes(jpgBytes);

    metrics=ScanMetrics(originalResolution: '${image.width}X${image.height}'
        , scannedResolution: '${processed.width}X${processed.height}',
        processingTimeInMillSecond: processingTime
    );
    notifyListeners();
    return XFile(file.path);
  }


  img.Image cropSquareWithScale(img.Image src, {double scale = 0.7}) {
    int width = (src.width * scale).toInt();
    int height = (src.height * scale).toInt();

    int x = (src.width - width) ~/ 2;
    int y = (src.height - height) ~/ 2;

    return img.copyCrop(src, x: x, y: y, width: width, height: height);
  }

  img.Image detectEdges(img.Image image){
    return img.sobel(image);
  }



  img.Image deskew(img.Image gray) {
    int minX = gray.width, maxX = 0, minY = gray.height, maxY = 0;

    for (int y = 0; y < gray.height; y++) {
      for (int x = 0; x < gray.width; x++) {
        if (img.getLuminance(gray.getPixel(x, y)) < 128) {
          minX = min(minX, x);
          maxX = max(maxX, x);
          minY = min(minY, y);
          maxY = max(maxY, y);
        }
      }
    }

    double dx = (maxX - minX).toDouble();
    double dy = (maxY - minY).toDouble();
    double angle = atan2(dy, dx);

    if (angle.abs() < 0.01) return gray;

    return img.copyRotate(gray, angle: -angle * 180 / pi);
  }


}
