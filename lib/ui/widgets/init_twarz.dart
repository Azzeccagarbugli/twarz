import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:twarz/ui/application.dart';
import 'package:twarz/ui/widgets/splash_logo.dart';
import 'package:your_splash/your_splash.dart';

class InitTwarz extends StatelessWidget {
  const InitTwarz({
    Key? key,
    required this.camerasList,
  }) : super(key: key);

  final List<CameraDescription>? camerasList;

  @override
  Widget build(BuildContext context) {
    return SplashScreen.timed(
      seconds: 1,
      route: PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Application(
          camerasList: camerasList,
        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, animation, secAnim, child) {
          final tween = Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeInOutCirc),
          );
          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
      body: const SplashLogo(),
    );
  }
}
