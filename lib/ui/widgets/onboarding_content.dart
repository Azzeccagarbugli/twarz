import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';

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
      offset: Offset(gauss * offset.sign, 0),
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
