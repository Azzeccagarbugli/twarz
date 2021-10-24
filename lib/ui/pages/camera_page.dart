import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/widgets/bottom_card.dart';
import 'package:twarz/ui/widgets/face_camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<double> values1 = [0.4, 0.8, 0.65];
  List<double> values2 = [0.5, 0.3, 0.85];

  late CameraController _cameraController;
  late CameraDescription _cameraDescription;

  @override
  void initState() {
    super.initState();

    _cameraDescription = widget.cameras[1];

    _cameraController = CameraController(
      _cameraDescription,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: kPaddingValue,
            ),
            child: FaceCamera(
              cameraController: _cameraController,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: kPaddingValue / 2,
            bottom: kPaddingValue * 1.5,
          ),
          child: BottomCard(),
        ),
      ],
    );
  }
}
