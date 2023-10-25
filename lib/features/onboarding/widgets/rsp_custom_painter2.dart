import 'package:flutter/material.dart';

class RPSCustomPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1 Copy

    Paint paintFill0 = Paint()
      ..color = const Color(0xffe9a362)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.0052481, size.height * -0.0096860);
    path_0.lineTo(size.width * -0.0089967, size.height * 0.7440068);
    path_0.quadraticBezierTo(size.width * 0.2608101, size.height * 0.6276233,
        size.width * 0.4127228, size.height * 0.6388732);
    path_0.cubicTo(
        size.width * 0.5464547,
        size.height * 0.6302970,
        size.width * 0.5918130,
        size.height * 0.6645310,
        size.width * 0.7427886,
        size.height * 0.6357757);
    path_0.cubicTo(
        size.width * 0.9393474,
        size.height * 0.5696283,
        size.width * 0.9729350,
        size.height * 0.4364255,
        size.width * 1.0110022,
        size.height * 0.3495036);
    path_0.quadraticBezierTo(size.width * 1.0069724, size.height * 0.2619763,
        size.width * 0.9948831, size.height * -0.0006054);

    canvas.drawPath(path_0, paintFill0);

    // Layer 1 Copy

    Paint paintStroke0 = Paint()
      ..color = const Color(0xffe9a362)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
