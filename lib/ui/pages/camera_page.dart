import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/widgets/animated_button.dart';
import 'package:twarz/ui/widgets/bottom_card.dart';
import 'package:twarz/utils/detector.dart';
import 'package:twarz/utils/scanner.dart';

const double _height = 200;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<double> values1 = [0.4, 0.8, 0.65];
  List<double> values2 = [0.5, 0.3, 0.85];

  bool _isDetecting = false;
  dynamic _scanResults;

  late CameraController _cameraController;
  late CameraDescription _cameraDescription;

  final FaceDetector _faceDetector = GoogleVision.instance
      .faceDetector(const FaceDetectorOptions(enableContours: true));

  Future<void> _initializeCamera() async {
    _cameraDescription = widget.cameras[1];

    _cameraController = CameraController(
      _cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();

    await _cameraController.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _faceDetector.processImage,
        imageRotation: widget.cameras[1].sensorOrientation,
      ).then(
        (dynamic results) {
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(
        () => Future.delayed(
          const Duration(
            milliseconds: 100,
          ),
          () => {_isDetecting = false},
        ),
      );
    });
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
    );

    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        debugPrint('Si, errore');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(_cameraDescription);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
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
      body: Stack(
        children: [
          SizedBox(
            height: _cameraController.value.previewSize!.height,
            child: CameraPreview(
              _cameraController,
            ),
          ),
          SizedBox(
            height: _cameraController.value.previewSize!.height,
            width: _cameraController.value.previewSize!.width,
            child: CustomPaint(
              painter: FaceDetectorPainter(
                Size(
                  _cameraController.value.previewSize!.height,
                  _cameraController.value.previewSize!.width,
                ),
                _scanResults as List<Face>,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _height,
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                color: kBackgroundColor,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(kSpaceM),
                    child: BottomCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kSpaceS),
                    child: AnimatedButton(
                      title: 'Find more',
                      onTap: () {},
                      feel: false,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
