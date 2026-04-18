import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../../../Core/Costants/constants.dart';



class CameraScreenViewModel extends ChangeNotifier {
  late int selectedTab;
  CameraController? controller;
  Status cameraStatus = Status.init;
  String? error;

  CameraScreenViewModel() {
    selectedTab = 0;
  }



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
  Future<void> disposeCamera() async {
    if(controller==null) return;
    await controller?.dispose();
    controller=null;
    cameraStatus=Status.init;
    if(error!=null) error=null;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  Future<void> changeTab({required int index}) async {
    selectedTab = index;
    if(controller!=null){
      if (controller!.value.isStreamingImages) {
        await controller?.stopImageStream();
      }
    }

    notifyListeners();
  }

}
