import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../../../../Costants/constants.dart';

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
  void changeTab({required int index}) {
    selectedTab = index;
    notifyListeners();
  }

  void call(){
    if(selectedTab==0){
      // Call Filtering frames Function
      return;
    }
    else if(selectedTab==1){
      // Call Scan Function
      return;
    }
    // Call Detector Function
  }
}
