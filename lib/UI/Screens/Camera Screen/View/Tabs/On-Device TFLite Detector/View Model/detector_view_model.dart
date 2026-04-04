import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Services/detector_services.dart';

import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../../Connector/connector.dart';

class DetectorViewModel extends ChangeNotifier {
  Connector? connector;
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<TensorType?> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model/detect.tflite');
    final rawData = await rootBundle.loadString(
      "assets/model/coco-labels-2014_2017.txt",
    );
    _labels = rawData.split("\n");

    print("Input Type: ${_interpreter?.getInputTensors()[0].type}");
    print("Output Type: ${_interpreter?.getOutputTensors()[0].type}");

    return _interpreter?.getInputTensors()[0].type;
  }

  Future<void> startDetecting(CameraController controller) async {
    int count=0;
    try {
      final modelInputType = await _loadModel();
      if(modelInputType!=null){
        // Start camera
        controller.startImageStream((frame) async {
          count++;
          print(count);
          // Preprocessing
          Uint8List resultTensor = await _preprocessing(frame,modelInputType);
          // Inference
          Map<int, dynamic> rawOutput = _runInference(resultTensor);
          // Postprocessing

          if(count==2) controller.stopImageStream();
          
        });
      }
    } catch (e) {
      print("Error:${e.toString()}");
    }
  }

  Future<Uint8List> _preprocessing(CameraImage frame, TensorType type) async {
    // convert camera image
    img.Image image = DetectorServices.convertCameraImage(frame);
    // resize image with letter box
    img.Image resizedImage = DetectorServices.resizeImage(300, image);
    // convert to tensor
    Uint8List tensor = DetectorServices.convertToUint8Tensor(resizedImage);
    return tensor;
  }

  Map<int, dynamic> _runInference(Uint8List inputTensor) {

    var outputLocations = List.generate(1, (_) => List.generate(10, (_) => List.filled(4, 0.0)));
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
    print("Output Locations: $outputLocations");
    print("Output Scores: $outputScores");
    print("Output Classes: $outputClasses");

    return outputs;
  }

  Future<void>  _postprocessing()async {

  }
}
