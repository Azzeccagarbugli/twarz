import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    Future.delayed(const Duration(seconds: 5), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Icon(
            Icons.psychology_rounded,
            size: 700,
            color: Colors.grey.shade100,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: const SizedBox(),
          ),
          SafeArea(
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
                          onTap: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          },
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
        ],
      ),
    );
  }
}
