// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:twarz/model/emotions.dart';
import 'package:twarz/theme/constants.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({
    Key? key,
    required this.informationEmotion,
    required this.confidence,
  }) : super(key: key);

  final InformationEmotion? informationEmotion;
  final double confidence;

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(kSpaceXS),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        color: informationEmotion?.color ?? Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(kSpaceM),
              decoration: BoxDecoration(
                borderRadius: kBorderRadius,
                color: darken(informationEmotion?.color ?? Colors.grey),
              ),
              child: Column(
                children: [
                  AutoSizeText(
                    '${(confidence * 100).toStringAsFixed(0)}%',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  AutoSizeText(
                    'Confidence',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: kPaddingValue,
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  informationEmotion?.title ?? 'Loading',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
                AutoSizeText(
                  informationEmotion?.subtitle ??
                      'Please, wait for the loading of the assets',
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    color: Colors.white,
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
