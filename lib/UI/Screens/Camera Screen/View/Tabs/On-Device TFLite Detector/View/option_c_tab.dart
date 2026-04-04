import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../Core/Colors/main_colors.dart';
import '../../../../../../../Core/Text Syles/text_styles.dart';
import '../../../../../../Components/button_card.dart';
import '../../../../Connector/connector.dart';
import '../../../../View Model/camera_screen_view_model.dart';
import '../View Model/detector_view_model.dart';

class TFLiteDetector extends StatefulWidget {
  const TFLiteDetector({super.key});

  @override
  State<TFLiteDetector> createState() => _TFLiteDetectorState();
}

class _TFLiteDetectorState extends State<TFLiteDetector> implements Connector{
  late DetectorViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = DetectorViewModel();
    viewModel.connector = this;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraScreenViewModel>().controller;
    return ChangeNotifierProvider.value(
      value: viewModel,
      child:ButtonCard(
        onTap: () async {
          if (controller != null) {
            await viewModel.startDetecting(controller);
          }
          //showMyDialog(context);
        },
        buttonText: "Start detecting",
      )
    ) ;
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

  @override
  void showSuccess() {
    if (!mounted) return;
    // Navigator.pushNamed(
    //   context,
    //   Routes.resultScreenRoute,
    //   arguments: {'type': ResultType.detection, 'scan': viewModel.result},
    // );
  }

  @override
  void onLoading() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: MainColors.getBackGroundColor(),
      builder: (_) => Center(
        child: CircularProgressIndicator(color: MainColors.getPrimaryColor()),
      ),
    );
  }

  @override
  void removeLoading() {
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void showError(String msg) {
    // TODO: implement showError
  }
}
