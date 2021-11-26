import 'package:flutter/gestures.dart';

/// Custom pan gesture recognizer
/// See more: https://www.davidanaya.io/flutter/combine-multiple-gestures.html
///
class CustomPanGestureRecognizer extends OneSequenceGestureRecognizer {
  /// On Pan Down
  final Function onPanDown;

  /// On Pan Update
  final Function onPanUpdate;

  /// On Pan End
  final Function onPanEnd;

  /// Constructor
  CustomPanGestureRecognizer({
    required this.onPanDown,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  void addPointer(PointerEvent event) {
    if (onPanDown(event.position)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      onPanUpdate(event.position);
    }
    if (event is PointerUpEvent) {
      onPanEnd(event.position);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
