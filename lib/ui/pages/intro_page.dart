import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/widgets/twerz_button.dart';
import 'package:twarz/utils/transparent_image.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key, required PageController pageController})
      : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AutoSizeText(
            kEmotions,
            style: TextStyle(
              height: 1.5,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kPaddingValue,
          ),
          child: Container(
            height: kSpaceXS,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: kBorderRadius,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: kBorderRadius,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.grey.shade600,
                    child: ClipRRect(
                      borderRadius: kBorderRadius,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image:
                            'https://media.giphy.com/media/3og0ISkkN95PNIQHW8/giphy.gif',
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TwerzButton(
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: kPaddingValue,
        ),
      ],
    );
  }
}
