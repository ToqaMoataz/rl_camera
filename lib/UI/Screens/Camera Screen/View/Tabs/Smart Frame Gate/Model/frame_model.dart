import 'dart:typed_data';

import 'package:camera/camera.dart';

class FrameModel {
  Uint8List frame;
  double blurScore;
  double shakeScore;
  double brightnessScore;
  double score;
  bool isAccepted;

  FrameModel({
    required this.frame,
    required this.score,
    required this.isAccepted,
    required this.blurScore,
    required this.brightnessScore,
    required this.shakeScore,
  });
}
