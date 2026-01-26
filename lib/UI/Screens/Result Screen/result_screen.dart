import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rl_camera_filters/Core/Colors/main_colors.dart';
import 'package:rl_camera_filters/Core/Text%20Syles/text_styles.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/Scan%20Mode/Model/image_scan_result.dart';

import '../../../Core/Costants/constants.dart';
import '../../Components/frame_card.dart';
import '../Camera Screen/View/Tabs/Smart Frame Gate/Model/filter_result_model.dart';

class ResultScreen extends StatelessWidget {
  final ResultType type;

  final SmartGateResult? frameResult;
  final ScanResultModel? scanResult;
  final dynamic detectionData;

  const ResultScreen({
    super.key,
    required this.type,
    this.frameResult,
    this.scanResult,
    this.detectionData,
  }) : assert(frameResult != null || scanResult != null || detectionData != null);

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
      return _buildFramesResult(frameResult!,context);
    } else if (type == ResultType.scan) {
      return _buildScanResult(scanResult!, context);
    } else if (type == ResultType.detection) {}
    return SizedBox.shrink();
  }

  Widget _buildFramesResult(SmartGateResult result, BuildContext context) {
    final metrics = result.metrics;

    Widget metricRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: MainColors.getPrimaryColor(),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Processed Frames: ${metrics.totalFramesProcessed}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  Text(
                    "Accepted Frames: ${metrics.totalFramesAccepted}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  const Divider(),
                  Text(
                    "Avg Sharpness: ${metrics.avgSharpness.toStringAsFixed(2)}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  Text(
                    "Avg Exposure: ${metrics.avgExposure.toStringAsFixed(2)}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  Text(
                    "Avg Motion: ${metrics.avgMotion.toStringAsFixed(2)}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  Text(
                    "Avg Total Score: ${metrics.avgTotalScore.toStringAsFixed(2)}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  const Divider(),
                  Text(
                    "Average FPS: ${metrics.avgFps.toStringAsFixed(2)}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                  Text(
                    "Avg Processing Time (ms): ${metrics.avgProcessingTime.toStringAsFixed(2)}",
                    style: MainTextStyles.getBasicTextStyle(MainColors.getPrimaryColor()),
                  ),
                ],
              ),

            ),
            const SizedBox(height: 8),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemCount: result.bestFrames.length,
                itemBuilder: (context, index) {
                  final item = result.bestFrames[index];
                  return FrameCard(frame: item);
                },
              ),
            ),
          ],
        ),
      ),
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
