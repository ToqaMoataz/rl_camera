import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/Connector/connector.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Model/filter_result_model.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/Service/frame_Gate_service.dart';
import '../../../../../../../Core/Costants/constants.dart';
import '../Model/frame_model.dart';

class SmartGateViewModel extends ChangeNotifier {
  SmartGateViewModel();

  static const int _maxFrames = 10;
  List<FrameModel> topFrames = [];
  SmartGateResult? result;
  Status filteringStatus = Status.init;

  Connector? connector;
  int _processedFramesCount = 0;
  int _totalProcessingTimeMs = 0;

  void showMetrics() {
    if (topFrames.isNotEmpty) {
      for (int i = 0; i < topFrames.length; i++) {
        print("Frame Score: ${topFrames[i].score}");
        print("Frame Motion: ${topFrames[i].shakeScore}");
        print("Frame Brightness: ${topFrames[i].brightnessScore}");
        print("Frame Sharpness: ${topFrames[i].blurScore}");
      }
    }
    print("Length: ${topFrames.length}");
  }

  Future<void> startFiltering(CameraController controller) async {
    bool isStreaming = true;
    _processedFramesCount = 0;
    _totalProcessingTimeMs = 0;
    topFrames.clear();
    DateTime start = DateTime.now();
    DateTime lastProcessedTime = DateTime.now();
    DateTime secondTimer = DateTime.now();
    CameraImage? previous;
    const int processingIntervalMs = 250;

    try {
      filteringStatus = Status.loading;
      notifyListeners();

      controller.startImageStream((image) {
        final now = DateTime.now();

        if (!isStreaming) return;
        if (now.difference(start).inMilliseconds <= 1000) return;

        if (now.difference(secondTimer).inSeconds >= 1) {
          secondTimer = now;
        }

        if (now.difference(lastProcessedTime).inMilliseconds < processingIntervalMs) return;

        if (now.difference(start).inSeconds <= 16) {
          lastProcessedTime = now;
          _processingFrame(image, previous);

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

  void _processingFrame(CameraImage currFrame, CameraImage? prevFrame) {
    DateTime start=DateTime.now();
    double sharpness = FrameGateFunctions.calculateSharpnessNormalized(currFrame);
    double exposure = FrameGateFunctions.calculateExposureNormalized(currFrame);
    double motion = FrameGateFunctions.calculateMotionNormalized(currFrame, prevFrame);

    bool accepted = FrameGateFunctions.returnAccepted(
      sharpness: sharpness,
      exposure: exposure,
      motion: motion,
    );

    double totalScore = FrameGateFunctions.calculateTotalScore(exposure, sharpness, motion);
    Uint8List img = FrameGateFunctions.convertYUV420ToJpg(currFrame);
    DateTime end=DateTime.now();
    _processedFramesCount+=1;
    _totalProcessingTimeMs+=end.difference(start).inMilliseconds;

    if (accepted) {
      FrameModel frame = FrameModel(
        frame: img,
        score: totalScore,
        isAccepted: accepted,
        blurScore: sharpness,
        brightnessScore: exposure,
        shakeScore: motion,
      );
      _manageBestFrames(frame);
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

    int totalFramesAccepted = topFrames.length;
    if(topFrames.isNotEmpty){

      double avgSharpness =topFrames.map((f) => f.blurScore).reduce((a, b) => a + b) / topFrames.length;

      double avgExposure =topFrames.map((f) => f.brightnessScore).reduce((a, b) => a + b) / topFrames.length;

      double avgMotion =topFrames.map((f) => f.shakeScore).reduce((a, b) => a + b) / topFrames.length;

      double avgTotalScore =topFrames.map((f) => f.score).reduce((a, b) => a + b) / topFrames.length;

      double avgFps = _processedFramesCount / 15.0;
      double avgProcessingTime=_totalProcessingTimeMs/_processedFramesCount;
      result = SmartGateResult(
        metrics:SmartGateMetrics(
          totalFramesProcessed: _processedFramesCount,
          totalFramesAccepted: totalFramesAccepted,
          avgSharpness: avgSharpness,
          avgExposure: avgExposure,
          avgMotion: avgMotion,
          avgTotalScore: avgTotalScore,
          avgFps: avgFps, avgProcessingTime: avgProcessingTime,
        ),

        bestFrames: List.from(topFrames),
      );
    }
    connector?.showSuccess();

  }
}
