import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/pages/camera_page.dart';
import 'package:twarz/ui/pages/onboarding_page.dart';
import 'package:twarz/ui/widgets/splash_logo.dart';
import 'package:your_splash/your_splash.dart';

const _secondSplash = 1;

class InitTwarz extends StatefulWidget {
  const InitTwarz({
    Key? key,
    required this.camerasList,
  }) : super(key: key);

  final List<CameraDescription>? camerasList;

  @override
  State<InitTwarz> createState() => _InitTwarzState();
}

class _InitTwarzState extends State<InitTwarz> {
  int _counterApp = 0;

  Future<void> _setCounterApp() async {
    final _prefs = await SharedPreferences.getInstance();
    final _tmp = _prefs.getInt('counter') ?? 0;

    final _counterIncremented = _tmp + 1;
    setState(() {
      _counterApp = _counterIncremented;
    });

    debugPrint('Start number: $_counterIncremented');
    await _prefs.setInt('counter', _counterIncremented);
  }

  @override
  void initState() {
    super.initState();
    _setCounterApp();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen.timed(
      seconds: _secondSplash,
      route: routeToPage(
        widget: _counterApp > 1
            ? CameraPage(
                cameras: widget.camerasList!,
              )
            : OnboardingPage(
                camerasList: widget.camerasList,
              ),
      ),
      body: const SplashLogo(),
    );
  }
}
