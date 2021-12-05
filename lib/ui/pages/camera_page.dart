import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:camera/camera.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';
import 'package:twarz/bot/telegram_bot.dart';
import 'package:twarz/model/emotions.dart';
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
  bool _isDetecting = false;
  dynamic _scanResults;

  late CameraController _cameraController;
  CameraLensDirection _direction = CameraLensDirection.front;

  CameraImage? cameraImage;

  String? output;
  double? confidence;

  List<dynamic> listCSV = [];

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
            cameraImage = image;
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

      _runModel();
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

  Future<void> _runModel() async {
    if (cameraImage != null) {
      final predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
      );
      for (final element in predictions!) {
        setState(() {
          output = element['label'] as String;
          confidence = element['confidence'] as double;
          listCSV.add({
            'datetime': DateTime.now(),
            'emotion': (element['label'] as String)[0],
            'confidence': confidence,
          });
        });
      }
    }
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  Future<void> _createCSV() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    debugPrint(statuses.toString());

    final List<List<dynamic>> rows = [];

    final List<dynamic> row = [];
    row.add('datetime');
    row.add('emotion');
    row.add('confidence');
    rows.add(row);
    for (int i = 0; i < listCSV.length; i++) {
      final row = [];
      row.add(listCSV[i]['datetime']);
      row.add(listCSV[i]['emotion']);
      row.add(listCSV[i]['confidence']);
      rows.add(row);
    }

    final csv = const ListToCsvConverter().convert(rows);

    try {
      final dir = await DownloadsPathProvider.downloadsDirectory;

      debugPrint("dir $dir");

      final f = File('${dir?.path}/Twarz Session.csv');

      await f.writeAsString(csv);

      await TwarzBot().send(file: f);

      // ignore: use_build_context_synchronously
      Flushbar(
        title: 'Download completed',
        message:
            'We sent a message to our admins and they are going to analyse your feelings in a while...',
        duration: const Duration(seconds: 5),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
      ).show(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
      Tflite.close();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(_getCamera(cameras: widget.cameras, dir: _direction));
      _loadModel();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
    TwarzBot().start();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    Tflite.close();
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
                  absoluteImageSize: Size(
                    _cameraController.value.previewSize!.height,
                    _cameraController.value.previewSize!.width,
                  ),
                  faces: _scanResults as List<Face>,
                  camPos: _direction == CameraLensDirection.back,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpaceS,
                      vertical: kSpaceS,
                    ),
                    child: BottomCard(
                      informationEmotion: EmotionUtilities.conversion()[output],
                      confidence: confidence ?? 0.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        kSpaceS,
                        0,
                        kSpaceS,
                        kSpaceS,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _toggleCameraDirection,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: kBorderRadius,
                                  color: Colors.blue.shade400,
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
                            child: GestureDetector(
                              onTap: _createCSV,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: kBorderRadius,
                                  color: Colors.green.shade400,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.send_and_archive_rounded,
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
                            flex: 3,
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
