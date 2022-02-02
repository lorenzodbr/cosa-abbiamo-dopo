import 'package:cosa_abbiamo_dopo/globals/extensions/time_of_day_extension.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_hour.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_teacher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static List<MarconiHour> hoursListMonThuFirstGroup = [
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 8, minute: 45),
    ),
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 45),
      const TimeOfDay(hour: 9, minute: 30),
    ),
    MarconiHour(
      const TimeOfDay(hour: 9, minute: 30),
      const TimeOfDay(hour: 10, minute: 20),
    ),
    MarconiHour(
      const TimeOfDay(hour: 10, minute: 20),
      const TimeOfDay(hour: 11, minute: 10),
    ),
    MarconiHour(
      const TimeOfDay(hour: 11, minute: 20),
      const TimeOfDay(hour: 12, minute: 10),
    ),
    MarconiHour(
      const TimeOfDay(hour: 12, minute: 10),
      const TimeOfDay(hour: 13, minute: 00),
    ),
    MarconiHour(
      const TimeOfDay(hour: 12, minute: 10),
      const TimeOfDay(hour: 13, minute: 00),
    ),
    MarconiHour(
      const TimeOfDay(hour: 12, minute: 10),
      const TimeOfDay(hour: 13, minute: 00),
    ),
  ];

  static List<MarconiHour> hoursListFri = [
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 8, minute: 45),
    ),
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 45),
      const TimeOfDay(hour: 9, minute: 30),
    ),
    MarconiHour(
      const TimeOfDay(hour: 9, minute: 30),
      const TimeOfDay(hour: 10, minute: 20),
    ),
    MarconiHour(
      const TimeOfDay(hour: 10, minute: 20),
      const TimeOfDay(hour: 11, minute: 10),
    ),
    MarconiHour(
      const TimeOfDay(hour: 11, minute: 20),
      const TimeOfDay(hour: 12, minute: 10),
    ),
    MarconiHour(
      const TimeOfDay(hour: 12, minute: 10),
      const TimeOfDay(hour: 12, minute: 55),
    ),
    MarconiHour(
      const TimeOfDay(hour: 13, minute: 05),
      const TimeOfDay(hour: 13, minute: 55),
    ),
    MarconiHour(
      const TimeOfDay(hour: 13, minute: 55),
      const TimeOfDay(hour: 14, minute: 45),
    ),
    MarconiHour(
      const TimeOfDay(hour: 14, minute: 55),
      const TimeOfDay(hour: 15, minute: 40),
    ),
    MarconiHour(
      const TimeOfDay(hour: 15, minute: 40),
      const TimeOfDay(hour: 16, minute: 25),
    ),
  ];

  static List<MarconiHour> hoursListMonThuSecondGroup = [
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 8, minute: 45),
    ),
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 45),
      const TimeOfDay(hour: 9, minute: 30),
    ),
    MarconiHour(
      const TimeOfDay(hour: 9, minute: 30),
      const TimeOfDay(hour: 10, minute: 20),
    ),
    MarconiHour(
      const TimeOfDay(hour: 10, minute: 20),
      const TimeOfDay(hour: 11, minute: 10),
    ),
    MarconiHour(
      const TimeOfDay(hour: 11, minute: 20),
      const TimeOfDay(hour: 12, minute: 10),
    ),
    MarconiHour(
      const TimeOfDay(hour: 12, minute: 10),
      const TimeOfDay(hour: 12, minute: 55),
    ),
    MarconiHour(
      const TimeOfDay(hour: 13, minute: 05),
      const TimeOfDay(hour: 13, minute: 55),
    ),
    MarconiHour(
      const TimeOfDay(hour: 13, minute: 55),
      const TimeOfDay(hour: 14, minute: 45),
    ),
  ];

  static Future<String> fetchData() async {
    String savedClass = await getSavedClass();

    Uri uri = Uri.parse(
        'https://apps.marconivr.it/orario/api.php?class=' + savedClass);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '';
      }
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> isClassSet() async {
    final prefs = await SharedPreferences.getInstance();

    if ((prefs.getString('classe') ?? '').isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<String> getSavedClass() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('classe') ?? '';
  }

  static List<String> getClasses() {
    return [
      "1AI",
      "1BI",
      "1CI",
      "1DI",
      "1EI",
      "1FL",
      "1GL",
      "1HL",
      "1IL",
      "1LE",
      "1ME",
      "1NE",
      "1OE",
      "1PE",
      "1QL",
      "1RI",
      "1SE",
      "2AI",
      "2BI",
      "2CI",
      "2DI",
      "2EI",
      "2FL",
      "2GL",
      "2HL",
      "2IL",
      "2LE",
      "2ME",
      "2NE",
      "2OE",
      "2PE",
      "3AC",
      "3AE",
      "3AI",
      "3AL",
      "3AT",
      "3AT1",
      "3BE",
      "3BI",
      "3BL",
      "3CI",
      "3DI",
      "3EI",
      "3FI",
      "3GI",
      "4AC",
      "4AE",
      "4AI",
      "4AL",
      "4AT",
      "4AT1",
      "4BE",
      "4BI",
      "4BL",
      "4CI",
      "4DI",
      "4EI",
      "5AC",
      "5AE",
      "5AI",
      "5AL",
      "5AT",
      "5AT1",
      "5BI",
      "5BL",
      "5CI",
      "5DI",
      "5EI"
    ];
  }

  static Future<List<MarconiLesson>> getData() async {
    String data = await getRawData();

    return decodeData(data);
  }

  static Future<List<MarconiLesson>> getSavedData() async {
    String rawSavedData = await getRawSavedData();

    return decodeData(rawSavedData);
  }

  static Future<String> getRawSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('data') ?? '';
  }

  static Future<String> getRawData() async {
    String data = await updateData();

    return data;
  }

  static void setData(String s) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('data', s);
  }

  static Future<String> updateData() async {
    String dataFromAPI = await fetchData();

    String savedData = await getRawSavedData();

    if (savedData != dataFromAPI && dataFromAPI != '') {
      setData(dataFromAPI);

      return dataFromAPI;
    }

    return savedData;
  }

  static void setSavedClass(String s) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('classe', s);
  }

  static List<MarconiLesson> filterForToday(List<MarconiLesson> lessons) {
    List<MarconiLesson> res = [];
    DateTime today = DateTime.now();

    for (var element in lessons) {
      if (element.day == today.weekday) {
        res.add(element);
      }
    }

    return res;
  }

  static List<MarconiLesson> groupTeachers(List<MarconiLesson> lessons) {
    List<MarconiLesson> res = [];

    for (int i = 0; i < lessons.length; i++) {
      int offset = 0;
      List<MarconiTeacher> teachers = [];

      teachers.addAll(lessons[i].teachers);

      while (i + offset + 1 < lessons.length &&
          lessons[i].hourIndex == lessons[i + offset + 1].hourIndex) {
        teachers.add(lessons[i + offset + 1].teachers[0]);
        offset++;
      }

      teachers.sort((a, b) => a.nameSurname.compareTo(b.nameSurname));

      lessons[i].teachers = teachers;

      res.add(lessons[i]);

      i += offset;
    }

    return res;
  }

  static List<MarconiLesson> setHours(List<MarconiLesson> lessons) {
    List<MarconiHour> hours;

    if (lessons[0].day != 5) {
      if (lessons[0].hourIndex == 1) {
        hours = hoursListMonThuFirstGroup;
      } else {
        hours = hoursListMonThuSecondGroup;
      }
    } else {
      hours = hoursListFri;
    }

    for (int i = 0; i < lessons.length; i++) {
      lessons[i].hours = hours[lessons[i].hourIndex - 1];
    }

    return lessons;
  }

  static List<MarconiLesson> decodeData(String data) {
    final parsed = jsonDecode(data).cast<Map<String, dynamic>>();

    List<MarconiLesson> decoded = parsed
        .map<MarconiLesson>((json) => MarconiLesson.fromJson(json))
        .toList();

    return setHours(groupTeachers(filterForToday(decoded)));
  }

  static MarconiHour getHourRange(int hour, int day, int firstOrSecondGroup) {
    if (firstOrSecondGroup == 1) {
      if (day == 5) {
        return hoursListFri[hour - 1];
      } else {
        return hoursListMonThuFirstGroup[hour - 1];
      }
    } else {
      if (day == 5) {
        return hoursListFri[hour - 1];
      } else {
        return hoursListMonThuSecondGroup[hour - 1];
      }
    }
  }

  static bool isInDayRange(bool isFirstGroup) {
    DateTime now = DateTime.now();

    DateTime maxHour = isFirstGroup
        ? DateTime(
            now.year,
            now.month,
            now.day,
            Utils.hoursListFri.last.startingTime.hour,
            Utils.hoursListFri.last.startingTime.minute)
        : DateTime(
            now.year,
            now.month,
            now.day,
            Utils.hoursListMonThuFirstGroup.last.startingTime.hour,
            Utils.hoursListMonThuFirstGroup.last.startingTime.minute);

    if ((now.weekday != 6 && now.weekday != 7) ||
        (now.weekday == 5 && now.isBefore(maxHour))) {
      return true;
    }

    return false;
  }

  static int getCurrentHourIndex() {
    DateTime nowDateTime = DateTime.now();
    TimeOfDay now =
        TimeOfDay(hour: nowDateTime.hour, minute: nowDateTime.minute);

    bool isFirstGroup = true;

    if (isInDayRange(isFirstGroup)) {
      if (now.isBefore(const TimeOfDay(hour: 7, minute: 0))) {
        return -1;
      }

      if (now.isAfter(TimeOfDay(
        hour: Utils.hoursListMonThuFirstGroup.last.startingTime.hour,
        minute: Utils.hoursListMonThuFirstGroup.last.startingTime.minute,
      ))) {
        return -2;
      }

      for (int i = 0; i < Utils.hoursListFri.length; i++) {
        if (now.isBefore(Utils.hoursListFri[i].startingTime)) {
          return i;
        }
      }

      return 0;
    }

    return -3;
  }

  static Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported
        .where((DisplayMode m) =>
            m.width == active.width && m.height == active.height)
        .toList()
      ..sort((DisplayMode a, DisplayMode b) =>
          b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode =
        sameResolution.isNotEmpty ? sameResolution.first : active;

    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);
  }

  static void setPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  static void unsetPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
