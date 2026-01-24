
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/Connector/connector.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Smart%20Frame%20Gate/View%20Model/smart_gate_view_model.dart';
import '../../../../../../../Costants/constants.dart';
import '../../../../../../../Routes/app_routes.dart';
import '../../../../View Model/camera_screen_view_model.dart';


class SmartFrameGate extends StatefulWidget {
  SmartFrameGate({super.key});

  @override
  State<SmartFrameGate> createState() => _SmartFrameGateState();
}

class _SmartFrameGateState extends State<SmartFrameGate> implements Connector{
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

    return ChangeNotifierProvider(
      create:  (context) => viewModel,
      child: GestureDetector(
        onTap: viewModel.filteringStatus == Status.loading
            ? null
            : () {
          if (cameraVM.controller != null) {
            viewModel.startFiltering(cameraVM.controller!);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            color: viewModel.filteringStatus == Status.loading
                ? Colors.grey
                : Colors.deepPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: viewModel.filteringStatus == Status.loading
              ? const Row(children: [
            Text(
              "Filtering...",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(width: 4,),
            CircularProgressIndicator(color: Colors.white,),
          ],)
              : const Text(
            "Start Filtering",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
  @override
  showError(String msg) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Error"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }


  @override
  showSuccess() {
    Navigator.pushNamed(
      context,
      Routes.resultScreenRoute,
      arguments: {
        'type': ResultType.frames,
        'frames': viewModel.topFrames,
        // 'scan': myScanData,
        // 'detectionData': myDetectionData,
      },
    );

  }

}

