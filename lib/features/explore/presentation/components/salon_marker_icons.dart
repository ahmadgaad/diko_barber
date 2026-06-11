import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

/// Pre-rendered branded map pins: a colored circle with a storefront glyph
/// and a pointer tail. Generated once and reused for every marker.
class SalonMarkerIcons {
  const SalonMarkerIcons._({
    required this.open,
    required this.closed,
    required this.highlighted,
  });

  final BitmapDescriptor open;
  final BitmapDescriptor closed;
  final BitmapDescriptor highlighted;

  static const _closedGrey = Color(0xFF8E8E93);

  static Future<SalonMarkerIcons> generate() async {
    final results = await Future.wait([
      _draw(color: splashOrange, size: 110),
      _draw(color: _closedGrey, size: 110),
      _draw(color: splashOrange, size: 150),
    ]);
    return SalonMarkerIcons._(
      open: results[0],
      closed: results[1],
      highlighted: results[2],
    );
  }

  BitmapDescriptor forSalon({
    required bool isOpen,
    required bool isHighlighted,
  }) {
    if (isHighlighted) return highlighted;
    return isOpen ? open : closed;
  }

  static Future<BitmapDescriptor> _draw({
    required Color color,
    required int size,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final s = size.toDouble();
    final center = Offset(s / 2, s * 0.38);
    final radius = s * 0.30;

    final tail = Path()
      ..moveTo(s / 2 - radius * 0.45, s * 0.58)
      ..lineTo(s / 2, s * 0.92)
      ..lineTo(s / 2 + radius * 0.45, s * 0.58)
      ..close();
    canvas.drawPath(tail, Paint()..color = color);

    canvas.drawCircle(
      center,
      radius + s * 0.045,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(center, radius, Paint()..color = color);

    final glyph = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(Icons.storefront_rounded.codePoint),
        style: TextStyle(
          fontSize: radius * 1.1,
          fontFamily: Icons.storefront_rounded.fontFamily,
          color: Colors.white,
        ),
      )
      ..layout();
    glyph.paint(canvas, center - Offset(glyph.width / 2, glyph.height / 2));

    final image = await recorder.endRecording().toImage(size, size);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      imagePixelRatio: 3.0,
    );
  }
}
