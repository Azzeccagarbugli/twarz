import 'dart:math';

// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:radar_chart/radar_chart.dart';
import 'package:twarz/theme/constants.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RadarChart(
          length: 6,
          radius: 40,
          radialStroke: .3,
          radialColor: Colors.grey,
          radars: [
            RadarTile(
              values: List.generate(6, (index) => Random().nextDouble()),
              borderStroke: 1,
              borderColor: Colors.yellow,
              backgroundColor: Colors.yellow.withOpacity(0.4),
            ),
            RadarTile(
              values: List.generate(6, (index) => Random().nextDouble()),
              borderStroke: 1,
              borderColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.4),
            ),
            RadarTile(
              values: List.generate(6, (index) => Random().nextDouble()),
              borderStroke: 1,
              borderColor: Colors.orange,
              backgroundColor: Colors.orange.withOpacity(0.4),
            ),
            RadarTile(
              values: List.generate(6, (index) => Random().nextDouble()),
              borderStroke: 1,
              borderColor: Colors.blue,
              backgroundColor: Colors.blue.withOpacity(0.4),
            ),
            RadarTile(
              values: List.generate(6, (index) => Random().nextDouble()),
              borderStroke: 1,
              borderColor: Colors.pink,
              backgroundColor: Colors.pink.withOpacity(0.4),
            ),
          ],
        ),
        const SizedBox(
          width: kPaddingValue,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AutoSizeText(
                'Happiness',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                height: kSpaceXS,
              ),
              AutoSizeText(
                'The term happiness is used in the context of mental or emotional states, including positive or pleasant emotions ranging from contentment to intense joy. It is also used in the context of life satisfaction, subjective well-being, eudaimonia, flourishing and well-being.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
