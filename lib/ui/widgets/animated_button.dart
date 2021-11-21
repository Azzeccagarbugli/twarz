import 'package:flutter/material.dart';
import 'package:twarz/theme/constants.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    Key? key,
    required this.onTap,
    required this.feel,
    this.padding = const EdgeInsets.symmetric(horizontal: kSpaceM),
    required this.title,
  }) : super(key: key);

  final Function() onTap;
  final String title;
  final bool feel;
  final EdgeInsetsGeometry padding;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    widget.onTap();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: _scale,
        child: Padding(
          padding: widget.padding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: kBorderRadius,
              color: kDarkestText,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  child: Container(
                    margin: const EdgeInsets.all(kSpaceM),
                    child: Center(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        layoutBuilder: (
                          topChild,
                          topChildKey,
                          bottomChild,
                          bottomChildKey,
                        ) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                key: bottomChildKey,
                                child: bottomChild,
                              ),
                              Positioned(
                                key: topChildKey,
                                child: topChild,
                              )
                            ],
                          );
                        },
                        firstChild: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: !widget.feel ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        secondChild: const Text(
                          'Feel yourself',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        crossFadeState: !widget.feel
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: kSpaceM),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
