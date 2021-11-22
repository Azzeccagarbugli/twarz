import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';

class LoadCamera extends StatelessWidget {
  const LoadCamera({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: const Center(
        child: Icon(
          Icons.psychology_rounded,
          color: kBackgroundColor,
          size: 200,
        ),
      ),
    );
  }
}
