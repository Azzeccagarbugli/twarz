import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';

class TwerzButton extends StatelessWidget {
  const TwerzButton({
    Key? key,
    required Function() onTap,
  })  : _onTap = onTap,
        super(key: key);

  final Function() _onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Padding(
        padding: const EdgeInsets.all(kSpaceXS),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: kBorderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(kPaddingValue),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AutoSizeText(
                      'Start the adventure',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .9,
                      ),
                    ),
                    const SizedBox(
                      height: kSpaceXS,
                    ),
                    AutoSizeText(
                      'Feel yourself in a new way',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .9,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kPaddingValue),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: kPaddingValue,
                  child: Center(
                    child: Icon(
                      Icons.chevron_right,
                      size: kPaddingValue,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
