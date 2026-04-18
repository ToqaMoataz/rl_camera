import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Model/detector_result_model.dart';

class DetectionDrawer extends CustomPainter {
  List<Recognition> recognitions;
  DetectionDrawer({required this.recognitions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MainColors.getPrimaryColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var recognition in recognitions) {

      canvas.drawRect(recognition.location, paint);

      textPainter.text = TextSpan(
        text: "${recognition.label} ${(recognition.score * 100).toStringAsFixed(0)}%",
        style: TextStyle(color: Colors.red, backgroundColor: Colors.white, fontSize: 16),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(
        recognition.location.left,
        recognition.location.top - 20,
      ));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
