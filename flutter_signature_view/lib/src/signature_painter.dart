import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Signature painter
class SignaturePainter extends CustomPainter {
  /// Default point value
  final List<Offset?>? points;

  // Pen style
  late final Paint? paintStyle;

  late Size? _canvasSize;

  /// Constructor
  SignaturePainter({this.points, this.paintStyle});

  @override
  void paint(Canvas canvas, Size size) {
    _canvasSize = size;
    paintStyle ??= Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    if (points != null) {
      for (var i = 0; i < points!.length - 1; i++) {
        if (points![i] != null && points![i + 1] != null) {
          canvas.drawLine(points![i]!, points![i + 1]!, paintStyle!);
        }
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }

  /// Export canvas to Uint8List
  Future<Uint8List?> export() async {
    if (_canvasSize != null) {
      final recorder = PictureRecorder();
      const origin = Offset(0.0, 0.0);
      final paintBounds = Rect.fromPoints(
        _canvasSize!.topLeft(origin),
        _canvasSize!.bottomRight(origin),
      );
      final canvas = Canvas(recorder, paintBounds);
      paint(canvas, _canvasSize!);
      final picture = recorder.endRecording();
      final image = await Future.value(picture.toImage(
        _canvasSize!.width.round(),
        _canvasSize!.height.round(),
      ));
      final bytes = await image.toByteData(format: ImageByteFormat.png);
      return bytes?.buffer.asUint8List();
    } else {
      return null;
    }
  }

  /// Export canvas to Base64Image
  Future<String?> exportBase64Image() async {
    final bytes = await export();
    if (bytes != null) {
      return 'data:image/png;base64,${base64.encode(bytes)}';
    } else {
      return null;
    }
  }
}
