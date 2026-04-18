import 'package:image/image.dart' as img;

class ResizeResult {
  final img.Image image;
  final double ratio;
  final int xOff;
  final int yOff;
  final int newWidth;
  final int newHeight;

  ResizeResult({
    required this.image,
    required this.ratio,
    required this.xOff,
    required this.yOff,
    required this.newWidth,
    required this.newHeight,
  });
}