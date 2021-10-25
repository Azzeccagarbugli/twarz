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
          Text(
            kProjectName,
            style: GoogleFonts.pressStart2p().copyWith(
              fontSize: 16.0,
            ),
          ),
          Icon(
            Icons.psychology_rounded,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
