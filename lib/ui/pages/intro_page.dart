import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';
import 'package:twarz/ui/widgets/step_tutorial.dart';
import 'package:twarz/ui/widgets/twerz_button.dart';
import 'package:twarz/utils/transparent_image.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key, required Function() onTap})
      : _onTap = onTap,
        super(key: key);

  final Function() _onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Chip(
              backgroundColor: Colors.amber,
              label: AutoSizeText(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: kSpaceXS,
            ),
            Chip(
              backgroundColor: Colors.blue,
              label: AutoSizeText(
                kWelcome,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: kSpaceXS,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                kEmotions,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.grey.shade800,
                ),
              ),
              const StepTutorial(
                text:
                    'Tap on the start button and your camera will be activated',
                number: 0,
              ),
              const StepTutorial(
                text:
                    'Watch your phone and read what the system thinks about your emotions',
                number: 1,
              ),
              const StepTutorial(
                text:
                    'Keep the phone right in front of you and express any feelings',
                number: 2,
              ),
              const StepTutorial(
                text: 'Enjoy your experience',
                number: 3,
              ),
              const StepTutorial(
                text: 'Share the results',
                number: 4,
              ),
            ],
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
                    onTap: _onTap,
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
