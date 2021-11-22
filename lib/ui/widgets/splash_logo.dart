import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twarz/theme/constants.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            const Align(
              child: Icon(
                Icons.psychology_rounded,
                size: kLogoSize,
                color: kDarkestText,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: kSpaceL),
                child: AutoSizeText(
                  kProjectName,
                  style: GoogleFonts.pressStart2p().copyWith(
                    fontSize: 12.0,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
