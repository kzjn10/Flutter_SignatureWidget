import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

/// Signature painter
class SignaturePainter extends CustomPainter {
  /// Default point value
  List<Offset> points;

  /// Paint style
  Paint paintStyle;
  Size _canvasSize;

  /// Constructor
  SignaturePainter({this.points, this.paintStyle});

  @override
  void paint(Canvas canvas, Size size) {
    _canvasSize = size;
    if (paintStyle == null) {
      paintStyle = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0;
    }

    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paintStyle);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }

  /// Export canvas to Uint8List
  Future<Uint8List> export() async {
    var recorder = PictureRecorder();
    var origin = Offset(0.0, 0.0);
    var paintBounds = Rect.fromPoints(
      _canvasSize.topLeft(origin),
      _canvasSize.bottomRight(origin),
    );
    var canvas = Canvas(recorder, paintBounds);
    paint(canvas, _canvasSize);
    var picture = recorder.endRecording();
    var image = await Future.value(picture.toImage(
      _canvasSize.width.round(),
      _canvasSize.height.round(),
    ));
    var bytes = await image.toByteData(format: ImageByteFormat.png);
    return bytes.buffer.asUint8List();
  }

  /// Export canvas to Base64Image
  Future<String> exportBase64Image() async {
    var bytes = await export();
    return "data:image/png;base64,${base64.encode(bytes)}";
  }
}
