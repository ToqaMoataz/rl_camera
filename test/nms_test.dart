import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Model/detector_result_model.dart';
import 'package:rl_camera_filters/UI/Screens/Camera%20Screen/View/Tabs/On-Device%20TFLite%20Detector/Services/detector_services.dart';

void main() {
  group('NMS Tests', () {

    test('NMS removes overlapping box and keeps highest score', () {

      final detections = [
        Recognition(
          location: Rect.fromLTRB(10, 10, 100, 100),
          label: 'mouse',
          score: 0.9,
        ),
        Recognition(
          location: Rect.fromLTRB(12, 12, 102, 102),
          label: 'mouse',
          score: 0.6,
        ),
        Recognition(
          location: Rect.fromLTRB(300, 300, 400, 400),
          label: 'remote',
          score: 0.8,
        ),
      ];

      final result = DetectorServices.applyNMS(detections, 0.5);

      expect(result.length, 2);
      expect(result[0].label, 'mouse');
      expect(result[0].score, 0.9);
      expect(result[1].label, 'remote');
      expect(result[1].score, 0.8);
    });

    test('NMS keeps all boxes when no overlap', () {
      final detections = [
        Recognition(location: Rect.fromLTRB(0,   0,   50,  50),  label: 'cat',    score: 0.9),
        Recognition(location: Rect.fromLTRB(100, 100, 150, 150), label: 'dog',    score: 0.8),
        Recognition(location: Rect.fromLTRB(200, 200, 250, 250), label: 'person', score: 0.7),
      ];

      final result = DetectorServices.applyNMS(detections, 0.5);

      expect(result.length, 3);
    });

    test('NMS returns empty when given empty list', () {
      final result = DetectorServices.applyNMS([], 0.5);
      expect(result.isEmpty, true);
    });

    test('NMS keeps only one box when all heavily overlap', () {
      final detections = [
        Recognition(location: Rect.fromLTRB(10, 10, 100, 100), label: 'cat', score: 0.9),
        Recognition(location: Rect.fromLTRB(10, 10, 100, 100), label: 'cat', score: 0.7),
        Recognition(location: Rect.fromLTRB(10, 10, 100, 100), label: 'cat', score: 0.5),
      ];

      final result = DetectorServices.applyNMS(detections, 0.5);

      expect(result.length, 1);
      expect(result[0].score, 0.9);
    });

  });
}