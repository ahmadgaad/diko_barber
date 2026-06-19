import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ZLightPainter extends CustomPainter {
  ZLightPainter({
    required this.progress,
    required this.glowColor,
    required this.letterColor,
    this.strokeWidth = 12.0,
    this.glowRadius = 24.0,
  });

  final double progress;
  final Color glowColor;
  final Color letterColor;
  final double strokeWidth;
  final double glowRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final inset = strokeWidth / 2;

    // Z path: top-right → top-left → bottom-right → bottom-left
    final topRight = Offset(w - inset, inset);
    final topLeft = Offset(inset, inset);
    final bottomRight = Offset(w - inset, h - inset);
    final bottomLeft = Offset(inset, h - inset);

    final zPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy);

    // Draw the Z letter
    final letterPaint = Paint()
      ..color = letterColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(zPath, letterPaint);

    if (progress <= 0) return;

    // Calculate point along the Z path at current progress
    final metrics = zPath.computeMetrics().first;
    final totalLength = metrics.length;
    final currentLength = (progress * totalLength).clamp(0.0, totalLength);

    final tangent = metrics.getTangentForOffset(currentLength);
    if (tangent == null) return;

    final point = tangent.position;

    // Draw glow at the current point
    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        point,
        glowRadius,
        [
          glowColor.withValues(alpha: 0.9),
          glowColor.withValues(alpha: 0.4),
          glowColor.withValues(alpha: 0.0),
        ],
        [0.0, 0.5, 1.0],
      );

    canvas.drawCircle(point, glowRadius, glowPaint);

    // Draw bright core
    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(point, strokeWidth * 0.35, corePaint);

    // Draw a lit trail behind the glow
    final trailLength = totalLength * 0.15;
    final trailStart = (currentLength - trailLength).clamp(0.0, totalLength);

    final trailPath = metrics.extractPath(trailStart, currentLength);

    final trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.linear(
        metrics.getTangentForOffset(trailStart)?.position ?? point,
        point,
        [
          glowColor.withValues(alpha: 0.0),
          glowColor.withValues(alpha: 0.6),
        ],
      );

    canvas.drawPath(trailPath, trailPaint);
  }

  @override
  bool shouldRepaint(ZLightPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
