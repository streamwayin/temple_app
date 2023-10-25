import 'dart:math';

import 'package:flutter/material.dart';

class PendulumAnimation extends StatefulWidget {
  const PendulumAnimation({super.key, required this.toLeft});
  final bool toLeft;
  @override
  PendulumAnimationState createState() => PendulumAnimationState();
}

class PendulumAnimationState extends State<PendulumAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool forward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _controller.addStatusListener(_animationStatusListener);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: forward
              ? widget.toLeft
                  ? _controller.value * pi / 30
                  : _controller.value * pi / 30 - (pi / 30)
              : widget.toLeft
                  ? _controller.value * pi / 30
                  : _controller.value * pi / 30,
          // + (_controller.value * pi / 30),
          alignment: Alignment.topCenter,
          child: Image.asset(
              'assets/images/garland.png'), // Replace with your image asset
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      forward = !forward;
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      forward = !forward;
      _controller.forward();
    }
  }
}
