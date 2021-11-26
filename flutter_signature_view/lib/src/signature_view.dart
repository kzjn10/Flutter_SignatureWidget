import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'custom_pan_gesture_recognizer.dart';
import 'offset_util.dart';
import 'signature_painter.dart';

/// Signature widget view
class SignatureView extends StatefulWidget {
  /// Default data
  final String? data;

  /// Canvas background color
  final Color? backgroundColor;

  /// Custom paint
  final Paint? penStyle;

  /// Callback when signed
  final Function(String)? onSigned;

  @override
  final GlobalKey<_SignatureViewState> key = GlobalKey();

  /// Constructor
  SignatureView({
    this.backgroundColor = Colors.white,
    this.data,
    this.penStyle,
    this.onSigned,
  });

  @override
  _SignatureViewState createState() => _SignatureViewState();

  /// Export list offset to bytes
  Future<Uint8List?> exportBytes() {
    return key.currentState!.exportBytes();
  }

  /// Export list offset to bytes
  Future<String?> exportBase64Image() {
    return key.currentState!.exportBase64Image();
  }

  /// Export list offset to string
  String? exportListOffsetToString() {
    return key.currentState!.exportListOffsetToString();
  }

  /// Check empty
  bool get isEmpty {
    return key.currentState?.isEmpty() ?? true;
  }

  /// Clear signature view
  void clear() {
    return key.currentState?.clear();
  }
}

class _SignatureViewState extends State<SignatureView> {
  List<Offset?>? _points;
  SignaturePainter? _painter;
  late GlobalKey _painterKey;
  late BoxConstraints _constraints;

  bool isEmpty() {
    return _points?.isEmpty ?? true;
  }

  Future<Uint8List?> exportBytes() async {
    return _painter?.export();
  }

  Future<String?> exportBase64Image() async {
    return _painter?.exportBase64Image();
  }

  String? exportListOffsetToString() {
    return OffsetUtil.convertListOffsetToString(_points ?? List.empty());
  }

  void clear() {
    setState(() => _points?.clear());
    if (widget.onSigned != null) {
      widget.onSigned!('');
    }
  }

  @override
  void initState() {
    super.initState();
    _painterKey = GlobalKey();
    if (widget.data != null) {
      _points = OffsetUtil.covertStringToListOffset(widget.data!);
    } else {
      _points = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    _painter = SignaturePainter(points: _points, paintStyle: widget.penStyle);
    return LayoutBuilder(
      builder: (context, constraints) {
        _constraints = constraints;
        return Container(
          color: widget.backgroundColor,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: RawGestureDetector(
            gestures: <Type, GestureRecognizerFactory>{
              CustomPanGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  CustomPanGestureRecognizer>(
                () => CustomPanGestureRecognizer(
                  onPanDown: _onPanDown,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                ),
                (instance) {},
              ),
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

  bool _onPanDown(Offset details) {
    return true;
  }

  bool _onPanUpdate(Offset details) {
    if (_painter == null) {
      return false;
    }

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final position = renderBox?.globalToLocal(details);

    if (position == null) {
      return false;
    }

    if ((position.dx > 0 && position.dx < _constraints.maxWidth) &&
        (position.dy > 0 && position.dy < _constraints.maxHeight)) {
      setState(() {
        _points = List.from(_points!)..add(position);
      });
    }

    return true;
  }

  bool _onPanEnd(Offset details) {
    _points!.add(null);
    if (widget.onSigned != null) {
      widget.onSigned!(OffsetUtil.convertListOffsetToString(_points));
    }

    return true;
  }
}
