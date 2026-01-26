import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Model/frame_model.dart';

class SmartGateResult {
  SmartGateMetrics metrics;
  final List<FrameModel> bestFrames;

  SmartGateResult({
    required this.metrics,
    required this.bestFrames,
  });
}

class SmartGateMetrics{
  final int totalFramesProcessed;
  final int totalFramesAccepted;
  final double avgSharpness;
  final double avgExposure;
  final double avgMotion;
  final double avgTotalScore;
  final double avgFps;
  final double avgProcessingTime;

   SmartGateMetrics({
     required this.totalFramesProcessed,
     required this.totalFramesAccepted,
     required this.avgSharpness,
     required this.avgExposure,
     required this.avgMotion,
     required this.avgTotalScore,
     required this.avgFps,
     required this.avgProcessingTime
   });
}
