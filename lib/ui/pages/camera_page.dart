import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/widgets/animated_button.dart';
import 'package:twarz/ui/widgets/bottom_card.dart';
import 'package:twarz/ui/widgets/load_camera.dart';
import 'package:twarz/utils/detector.dart';
import 'package:twarz/utils/scanner.dart';

const double _height = 200;

CameraDescription _getCamera({
  required List<CameraDescription> cameras,
  required CameraLensDirection dir,
}) {
  return cameras.firstWhere((cam) => cam.lensDirection == dir);
}

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
  CameraLensDirection _direction = CameraLensDirection.front;

  final FaceDetector _faceDetector = GoogleVision.instance
      .faceDetector(const FaceDetectorOptions(enableContours: true));

  Future<void> _initializeCamera() async {
    final CameraDescription _description = _getCamera(
      cameras: widget.cameras,
      dir: _direction,
    );

    _cameraController = CameraController(
      _description,
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
        imageRotation: _description.sensorOrientation,
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

  Future<void> _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    await _cameraController.stopImageStream();

    setState(() {});

    await _initializeCamera();
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
      onNewCameraSelected(_getCamera(cameras: widget.cameras, dir: _direction));
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
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!_cameraController.value.isInitialized)
            const LoadCamera()
          else ...[
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
          ],
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kSpaceM,
                        vertical: kSpaceS,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _toggleCameraDirection,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: kBorderRadius,
                                  color: Colors.grey.shade400,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_front_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: kSpaceS,
                          ),
                          Expanded(
                            flex: 4,
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
            ),
          ),
        ],
      ),
    );
  }
}
