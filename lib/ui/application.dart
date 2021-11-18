import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
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
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: kSpaceS,
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: kPaddingValue,
                //   ),
                //   child: TitleBar(),
                // ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      OnboardingContent(
                        path: 'assets/onboarding/welcome.png',
                        title: 'Welcome',
                        subtitle:
                            'Watch your phone and read what the system thinks about your emotions',
                        offset: _pageOffset,
                      ),
                      OnboardingContent(
                        path: 'assets/onboarding/photo.png',
                        title: 'Emotions',
                        subtitle:
                            'Watch your phone and read what the system thinks about your emotions',
                        offset: _pageOffset - 1,
                      ),
                      OnboardingContent(
                        path: 'assets/onboarding/cringe.png',
                        title: 'Emotions',
                        subtitle:
                            'Watch your phone and read what the system thinks about your emotions',
                        offset: _pageOffset - 2,
                      ),
                      OnboardingContent(
                        path: 'assets/onboarding/new.png',
                        title: 'Emotions',
                        subtitle:
                            'Watch your phone and read what the system thinks about your emotions',
                        offset: _pageOffset - 3,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: kSpaceM,
                ),
                AnimatedButton(
                  onTap: () {},
                ),
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
    // Offest calc
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
                height: MediaQuery.of(context).size.height / 2.5,
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
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

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
      duration: const Duration(milliseconds: 200),
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
            child: Container(
              margin: const EdgeInsets.all(kSpaceM),
              child: const Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
