import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/Connector/connector.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Model/filter_result_model.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Service/frame_Gate_service.dart';
import '../../../../../../../Core/Costants/constants.dart';
import '../Model/frame_model.dart';

typedef FramePair = (CameraImage curr, CameraImage? prev);


class _FrameResult {
  final Uint8List img;
  final double totalScore;
  final double sharpness;
  final double exposure;
  final double motion;
  final int processingTimeMs;

  _FrameResult({
    required this.img,
    required this.totalScore,
    required this.sharpness,
    required this.exposure,
    required this.motion,
    required this.processingTimeMs,
  });
}


Future<_FrameResult?> _processingFrame(FramePair frames) async {
  final currFrame = frames.$1;
  final prevFrame = frames.$2;

  final start = DateTime.now();

  double sharpness = FrameGateFunctions.calculateSharpnessNormalized(currFrame);
  double exposure  = FrameGateFunctions.calculateExposureNormalized(currFrame);
  double motion    = FrameGateFunctions.calculateMotionNormalized(currFrame, prevFrame);

  bool accepted = FrameGateFunctions.returnAccepted(
    sharpness: sharpness,
    exposure: exposure,
    motion: motion,
  );

  final processingTimeMs = DateTime.now().difference(start).inMilliseconds;

  if (!accepted) return null;

  double totalScore = FrameGateFunctions.calculateTotalScore(exposure, sharpness, motion);
  Uint8List img     = FrameGateFunctions.convertYUV420ToJpg(currFrame);

  return _FrameResult(
    img: img,
    totalScore: totalScore,
    sharpness: sharpness,
    exposure: exposure,
    motion: motion,
    processingTimeMs: processingTimeMs,
  );
}

class SmartGateViewModel extends ChangeNotifier {
  SmartGateViewModel();

  static const int _maxFrames = 10;
  List<FrameModel> topFrames = [];
  SmartGateResult? result;
  Status filteringStatus = Status.init;

  Connector? connector;
  int _processedFramesCount = 0;
  int _totalProcessingTimeMs = 0;

  Future<void> startFiltering(CameraController controller) async {
    bool isStreaming = true;
    _processedFramesCount = 0;
    _totalProcessingTimeMs = 0;
    topFrames.clear();

    DateTime start             = DateTime.now();
    DateTime lastProcessedTime = DateTime.now();
    DateTime secondTimer       = DateTime.now();
    CameraImage? previous;
    const int processingIntervalMs = 250;

    try {
      filteringStatus = Status.loading;
      notifyListeners();

      controller.startImageStream((image) async {
        final now = DateTime.now();

        if (!isStreaming) return;
        if (now.difference(start).inMilliseconds <= 1000) return;

        if (now.difference(secondTimer).inSeconds >= 1) {
          secondTimer = now;
        }

        if (now.difference(lastProcessedTime).inMilliseconds < processingIntervalMs) return;

        if (now.difference(start).inSeconds <= 16) {
          lastProcessedTime = now;

          final frameResult = await compute(_processingFrame, (image, previous));

          _processedFramesCount++;

          if (frameResult != null) {
            _totalProcessingTimeMs += frameResult.processingTimeMs;

            _manageBestFrames(FrameModel(
              frame: frameResult.img,
              score: frameResult.totalScore,
              isAccepted: true,
              blurScore: frameResult.sharpness,
              brightnessScore: frameResult.exposure,
              shakeScore: frameResult.motion,
            ));
          }

          previous = image;
        } else {
          isStreaming = false;
          _stopStreaming(controller);
        }
      });
    } catch (e) {
      filteringStatus = Status.error;
      connector?.showError(e.toString());
      notifyListeners();
    }
  }

  void _manageBestFrames(FrameModel newFrame) {
    if (topFrames.length < _maxFrames) {
      topFrames.add(newFrame);
    } else if (newFrame.score > topFrames.last.score) {
      topFrames.last = newFrame;
    }
    topFrames.sort((a, b) => b.score.compareTo(a.score));
    notifyListeners();
  }

  Future<void> _stopStreaming(CameraController controller) async {
    await controller.stopImageStream();
    filteringStatus = Status.success;
    notifyListeners();

    if (topFrames.isNotEmpty) {
      final totalFramesAccepted = topFrames.length;

      final avgSharpness = topFrames
          .map((f) => f.blurScore)
          .reduce((a, b) => a + b) / topFrames.length;

      final avgExposure = topFrames
          .map((f) => f.brightnessScore)
          .reduce((a, b) => a + b) / topFrames.length;

      final avgMotion = topFrames
          .map((f) => f.shakeScore)
          .reduce((a, b) => a + b) / topFrames.length;

      final avgTotalScore = topFrames
          .map((f) => f.score)
          .reduce((a, b) => a + b) / topFrames.length;

      final double avgFps            = _processedFramesCount / 15.0;
      final double avgProcessingTime = _processedFramesCount > 0
          ? _totalProcessingTimeMs / _processedFramesCount
          : 0;

      result = SmartGateResult(
        metrics: SmartGateMetrics(
          totalFramesProcessed: _processedFramesCount,
          totalFramesAccepted:  totalFramesAccepted,
          avgSharpness:         avgSharpness,
          avgExposure:          avgExposure,
          avgMotion:            avgMotion,
          avgTotalScore:        avgTotalScore,
          avgFps:               avgFps,
          avgProcessingTime:    avgProcessingTime,
        ),
        bestFrames: List.from(topFrames),
      );
    }

    connector?.showSuccess();
  }
}