import 'dart:io';

import 'package:cosa_abbiamo_dopo/globals/extensions/time_of_day_extension.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_hour.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_teacher.dart';
import 'package:flowder_v2/flowder.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';

class Utils {
  static const int inSchoolTime = 0;
  static const int beforeSchoolTime = -1;
  static const int afterSchoolTime = -2;
  static const int noSchoolDay = -3;
  static const int schoolEnded = -4;
  static const int schoolYetToStart = -5;

  static DateTime firstDayOfSchool = DateTime(2023, 9, 13, 0, 0, 0);
  static DateTime lastDayOfSchool = DateTime(2024, 6, 7, 23, 59, 59);

  static const int easterEggUpperLimit = 15;
  static const int easterEggStartingLimit = 10;

  static const double goldenRatio = 1.618;

  static const double carouselHeight = 200;
  static const double carouselWidth = carouselHeight * Utils.goldenRatio;
  static const double dotIndicatorsSize = 10;

  static const String savedClass = 'class';
  static const String savedData = 'data';
  static const String lastFetch = 'lastFetch';
  static const String lastUpdate = 'lastUpdate';
  static const String easterEgg = 'easterEgg';

  static const String baseUrl = 'https://apps.marconivr.it/orario/api.php';
  static const String baseProjectUrl =
      'https://github.com/lorenzodbr/cosa-abbiamo-dopo';
  static const String baseProjectAPIUrl =
      'https://api.github.com/repos/lorenzodbr/cosa-abbiamo-dopo/releases/latest';
  static const String baseProjectDownloadUrl =
      'https://github.com/lorenzodbr/cosa-abbiamo-dopo/releases';
  static const String baseWebAppUrl =
      'https://lorenzodbr.github.io/cosa-abbiamo-dopo';

  static const String apkFileName = 'app-release.apk';

  static const String telegramUrl = 'https://t.me/lorenzodiberardino';
  static const String emailUrl = 'mailto:lorenzo.diberardino03@gmail.com';
  static const String rickRollUrl =
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

  static const String empty = '';
  static const String notToBeUpdated = '0';

