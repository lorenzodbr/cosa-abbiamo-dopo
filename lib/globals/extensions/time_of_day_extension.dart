import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  bool isAfter(TimeOfDay t) {
    if (hour < t.hour) {
      return false;
    } else if (hour == t.hour) {
      if (minute < t.minute) {
        return false;
      }

      return true;
    }

    return true;
  }

  bool isBefore(TimeOfDay t) {
    if (hour > t.hour) {
      return false;
    } else if (hour == t.hour) {
      if (minute > t.minute) {
        return false;
      }

      return true;
    }

    return true;
  }
}
