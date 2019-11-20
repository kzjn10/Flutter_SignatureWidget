import 'package:flutter/material.dart';

class OffsetUtil {
  static String convertListOffsetToString(List<Offset> signatureValue) {
    StringBuffer result = StringBuffer();

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

  static List<Offset> covertStringToListOffset(String value) {
    List<Offset> result = List();

    if (value == null || value.trim().length == 0) {
      return result;
    }

    List<String> offsetList = value.split("|");
    if (offsetList != null && offsetList.length != 0) {
      for (var item in offsetList) {
        if (item == "null") {
          result.add(null);
        } else {
          List<String> offsetValues = item.split(",");
          if (offsetValues != null && offsetValues.length == 2) {
            result.add(Offset(
                double.parse(offsetValues[0]), double.parse(offsetValues[1])));
          }
        }
      }
    }

    return result;
  }
}
