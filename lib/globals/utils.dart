import 'package:cosa_abbiamo_dopo/globals/extensions/time_of_day_extension.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_hour.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

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

  static List<MarconiHour> hoursListFriFirstGroup = [
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

  static List<MarconiHour> hoursListFriSecondGroup = [
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

  static Future<String> fetchData(context) async {
    String savedClass = getSavedClass();

    if (savedClass == '') {
      savedClass = (await getClasses())[0];
      setSavedClass(savedClass);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Ricordati di cambiare classe nelle impostazioni",
          ),
        ),
      );
    }

    Uri uri = Uri.parse(
        'https://apps.marconivr.it/orario/api.php?class=' + savedClass);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        justFetched();
        return response.body;
      } else {
        return '';
      }
    } catch (_) {
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

  static String getSavedClass() {
    return GetStorage().read('classe') ?? "";
  }

  static Future<String> fetchClasses() async {
    Uri uri = Uri.parse('https://apps.marconivr.it/orario/api.php');

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

  static void justFetched() {
    DateTime now = DateTime.now();

    GetStorage().write(
        'lastFetch', DateFormat("Il dd/MM/yyyy 'alle' kk:mm").format(now));
  }

  static String getLastFetch() {
    return GetStorage().read('lastFetch') ?? "";
  }

  static String getLastUpdate() {
    return GetStorage().read('lastUpdate') ?? "";
  }

  static void justUpdated() {
    DateTime now = DateTime.now();

    GetStorage().write(
        'lastUpdate', DateFormat("Il dd/MM/yyyy 'alle' kk:mm").format(now));
  }

  static Future<String> getRawClasses() async {
    return await fetchClasses();
  }

  static Future<List<String>> getClasses() async {
    String rawClassesString = await getRawClasses();

    if (rawClassesString == '') {
      return [];
    }

    return decodeClasses(rawClassesString);
  }

  static bool isFirstGroup(List<MarconiLesson> lessons) {
    return lessons[0].hourIndex == 1;
  }

  static void setGroup(int index) {
    GetStorage().write('groupIndex', index);
  }

  static Future<List<MarconiLesson>> getData(context) async {
    String data = await getRawData(context);

    return decodeData(data);
  }

  static List<MarconiLesson> getSavedData() {
    String rawSavedData = getRawSavedData();

    return decodeData(rawSavedData);
  }

  static String getRawSavedData() {
    return GetStorage().read('data') ?? "";
  }

  static Future<String> getRawData(context) async {
    String data = await updateData(context);

    return data;
  }

  static void setData(String s) {
    GetStorage().write('data', s);
  }

  static Future<String> updateData(context) async {
    String dataFromAPI = await fetchData(context);

    String savedData = getRawSavedData();

    if (savedData != dataFromAPI && dataFromAPI != '') {
      justUpdated();

      setData(dataFromAPI);

      return dataFromAPI;
    }

    return savedData;
  }

  static void setSavedClass(String s) {
    GetStorage().write('classe', s);
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

    bool isFirstGroup = lessons[0].hourIndex == 1;

    if (lessons[0].day != 5) {
      if (lessons[0].hourIndex == 1) {
        hours = hoursListMonThuFirstGroup;
        setGroup(1);
      } else {
        hours = hoursListMonThuSecondGroup;
        setGroup(2);
      }
    } else {
      hours = isFirstGroup ? hoursListFriFirstGroup : hoursListFriSecondGroup;
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

  static List<String> decodeClasses(String data) {
    List<String> decoded = data
        .substring(data.indexOf("[") + 2, data.indexOf("]") - 1)
        .split('","');

    decoded.removeWhere((element) => !element.startsWith(RegExp("[1-5]")));

    return decoded;
  }

  static MarconiHour getHourRange(int hour, int day, int firstOrSecondGroup) {
    if (firstOrSecondGroup == 1) {
      if (day == 5) {
        return hoursListFriFirstGroup[hour - 1];
      } else {
        return hoursListMonThuFirstGroup[hour - 1];
      }
    } else {
      if (day == 5) {
        return hoursListFriFirstGroup[hour - 1];
      } else {
        return hoursListMonThuSecondGroup[hour - 1];
      }
    }
  }

  static bool isInDayRange(bool isFirstGroup) {
    DateTime now = DateTime.now();

    DateTime maxHour;

    if (isFirstGroup) {
      maxHour = now.weekday == 5
          ? Utils.hoursListFriFirstGroup.last.startingTime.toDateTime()
          : Utils.hoursListMonThuFirstGroup.last.startingTime.toDateTime();
    } else {
      maxHour = now.weekday == 5
          ? Utils.hoursListFriSecondGroup.last.startingTime.toDateTime()
          : Utils.hoursListMonThuSecondGroup.last.startingTime.toDateTime();
    }

    print(now.weekday == 5 && now.isBefore(maxHour));

    if ((now.weekday != 6 && now.weekday != 7 && now.weekday != 5) ||
        (now.weekday == 5 && now.isBefore(maxHour))) {
      return true;
    }

    return false;
  }

  static int getCurrentHourIndex(isFirstGroup) {
    DateTime nowDateTime = DateTime.now();
    TimeOfDay now =
        TimeOfDay(hour: nowDateTime.hour, minute: nowDateTime.minute);

    if (isInDayRange(isFirstGroup)) {
      if (now.isBefore(const TimeOfDay(hour: 7, minute: 0))) {
        return -1;
      }

      if (nowDateTime.weekday != 5) {
        if (isFirstGroup) {
          if (now.isAfter(Utils.hoursListMonThuFirstGroup.last.startingTime)) {
            return -2;
          }
        } else {
          if (now.isAfter(Utils.hoursListMonThuSecondGroup.last.startingTime)) {
            return -2;
          }
        }
      } else {
        if (isFirstGroup) {
          if (now.isAfter(Utils.hoursListFriFirstGroup.last.startingTime)) {
            return -2;
          }
        } else {
          if (now.isAfter(Utils.hoursListFriSecondGroup.last.startingTime)) {
            return -2;
          }
        }
      }

      if (isFirstGroup) {
        for (int i = 0; i < Utils.hoursListFriFirstGroup.length; i++) {
          if (now.isBefore(Utils.hoursListFriFirstGroup[i].startingTime)) {
            return i;
          }
        }
      } else {
        for (int i = 0; i < Utils.hoursListFriSecondGroup.length; i++) {
          if (now.isBefore(Utils.hoursListFriSecondGroup[i].startingTime)) {
            return i;
          }
        }
      }

      return 0;
    }

    return -3;
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
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
