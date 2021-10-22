import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:radar_chart/radar_chart.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/widgets/bottom_card.dart';

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
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingValue,
                  vertical: kPaddingValue,
                ),
                child: ClipRRect(
                  borderRadius: kBorderRadius,
                  child: Stack(
                    children: [
                      CameraPreview(_cameraController),
                      Positioned(
                        top: kPaddingValue,
                        right: kPaddingValue,
                        child: Icon(
                          Icons.lens,
                          size: kPaddingValue,
                          color: kBackgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kPaddingValue),
                child: BottomCard(),
              ),
            ),
            const SizedBox(
              height: kPaddingValue,
            ),
          ],
        ),
      ),
    );
  }
}
