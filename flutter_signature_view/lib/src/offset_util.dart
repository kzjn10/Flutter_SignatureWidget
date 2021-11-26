import 'package:flutter/material.dart';

/// Utils class using parse list offset
class OffsetUtil {
  /// Convert List offset to String
  static String convertListOffsetToString(List<Offset?>? signatureValue) {
    final result = StringBuffer();

    if (signatureValue?.isNotEmpty??false) {
      return '';
    }

    for (final item in signatureValue!) {
      if (result.toString().trim().length != 0) {
        result.write('|');
      }

      if (item!=null) {
        result.write('${item.dx},${item.dy}');
      } else {
        result.write('null');
      }
    }

    return result.toString();
  }

  /// Convert List offset (String format) to List<Offset> data
  static List<Offset> covertStringToListOffset(String value) {
    final result = <Offset>[];

    if (value.trim().length == 0) {
      return result;
    }

    final offsetList = value.split('|');
    if (offsetList.length != 0) {
      for (final item in offsetList) {
        if (item!= 'null') {
          final temp = item.split(',');
          if (temp.length == 2) {
            final offset = Offset(double.parse(temp[0]), double.parse(temp[1]));
            result.add(offset);
          }
        }
      }
    }

    return result;
  }
}
