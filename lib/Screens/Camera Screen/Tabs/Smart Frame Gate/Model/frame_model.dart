import 'package:camera/camera.dart';

class FrameModel {
   CameraImage frame;
   double score;
   bool isAccepted;

   FrameModel({required this.frame,required this.score,required this.isAccepted});
}