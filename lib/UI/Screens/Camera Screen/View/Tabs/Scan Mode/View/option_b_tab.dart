import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/Core/Text%20Syles/text_styles.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/Connector/connector.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Scan%20Mode/View%20Model/scan_view_model.dart';
import '../../../../../../../Core/Costants/constants.dart';
import '../../../../../../../Core/Routes/app_routes.dart';
import '../../../../View Model/camera_screen_view_model.dart';

class ScanMode extends StatefulWidget {
  ScanMode({super.key});

  @override
  State<ScanMode> createState() => _ScanModeState();
}

class _ScanModeState extends State<ScanMode> implements Connector {
  late ScanViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ScanViewModel();
    viewModel.connector = this;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraScreenViewModel>().controller;
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<ScanViewModel>(
        builder: (context, value, child) {
          if (controller != null) {
            return GestureDetector(
              onTap: () async {
                await viewModel.captureImage(controller);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text("Scan", style: MainTextStyles.getButtonTextStyle()),
              ),
            );
          }

          return CircularProgressIndicator(color: Colors.deepPurple);
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
        content: Text(msg,style: MainTextStyles.getButtonTextStyle(),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
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
      arguments: {'type': ResultType.scan, 'scan': viewModel.result},
    );
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
}
