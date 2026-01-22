import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/Screens/Camera%20Screen/Tabs/On-Device%20TFLite%20Detector/View/option_c_tab.dart';
import 'package:rl_camera_filters/Screens/Camera%20Screen/Tabs/Scan%20Mode/View/option_b_tab.dart';
import 'package:rl_camera_filters/Screens/Camera%20Screen/Tabs/Smart%20Frame%20Gate/View/option_a_tab.dart';

import '../../../Costants/constants.dart';
import '../../../Providers/camera_provider.dart';
import '../../../Providers/tab_management_provider.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraProvider>().initCamera(widget.cameras);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<TabManagementProvider>().selectedTab,
          onTap:(value) {
            context.read<TabManagementProvider>().changeTab(index:value);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon:Icon(Icons.photo_library_outlined),label: "Filter Frames"),
            BottomNavigationBarItem(icon:Icon(Icons.document_scanner_outlined),label: "Scan"),
            BottomNavigationBarItem(icon:Icon(Icons.analytics_outlined),label: ""),
          ]
      ),
      body: Stack(
        children: [
          buildCamera(),
          Align(
            alignment: Alignment(0, 0.8),
            child: SizedBox(
              child: returnTab(),
            ),
          ),
        ],
      ),

    );
  }

  Widget returnTab(){
    int currIndex=context.watch<TabManagementProvider>().selectedTab;

    switch (currIndex) {
      case 0:
        return SmartFrameGate();

      case 1:
        return ScanMode();
      case 2:
        return TFLiteDetector();
    }
    return SmartFrameGate();
  }

  Widget buildCamera() {
    final cameraProvider = context.watch<CameraProvider>();

    if (cameraProvider.cameraStatus == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cameraProvider.cameraStatus == Status.error) {
      return Center(child: Text(cameraProvider.error ?? "Camera Error"));
    }

    if (cameraProvider.controller == null ||
        !cameraProvider.controller!.value.isInitialized) {
      return const SizedBox();
    }

    final controller = cameraProvider.controller!;

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize!.height,
          height: controller.value.previewSize!.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

}
