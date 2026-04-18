import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/Core/Costants/constants.dart';
import '../../../../../../../Core/Colors/main_colors.dart';
import '../../../../../../../Core/Text Syles/text_styles.dart';
import '../../../../../../Components/button_card.dart';
import '../../../../View Model/camera_screen_view_model.dart';
import '../View Model/detector_view_model.dart';
import 'detection_drawer.dart';

class TFLiteDetector extends StatefulWidget {
  const TFLiteDetector({super.key});

  @override
  State<TFLiteDetector> createState() => _TFLiteDetectorState();
}

class _TFLiteDetectorState extends State<TFLiteDetector>{
  late DetectorViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DetectorViewModel();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraScreenViewModel>().controller;

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<DetectorViewModel>(
        builder: (context, vm, _) {
          return Stack(
            children: [
              if (vm.finalResult != null)
                IgnorePointer(
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                    painter: DetectionDrawer(recognitions: vm.finalResult!),
                  ),
                ),

              Align(
                alignment: const Alignment(0, 0.8),
                child: ButtonCard(
                  onTap: () async {
                    if (controller != null) {
                      if (vm.detectingStatus == Status.init) {
                        final screenSize = MediaQuery.of(context).size;
                        await vm.startDetecting(controller,screenSize);
                      } else {
                        vm.stopDetecting(controller);
                      }
                    }
                  },
                  buttonText: (vm.detectingStatus == Status.init)
                      ? "Start detecting"
                      : "Detecting",
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(
          "Sorry, this service is currently unavailable. Please try again later.",
          style: MainTextStyles.getButtonTextStyle(),
        ),
        backgroundColor: MainColors.getBackGroundColor(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: MainTextStyles.getButtonTextStyle()),
          ),
        ],
      ),
    );
  }

}
