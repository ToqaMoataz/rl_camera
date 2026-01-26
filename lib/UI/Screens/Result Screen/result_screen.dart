import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/Core/Text%20Syles/text_styles.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Scan%20Mode/Model/image_scan_result.dart';

import '../../../Core/Costants/constants.dart';
import '../../Components/frame_card.dart';
import '../Camera Screen/View/Tabs/Smart Frame Gate/Model/frame_model.dart';

class ResultScreen extends StatelessWidget {
  final ResultType type;

  final List<FrameModel>? frames;
  final ScanResultModel? scanResult;
  final dynamic detectionData;

  const ResultScreen({
    super.key,
    required this.type,
    this.frames,
    this.scanResult,
    this.detectionData,
  }) : assert(frames != null || scanResult != null || detectionData != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle())),
      body: _buildResultBody(context  ),
    );
  }

  String _getAppBarTitle() {
    switch (type) {
      case ResultType.frames:
        return "Best 10 Frames";
      case ResultType.scan:
        return "Scan Result";
      case ResultType.detection:
        return "Detection Analysis";
    }
  }

  Widget _buildResultBody(context) {
    if (type == ResultType.frames) {
      return _buildFramesGrid(frames!);
    } else if (type == ResultType.scan) {
      return _buildScanResult(scanResult!, context);
    } else if (type == ResultType.detection) {}
    return SizedBox.shrink();
  }

  Widget _buildFramesGrid(List<FrameModel> frames) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.55,
      ),
      itemCount: frames.length,
      itemBuilder: (context, index) {
        final item = frames[index];

        return FrameCard(frame: item);
      },
    );
  }

  Widget _buildScanResult(ScanResultModel scanResult, context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Processing Time: ${scanResult.metrics.processingTimeInMillSecond}",
            style: MainTextStyles.getBasicTextStyle(
              MainColors.getPrimaryColor(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              returnImageColumn(scanResult.metrics.originalResolution, scanResult.original, context),
              SizedBox(width:4),
              returnImageColumn(scanResult.metrics.scannedResolution, scanResult.processed, context)
            ],
          ),
        ],
      ),
    );
  }

  Widget returnImageColumn(String imageResolution,XFile image,context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            border: Border.all(
              color: MainColors.getPrimaryColor(),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
          ),
        ),
        Text(
          imageResolution,
          style: MainTextStyles.getBasicTextStyle(
            MainColors.getPrimaryColor(),
          ),
        ),

      ],
    );
  }
}
