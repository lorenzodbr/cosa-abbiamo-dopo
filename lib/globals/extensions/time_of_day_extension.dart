import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  bool isAfter(TimeOfDay t) {
    if (hour < t.hour) {
      return false;
    } else if (hour == t.hour) {
      if (minute <= t.minute) {
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
      if (minute >= t.minute) {
        return false;
      }

      return true;
    }

    return true;
  }

  bool isBeforeOrEqual(TimeOfDay t) {
    return isBefore(t) || this == t;
  }

  bool isAfterOrEqual(TimeOfDay t) {
    return isAfter(t) || this == t;
  }

  Duration timeFrom(TimeOfDay t) {
    return toDateTime().difference(t.toDateTime());
  }

  Duration timeFromDateTime(DateTime t) {
    return toDateTime().difference(t);
  }

  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
