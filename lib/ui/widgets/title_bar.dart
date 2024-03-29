import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twarz/theme/constants.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPaddingValue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            kProjectName,
            style: GoogleFonts.pressStart2p().copyWith(
              fontSize: 16.0,
              color: kDarkText,
            ),
          ),
          const Icon(
            Icons.psychology_rounded,
            color: kDarkText,
          ),
        ],
      ),
    );
  }
}
