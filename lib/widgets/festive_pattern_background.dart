import 'dart:math' as math;

import 'package:flutter/material.dart';

class FestivePatternBackground extends StatelessWidget {
  const FestivePatternBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _FestivePatternPainter(),
          ),
        ),
        child,
      ],
    );
  }
}

class _FestivePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF8C1D40).withValues(alpha: 0.08);

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFD17B0F).withValues(alpha: 0.12);

    const spacing = 120.0;
    for (double y = 40; y < size.height; y += spacing) {
      for (double x = 30; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 28, ringPaint);
        canvas.drawCircle(Offset(x, y), 18, ringPaint);
        canvas.drawCircle(Offset(x, y), 8, ringPaint);

        for (int i = 0; i < 8; i++) {
          final angle = (i * 45) * math.pi / 180;
          final dx = x + 38 * math.cos(angle);
          final dy = y + 38 * math.sin(angle);
          canvas.drawCircle(Offset(dx, dy), 2.2, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
