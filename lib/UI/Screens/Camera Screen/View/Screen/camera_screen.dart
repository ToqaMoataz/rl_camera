import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View%20Model/camera_screen_view_model.dart';

import '../../../../../Core/Colors/main_colors.dart';
import '../../../../../Core/Costants/constants.dart';
import '../Tabs/On-Device TFLite Detector/View/option_c_tab.dart';
import '../Tabs/Scan Mode/View/option_b_tab.dart';
import '../Tabs/Smart Frame Gate/View/option_a_tab.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late CameraScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CameraScreenViewModel();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.initCamera(widget.cameras);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      viewModel.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      viewModel.initCamera(widget.cameras);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    viewModel.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<CameraScreenViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: vm.selectedTab,
              onTap: (value) {
                vm.changeTab(index: value);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library_outlined),
                  label: "Filter Frames",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.document_scanner_outlined),
                  label: "Scan",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined),
                  label: "Detect",
                ),
              ],
            ),
            body: Stack(
              children: [
                _buildCamera(vm),
                Align(
                  alignment: const Alignment(0, 0.8),
                  child: _returnTab(vm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildCamera(CameraScreenViewModel vm) {
    if (vm.cameraStatus == Status.loading) {
      return Center(child: CircularProgressIndicator(color: MainColors.getPrimaryColor(),));
    }

    if (vm.cameraStatus == Status.error) {
      return Center(child: Text(vm.error ?? "Camera Error"));
    }

    if (vm.controller == null ||
        !vm.controller!.value.isInitialized) {
      return const SizedBox();
    }

    final controller = vm.controller!;

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


  Widget _returnTab(CameraScreenViewModel vm) {
    switch (vm.selectedTab) {
      case 0:
        return SmartFrameGate();
      case 1:
        return ScanMode();
      case 2:
        return TFLiteDetector();
      default:
        return SmartFrameGate();
    }
  }
}
