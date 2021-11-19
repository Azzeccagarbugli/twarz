import 'dart:math';
import 'dart:ui';

import 'dart:io' show Platform;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:no_glow_scroll/no_glow_scroll.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/pages/camera_page.dart';
import 'package:twarz/ui/pages/intro_page.dart';
import 'package:twarz/ui/widgets/face_camera.dart';
import 'package:twarz/ui/widgets/title_bar.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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

  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() => _pageOffset = _pageController.page!);
      });

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
              colors: const [
                kPrimaryColor,
                kSecondaryColor,
                kThirdColor,
                kDarkText,
                kDarkestText,
              ],
              blastDirection: pi / 2,
            ),
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
                const SizedBox(
                  height: kSpaceS,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kPaddingValue,
                  ),
                  child: TitleBar(),
                ),
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
                  feel: _pageOffset == 3,
                  onTap: () {
                    if (_pageOffset != 3) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      );
                    } else {
                      if (widget._camerasList != null) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Scaffold(
                              body: FaceCamera(
                                cameraController: CameraController(
                                  widget._camerasList![1],
                                  ResolutionPreset.max,
                                ),
                              ),
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

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.path,
    required this.offset,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String path;
  final double offset;

  @override
  Widget build(BuildContext context) {
    // Offest math
    final gauss = exp(-(pow(offset.abs() - 0.5, 2) / 0.08));

    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(kSpaceL),
            child: ClipRRect(
              child: Image.asset(
                path,
                height: MediaQuery.of(context).size.height / 3,
                alignment: Alignment(-offset.abs(), 0),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kDarkestText,
                fontSize: 48,
              ),
            ),
          ),
          const SizedBox(
            height: kSpaceXS,
          ),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingHor),
              child: AutoSizeText(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  height: 1.4,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kSpaceL,
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key, required this.onTap, required this.feel})
      : super(key: key);

  final Function() onTap;
  final bool feel;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    widget.onTap();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceM),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              color: kDarkestText,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  child: Container(
                    margin: const EdgeInsets.all(kSpaceM),
                    child: Center(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        layoutBuilder: (
                          topChild,
                          topChildKey,
                          bottomChild,
                          bottomChildKey,
                        ) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                key: bottomChildKey,
                                child: bottomChild,
                              ),
                              Positioned(
                                key: topChildKey,
                                child: topChild,
                              )
                            ],
                          );
                        },
                        firstChild: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        secondChild: const Text(
                          'Feel yourself',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        crossFadeState: !widget.feel
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: kSpaceM),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