  static List<MarconiHour> hoursList = [
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 8, minute: 50),
    ),
    MarconiHour(
      const TimeOfDay(hour: 8, minute: 50),
      const TimeOfDay(hour: 9, minute: 50),
    ),
    MarconiHour(
      const TimeOfDay(hour: 9, minute: 50),
      const TimeOfDay(hour: 10, minute: 50),
    ),
    MarconiHour(
      const TimeOfDay(hour: 10, minute: 50),
      const TimeOfDay(hour: 11, minute: 50),
    ),
    MarconiHour(
      const TimeOfDay(hour: 11, minute: 50),
      const TimeOfDay(hour: 12, minute: 50),
    ),
    MarconiHour(
      const TimeOfDay(hour: 12, minute: 50),
      const TimeOfDay(hour: 13, minute: 40),
    ),
  ];

  static Future<String> fetchData(context) async {
    String _savedClass = getSavedClass();

    if (_savedClass == empty) {
      List<String> _classes = [];

      try {
        _classes = await getClasses();

        if (_classes.isNotEmpty) {
          _savedClass = _classes[0];
          setSavedClass(_savedClass);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Ricordati di cambiare classe',
                style: GoogleFonts.workSans(),
              ),
            ),
          );
        } else {
          return empty;
        }
      } catch (_) {
        return empty;
      }
    }

    Uri _uri = Uri.parse('$baseUrl?class=$_savedClass');

    try {
      final _response = await http.get(_uri);

      if (_response.statusCode == 200) {
        justFetched();
        return _response.body;
      } else {
        return empty;
      }
    } catch (_) {
      rethrow;
    }
  }

  static Future<bool> isClassSet() async {
    final _prefs = await SharedPreferences.getInstance();

    if ((_prefs.getString(savedClass) ?? empty).isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static String getSavedClass() {
    return GetStorage().read(savedClass) ?? empty;
  }

  static Future<String> fetchClasses() async {
    Uri _uri = Uri.parse(baseUrl);

    try {
      final response = await http.get(_uri);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return empty;
      }
    } catch (ex) {
      rethrow;
    }
  }

  static void justFetched() {
    DateTime _now = DateTime.now();

    GetStorage().write(
        lastFetch, DateFormat("Il dd/MM/yyyy 'alle' kk:mm").format(_now));
  }

  static String getLastFetch() {
    return GetStorage().read(lastFetch) ?? 'Non ancora effettuata';
  }

  static String getLastUpdate() {
    return GetStorage().read(lastUpdate) ?? 'Non ancora effettuato';
  }

  static void justUpdated() {
    DateTime _now = DateTime.now();

    GetStorage().write(
        lastUpdate, DateFormat("Il dd/MM/yyyy 'alle' kk:mm").format(_now));
  }

  static Future<String> getRawClasses() async {
    try {
      return await fetchClasses();
    } catch (_) {
      rethrow;
    }
  }

  static Future<List<String>> getClasses() async {
    try {
      String _rawClassesString = await getRawClasses();

      if (_rawClassesString == empty) {
        return [];
      }

      return decodeClasses(_rawClassesString);
    } catch (_) {
      rethrow;
    }
  }

  static Future<List<MarconiLesson>> getData(context) async {
    String _data = await getRawData(context);

    return decodeData(_data);
  }

  static List<MarconiLesson> getSavedData() {
    String _rawSavedData = getRawSavedData();

    return decodeData(_rawSavedData);
  }

  static String getRawSavedData() {
    return GetStorage().read(savedData) ?? empty;
  }

  static Future<String> getRawData(context) async {
    String _data = await updateData(context);

    return _data;
  }

  static void setSavedData(String s) {
    GetStorage().write(savedData, s);
  }

  static Future<String> updateData(context) async {
    String _dataFromAPI = await fetchData(context);

    String _savedData = getRawSavedData();

    if (_savedData != _dataFromAPI && _dataFromAPI != empty) {
      justUpdated();

      setSavedData(_dataFromAPI);

      return _dataFromAPI;
    }

    return _savedData;
  }

  static void setSavedClass(String s) {
    GetStorage().write(savedClass, s);
  }

  static List<MarconiLesson> filterForToday(List<MarconiLesson> lessons) {
    List<MarconiLesson> _result = [];
    DateTime _today = DateTime.now();

    for (var lesson in lessons) {
      if (lesson.day == _today.weekday) {
        _result.add(lesson);
      }
    }

    _result.sort(
      (a, b) => a.hourIndex.compareTo(b.hourIndex),
    );

    return _result;
  }

  static List<MarconiLesson> groupTeachers(List<MarconiLesson> lessons) {
    List<MarconiLesson> _result = [];

    for (int i = 0; i < lessons.length; i++) {
      int _offset = 0;
      List<MarconiTeacher> _teachers = [];

      _teachers.addAll(lessons[i].teachers);

      while (i + _offset + 1 < lessons.length &&
          lessons[i].hourIndex == lessons[i + _offset + 1].hourIndex) {
        _teachers.add(lessons[i + _offset + 1].teachers[0]);
        _offset++;
      }

      _teachers.sort((a, b) => a.nameSurname.compareTo(b.nameSurname));

      lessons[i].teachers = _teachers;

      _result.add(lessons[i]);

      i += _offset;
    }

    return _result;
  }

  static List<MarconiLesson> setHours(List<MarconiLesson> lessons) {
    if (lessons.isNotEmpty) {
      List<MarconiHour> hours;

      hours = hoursList;

      for (int i = 0; i < lessons.length; i++) {
        lessons[i].hours = hours[lessons[i].hourIndex - 1];
        lessons[i].name =
            lessons[i].name.replaceAll(RegExp(r' - $'), Utils.empty);
      }
    }

    return lessons;
  }

  static List<MarconiLesson> decodeData(String data) {
    final _casted = jsonDecode(data).cast<Map<String, dynamic>>();

    List<MarconiLesson> _parsed = _casted
        .map<MarconiLesson>((json) => MarconiLesson.fromJson(json))
        .toList();

    return setHours(groupTeachers(filterForToday(_parsed)));
  }

  static List<String> decodeClasses(String data) {
    final List<String> _parsed = data
        .substring(data.indexOf('[') + 2, data.indexOf(']') - 1)
        .split(RegExp('","'));

    _parsed.removeWhere((element) => !element.startsWith(RegExp('[1-5]')));

    return _parsed;
  }

  static List<PickerItem> encodeClassesForPicker(List<String> classes) {
    List<PickerItem> wrapper = [
      PickerItem(value: '1', children: []),
      PickerItem(value: '2', children: []),
      PickerItem(value: '3', children: []),
      PickerItem(value: '4', children: []),
      PickerItem(value: '5', children: [])
    ];

    for (String currentClass in classes) {
      int extractedClass = int.parse(currentClass[0]);

      String extractedSection = currentClass.substring(1);

      wrapper[extractedClass - 1].children!.add(PickerItem(
            value: extractedSection,
          ));
    }

    return wrapper;
  }

  static bool isInDayRange() {
    DateTime _now = DateTime.now();

    DateTime _maxHour;

    if (_now.isBefore(firstDayOfSchool) || _now.isAfter(lastDayOfSchool)) {
      return false;
    }

    _maxHour = Utils.hoursList.last.startingTime.toDateTime();

    if ((_now.weekday != 6 && _now.weekday != 7 && _now.weekday != 5) ||
        (_now.weekday == 5 && _now.isBefore(_maxHour))) {
      return true;
    }

    return false;
  }

  static int getNextHourIndex() {
    DateTime _nowDateTime = DateTime.now();
    TimeOfDay _now = TimeOfDay.fromDateTime(_nowDateTime);

    if (isInDayRange()) {
      if (_now.isBefore(const TimeOfDay(hour: 7, minute: 0))) {
        return beforeSchoolTime;
      }

      List<MarconiHour> _workingLessonsList = hoursList;

      if (_now.isAfter(_workingLessonsList.last.startingTime)) {
        return afterSchoolTime;
      }

      for (int i = 0; i < _workingLessonsList.length; i++) {
        if (_now.isBefore(_workingLessonsList[i].startingTime)) {
          return i;
        }
      }

      return inSchoolTime;
    }

    if (_nowDateTime.isAfter(lastDayOfSchool)) {
      return schoolEnded;
    }

    if (_nowDateTime.isBefore(firstDayOfSchool)) {
      return schoolYetToStart;
    }

    return noSchoolDay;
  }

  static Future<String> getAppVersion() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    return _packageInfo.version;
  }

  static Future<void> setOptimalDisplayMode() async {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  static Future<void> showUpdatingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Aggiornamento dei dati'),
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showErrorDialog(
      BuildContext context, int errorCode) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Errore'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(errorCode == 1
                    ? 'Si è verificato un errore nello scaricamento degli orari.\n\nRiprova.'
                    : "Connettiti a Internet per scaricare gli orari."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<String> isUpdated() async {
    try {
      String _rawVersion = await fetchVersion();

      String _currentVersion = 'v' + (await getAppVersion());

      String _decodedVersion = decodeVersion(_rawVersion);

      bool _needsToBeUpdated = _currentVersion.compareTo(_decodedVersion) < 0;

      if (_needsToBeUpdated) {
        return _decodedVersion;
      } else {
        return notToBeUpdated;
      }
    } catch (_) {
      rethrow;
    }
  }

  static Future<void> deleteCachedApks() async {
    Directory cacheDir = await getCachePath();

    cacheDir.listSync().forEach((element) {
      if (element.path.endsWith('.apk')) {
        element.deleteSync();
      }
    });
  }

  static Future<Directory> getCachePath() async {
    return await getTemporaryDirectory();
  }

  static Future<String> fetchVersion() async {
    Uri _uri = Uri.parse(baseProjectAPIUrl);

    try {
      final _response = await http.get(_uri);

      if (_response.statusCode == 200) {
        return _response.body;
      } else {
        return empty;
      }
    } catch (_) {
      rethrow;
    }
  }

  static String decodeVersion(String data) {
    String tempSplitted = data.split('"tag_name":')[1];

    if (tempSplitted.startsWith('"')) {
      String splitted = tempSplitted;

      String version = splitted.substring(1, splitted.indexOf('",'));

      return version;
    } else {
      return '';
    }
  }

  static Future downloadUpdate(options, version) async {
    String url =
        Utils.baseProjectDownloadUrl + '/download/$version/$apkFileName';

    return await Flowder.download(
      url,
      options,
    );
  }

  static void unlockEasterEgg() {
    GetStorage().write(easterEgg, true);
  }

  static void lockEasterEgg() {
    GetStorage().write(easterEgg, false);
  }

  static bool wasEasterEggUnlocked() {
    return GetStorage().read(easterEgg) ?? false;
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
