import 'package:flutter/material.dart';

/// Utils class using parse list offset
class OffsetUtil {
  /// Convert List offset to String
  static String convertListOffsetToString(List<Offset> signatureValue) {
    var result = StringBuffer();

    if (signatureValue == null || signatureValue.length == 0) {
      return "";
    }

    for (var item in signatureValue) {
      if (result.toString().trim().length != 0) {
        result.write("|");
      }

      if (item.toString() == "null") {
        result.write(item.toString());
      } else {
        result.write("${item.dx},${item.dy}");
      }
    }

    return result.toString();
  }

  /// Convert List offset (String format) to List<Offset> data
  static List<Offset> covertStringToListOffset(String value) {
    var result = <Offset>[];

    if (value == null || value.trim().length == 0) {
      return result;
    }

    var offsetList = value.split("|");
    if (offsetList != null && offsetList.length != 0) {
      for (var item in offsetList) {
        if (item == "null") {
          result.add(null);
        } else {
          var temp = item.split(",");
          if (temp != null && temp.length == 2) {
            var offset = Offset(double.parse(temp[0]), double.parse(temp[1]));
            result.add(offset);
          }
        }
      }
    }

    return result;
  }
}
