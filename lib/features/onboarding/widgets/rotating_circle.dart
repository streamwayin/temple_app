import 'dart:math';

import 'package:flutter/material.dart';

class RotatingCircleImage extends StatefulWidget {
  const RotatingCircleImage({super.key});

  @override
  RotatingCircleImageState createState() => RotatingCircleImageState();
}

class RotatingCircleImageState extends State<RotatingCircleImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Adjust the duration as needed
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: Container(
              width: 245,
              height: 245,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/background_rotating.png',
                fit: BoxFit.cover,
              ), // Replace with your image asset
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
