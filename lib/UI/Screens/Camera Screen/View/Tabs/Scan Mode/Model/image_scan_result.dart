import 'package:camera/camera.dart';

class ScanResultModel {
  XFile original;
  XFile processed;
  ScanMetrics metrics;

  ScanResultModel({required this.original,required this.processed,required this.metrics});
}

class ScanMetrics{
  String originalResolution;
  String scannedResolution;
  int processingTimeInMillSecond;
  ScanMetrics({required this.originalResolution,required this.scannedResolution,required this.processingTimeInMillSecond});
}