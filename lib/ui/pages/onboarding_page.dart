import 'dart:io' show Platform;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:no_glow_scroll/no_glow_scroll.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/pages/camera_page.dart';
import 'package:twarz/ui/widgets/animated_button.dart';
import 'package:twarz/ui/widgets/onboarding_content.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    Key? key,
    required List<CameraDescription>? camerasList,
  })  : _camerasList = camerasList,
        super(key: key);

  final List<CameraDescription>? _camerasList;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() => _pageOffset = _pageController.page!);
      });
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
      body: Stack(
        children: [
          Icon(
            Icons.psychology_rounded,
            size: 700,
            color: Colors.grey.shade100,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: const SizedBox(),
          ),
          Positioned(
            bottom: 0,
            top: 10,
            left: 0,
            right: 0,
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [kPrimaryColor, kPrimaryColor],
                  [kSecondaryColor, kSecondaryColor],
                  [kThirdColor, kThirdColor],
                ],
                durations: [35000, 19440, 10800],
                heightPercentages: [0.7, 0.75, 0.79],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
              ),
              waveAmplitude: 0,
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: NoGlowScroll(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        OnboardingContent(
                          path: 'assets/onboarding/welcome.png',
                          title: 'Welcome',
                          subtitle:
                              "What you know you can't explain, but you feel it and Twarz will help you in this, in the nicest way possible",
                          offset: _pageOffset,
                        ),
                        OnboardingContent(
                          path: 'assets/onboarding/photo.png',
                          title: 'Emotions',
                          subtitle:
                              'Ekman described six of them, we want to push this even further using just your phone',
                          offset: _pageOffset - 1,
                        ),
                        OnboardingContent(
                          path: 'assets/onboarding/cringe.png',
                          title: 'Choice',
                          subtitle:
                              'Ever have that feeling where you’re not sure if you’re awake or dreaming? Now you can recognize',
                          offset: _pageOffset - 2,
                        ),
                        OnboardingContent(
                          path: 'assets/onboarding/new.png',
                          title: "Let's start",
                          subtitle:
                              'Watch your phone and read what the system thinks about your feelings, enojoy this experience',
                          offset: _pageOffset - 3,
                        ),
                      ],
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController, // PageController
                  count: 4,
                  effect: const SwapEffect(
                    activeDotColor: Colors.white,
                    dotColor: kDarkestText,
                    dotHeight: 10.0,
                    dotWidth: 10.0,
                  ),
                ),
                const SizedBox(
                  height: kSpaceM,
                ),
                AnimatedButton(
                  title: 'Next',
                  feel: _pageOffset == 3,
                  onTap: () {
                    if (_pageOffset != 3) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    } else {
                      if (widget._camerasList != null) {
                        Navigator.pushReplacement(
                          context,
                          routeToPage(
                            widget: CameraPage(
                              cameras: widget._camerasList!,
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                if (Platform.isAndroid)
                  const SizedBox(
                    height: kSpaceM,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
