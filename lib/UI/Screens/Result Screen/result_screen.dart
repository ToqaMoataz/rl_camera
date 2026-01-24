import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../Costants/constants.dart';
import '../../Components/frame_card.dart';
import '../Camera Screen/View/Tabs/Smart Frame Gate/Model/frame_model.dart';

class ResultScreen extends StatelessWidget {
  final ResultType type;

  final List<FrameModel>? frames;
  final Map<String, Uint8List>? scan;
  final dynamic detectionData;

  const ResultScreen({
    super.key,
    required this.type,
    this.frames,
    this.scan,
    this.detectionData,
  }) : assert(frames != null || scan != null || detectionData != null, );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle())),
      body: _buildResultBody(),
    );
  }

  String _getAppBarTitle() {
    switch (type) {
      case ResultType.frames: return "Best 10 Frames";
      case ResultType.scan: return "Scan Result";
      case ResultType.detection: return "Detection Analysis";
    }
  }

  Widget _buildResultBody() {
    if(type==ResultType.frames){
      return _buildFramesGrid(frames!);
    }
    return SizedBox.shrink();
    // switch (type) {
    //   case ResultType.frames:
    //     return _buildFramesGrid(frames!);
    //   case ResultType.scan:
    //     //return _buildScanComparison(scan!);
    //   case ResultType.detection:
    //    // return _buildDetectionResult(detectionData!);
    // }
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

        return FrameCard(frame: item,);
      },
    );
  }
}