import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';

class FaceCamera extends StatelessWidget {
  const FaceCamera({
    Key? key,
    required CameraController cameraController,
  })  : _cameraController = cameraController,
        super(key: key);

  final CameraController _cameraController;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: kBorderRadius,
      child: CameraPreview(_cameraController),
    );
  }
}
