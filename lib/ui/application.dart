import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/pages/camera_page.dart';
import 'package:twarz/ui/pages/intro_page.dart';
import 'package:twarz/ui/widgets/title_bar.dart';

class Application extends StatefulWidget {
  const Application({
    Key? key,
    required List<CameraDescription>? camerasList,
  })  : _camerasList = camerasList,
        super(key: key);

  final List<CameraDescription>? _camerasList;

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: kPaddingValue,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kPaddingValue,
              ),
              child: TitleBar(),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingValue,
                    ),
                    child: IntroPage(
                      pageController: _pageController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kPaddingValue,
                    ),
                    child: CameraPage(
                      cameras: widget._camerasList!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
