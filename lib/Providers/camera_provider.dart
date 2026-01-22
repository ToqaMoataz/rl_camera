import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../Costants/constants.dart';

class CameraProvider extends ChangeNotifier {
  CameraController? controller;
  Status cameraStatus = Status.init;
  String? error;

  Future<void> initCamera(List<CameraDescription> cameras) async {
    if (controller != null && controller!.value.isInitialized) {
      return;
    }

    try {
      cameraStatus = Status.loading;
      error = null;
      notifyListeners();

      controller?.dispose();

      controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      await controller!.initialize();

      cameraStatus = Status.success;
    } catch (e) {
      cameraStatus = Status.error;
      error = e.toString();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
