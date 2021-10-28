import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twarz/theme/constants.dart';

class StepTutorial extends StatelessWidget {
  const StepTutorial({
    Key? key,
    required this.text,
    required this.number,
  }) : super(key: key);

  final String text;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPaddingValue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AutoSizeText(
              number.toString(),
              style: GoogleFonts.pressStart2p(),
            ),
          ),
          const SizedBox(
            width: kPaddingValue,
          ),
          Expanded(
            child: AutoSizeText(
              text,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
