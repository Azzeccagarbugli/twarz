import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twarz/ui/pages/camera_page.dart';

late List<CameraDescription>? _camerasList;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _camerasList = await availableCameras();

  runApp(const Twarz());
}

class Twarz extends StatelessWidget {
  const Twarz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: CameraPage(
        cameras: _camerasList!,
      ),
    );
  }
}
