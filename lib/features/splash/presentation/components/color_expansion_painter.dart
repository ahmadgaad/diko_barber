import 'dart:math' as math;

import 'package:flutter/material.dart';

class ColorExpansionPainter extends CustomPainter {
  final double progress;
  final Alignment alignment;
  final Gradient gradient;

  ColorExpansionPainter({
    required this.progress,
    required this.alignment,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = alignment.withinRect(Offset.zero & size);

    final maxRadius = math.sqrt(
      math.pow(math.max(center.dx, size.width - center.dx), 2) +
          math.pow(math.max(center.dy, size.height - center.dy), 2),
    );

    final currentRadius = maxRadius * progress;

    final paint = Paint()..shader = gradient.createShader(Offset.zero & size);

    canvas.drawCircle(center, currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant ColorExpansionPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.alignment != alignment;
  }
}
