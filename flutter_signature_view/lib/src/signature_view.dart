import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'offset_util.dart';
import 'signature_painter.dart';

class SignatureView extends StatefulWidget {
  final String data;

  final Color backgroundColor;

  final Paint penStyle;

  final Function(String) onSigned;

  final GlobalKey<_SignatureViewState> key = GlobalKey<_SignatureViewState>();

  SignatureView(
      {this.backgroundColor = Colors.white,
      this.data,
      this.penStyle,
      this.onSigned});

  @override
  _SignatureViewState createState() => _SignatureViewState();

  /// Export list offset to bytes
  Future<Uint8List> exportBytes() async {
    return await key.currentState.exportBytes();
  }

  /// Export list offset to string
  String exportListOffsetToString() {
    return key.currentState.exportListOffsetToString();
  }

  /// Check empty
  bool get isEmpty {
    return key.currentState.isEmpty();
  }

  /// Clear signature view
  clear() {
    return key.currentState.clear();
  }
}

class _SignatureViewState extends State<SignatureView> {
  List<Offset> _points;
  SignaturePainter _painter;
  GlobalKey _painterKey;

  bool isEmpty() {
    return _points?.isEmpty ?? true;
  }

  Future<Uint8List> exportBytes() async {
    return await _painter.export();
  }

  String exportListOffsetToString() {
    return OffsetUtil.convertListOffsetToString(_points);
  }

  void clear() {
    setState(() => _points.clear());
    if (widget.onSigned != null) widget.onSigned("");
  }

  @override
  void initState() {
    super.initState();
    _painterKey = GlobalKey();
    if (widget.data != null) {
      _points = OffsetUtil.covertStringToListOffset(widget.data) ?? List();
    } else {
      _points = List();
    }
  }

  @override
  Widget build(BuildContext context) {
    _painter = SignaturePainter(points: _points, paintStyle: widget.penStyle);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: widget.backgroundColor,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              RenderBox object = context.findRenderObject();
              Offset _localPosition =
                  object.globalToLocal(details.globalPosition);
              if ((constraints.maxWidth == null ||
                      _localPosition.dx > 0 &&
                          _localPosition.dx < constraints.maxWidth) &&
                  (constraints.maxHeight == null ||
                      _localPosition.dy > 0 &&
                          _localPosition.dy < constraints.maxHeight)) {
                setState(() {
                  _points = new List.from(_points)..add(_localPosition);
                });
              }
            },
            onPanEnd: (DragEndDetails details) {
              _points.add(null);
              if (widget.onSigned != null) {
                widget.onSigned(OffsetUtil.convertListOffsetToString(_points));
              }
              return _points;
            },
            child: CustomPaint(
              key: _painterKey,
              painter: _painter,
              size: Size.infinite,
            ),
          ),
        );
      },
    );
  }
}
