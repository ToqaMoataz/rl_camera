

import 'dart:ui' ;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';

import 'package:flutter/services.dart' hide Size;
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Model/detector_result_model.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Model/pre_processing_result_model.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Model/resize_result.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Services/detector_services.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../../../../../Core/Costants/constants.dart';

class DetectorViewModel extends ChangeNotifier {

  static final DetectorViewModel _instance = DetectorViewModel._internal();
  factory DetectorViewModel() => _instance;
  DetectorViewModel._internal();

  bool _modelLoaded = false;

  Interpreter? _interpreter;
  List<String>? _labels;
  Status detectingStatus = Status.init;
  List<Recognition>? finalResult;


  Future<void> loadModel() async {
    if (_modelLoaded) return;
    _interpreter = await Interpreter.fromAsset('assets/model/detect.tflite');
    final rawData = await rootBundle.loadString("assets/model/labels.txt");
    _labels = rawData
        .split("\n")
        .map((e) => e.trim())
        .toList();
    _modelLoaded = true;
  }

  Future<void> startDetecting(
    CameraController controller,
    Size screenSize,
  ) async {
    detectingStatus = Status.loading;
    notifyListeners();
    bool isProcessing = false;

    try {
      //final modelInputType = await _loadModel();
      if (_modelLoaded) {
        controller.startImageStream((frame) async {
          if (isProcessing) return;
          isProcessing = true;

          try {
            PreProcessingResultModel result = await _preprocessing(frame);
            Map<int, List<dynamic>> rawOutput = _runInference(result.tensor);

            List<Recognition> finall = await _postprocessing(
              rawOutput,
              result,
              screenSize,
            );
            finalResult = finall;
            detectingStatus = Status.success;
            notifyListeners();
          }finally {
            isProcessing = false;
          }
        });
      }
    } catch (e) {
      detectingStatus = Status.error;
      notifyListeners();

    }
  }

  Future<PreProcessingResultModel> _preprocessing(CameraImage frame) async {

    img.Image image = await compute(
      DetectorServices.convertCameraImage,
      frame,
    );

    final originalSize = Size(image.width.toDouble(), image.height.toDouble());

    ResizeResult resizedResult = await compute(
      DetectorServices.resizeImageIsolate,
      (300, image),
    );

    Uint8List tensor = await compute(
      DetectorServices.convertToUint8Tensor,
      resizedResult.image,
    );

    return PreProcessingResultModel(
      tensor: tensor,
      originalImageSize: originalSize,
      ratio: resizedResult.ratio,
      xOff: resizedResult.xOff,
      yOff: resizedResult.yOff,
    );
  }
  Map<int, List<dynamic>> _runInference(Uint8List inputTensor) {
    var outputLocations = List.generate(
      1,
      (_) => List.generate(10, (_) => List.filled(4, 0.0)),
    );
    var outputClasses = List.generate(1, (_) => List.filled(10, 0.0));
    var outputScores = List.generate(1, (_) => List.filled(10, 0.0));
    var numDetections = List.filled(1, 0.0);

    var outputs = {
      0: outputLocations,
      1: outputClasses,
      2: outputScores,
      3: numDetections,
    };

    _interpreter?.runForMultipleInputs([inputTensor], outputs);

    return outputs;
  }

  Future<List<Recognition>> _postprocessing(
      Map<int, List<dynamic>> inferenceResult,
      PreProcessingResultModel preprocessResult,
      Size screenSize,
      ) async {
    const int targetSize = 300;

    final double ratio = preprocessResult.ratio;
    final int xOff = preprocessResult.xOff;
    final int yOff = preprocessResult.yOff;
    final int newW = (ratio * preprocessResult.originalImageSize.width).round();
    final int newH = (ratio * preprocessResult.originalImageSize.height).round();

    var scores    = inferenceResult[2]![0];
    var classes   = inferenceResult[1]![0];
    var locations = inferenceResult[0]![0];

    List<Recognition> result = [];

    for (int i = 0; i < 10; i++) {
      if (scores[i] < 0.45) continue;

      List<dynamic> loc = locations[i];

      double top    = loc[0].toDouble() * targetSize;
      double left   = loc[1].toDouble() * targetSize;
      double bottom = loc[2].toDouble() * targetSize;
      double right  = loc[3].toDouble() * targetSize;

      left   = ((left   - xOff) / newW).clamp(0.0, 1.0);
      top    = ((top    - yOff) / newH).clamp(0.0, 1.0);
      right  = ((right  - xOff) / newW).clamp(0.0, 1.0);
      bottom = ((bottom - yOff) / newH).clamp(0.0, 1.0);

      final rect = Rect.fromLTRB(
        left   * screenSize.width,
        top    * screenSize.height,
        right  * screenSize.width,
        bottom * screenSize.height,
      );

      final classId = (classes[i].toInt() + 1).clamp(0, _labels!.length - 1);
      final label = (_labels![classId] == "???") ? "Unknown" : _labels![classId];

      result.add(Recognition(location: rect, label: label, score: scores[i]));
    }

    for (int i = 0; i < result.length; i++) {
      int? index=_labels?.indexOf(result[i].label)  ;
      print("rawId: $index → '${_labels![index!]}' | score: ${result[i].score}");
    }

   return DetectorServices.applyNMS(result, 0.5);


  }


  Future<void> stopDetecting(CameraController controller) async {
    await controller.stopImageStream();
    detectingStatus = Status.init;
    finalResult = null;
    notifyListeners();
  }
}
