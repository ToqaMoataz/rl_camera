import 'dart:typed_data';
import 'dart:ui';

class PreProcessingResultModel {
  final Uint8List tensor;
  final Size originalImageSize;
  final double ratio;
  final int xOff;
  final int yOff;

  PreProcessingResultModel({
    required this.tensor,
    required this.originalImageSize,
    required this.ratio,
    required this.xOff,
    required this.yOff,
  });
}
