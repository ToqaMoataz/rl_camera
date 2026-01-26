
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/Connector/connector.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/View%20Model/smart_gate_view_model.dart';

import '../../../../../../../Core/Costants/constants.dart';
import '../../../../../../../Core/Routes/app_routes.dart';
import '../../../../View Model/camera_screen_view_model.dart';


class SmartFrameGate extends StatefulWidget {
  const SmartFrameGate({super.key});

  @override
  State<SmartFrameGate> createState() => _SmartFrameGateState();
}

class _SmartFrameGateState extends State<SmartFrameGate> implements Connector {
  late SmartGateViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SmartGateViewModel();
    viewModel.connector = this;
  }

  @override
  Widget build(BuildContext context) {
    final cameraVM = context.read<CameraScreenViewModel>();

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<SmartGateViewModel>(
        builder: (context, smartGateVM, child) {
          return GestureDetector(
            onTap: smartGateVM.filteringStatus == Status.loading
                ? null
                : () {
              if (cameraVM.controller != null) {
                smartGateVM.startFiltering(cameraVM.controller!);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: smartGateVM.filteringStatus == Status.loading
                    ? Colors.white10
                    : Colors.deepPurple,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: smartGateVM.filteringStatus == Status.loading
                  ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Filtering...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              )
                  : const Text(
                "Start Filtering",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void showError(String msg) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void showSuccess() {
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      Routes.resultScreenRoute,
      arguments: {
        'type': ResultType.frames,
        'frames': viewModel.topFrames,
      },
    );
  }

  @override
  void onLoading() {
    // No need for it here
    print("IT's Loading");
  }

  @override
  void removeLoading() {
    // No need for it here
    print("IT's not Loading");
  }
}

