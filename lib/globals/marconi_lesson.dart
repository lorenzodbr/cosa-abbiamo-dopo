import 'package:cosa_abbiamo_dopo/globals/marconi_hour.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_teacher.dart';
import 'package:cosa_abbiamo_dopo/globals/extensions/string_extensions.dart';

class MarconiLesson {
  late MarconiHour hours;
  List<MarconiTeacher> teachers;
  String room;
  String name;
  int hourIndex;
  int day;

  MarconiLesson({
    required this.name,
    required this.room,
    required this.teachers,
    required this.hourIndex,
    required this.day,
  });

  factory MarconiLesson.fromJson(Map<String, dynamic> json) {
    String subject = json['materia'] as String;
    String room = json['aula'] as String;
    int hour = int.parse(json['ora'] as String);
    int day = int.parse(json['giorno'] as String);

    return MarconiLesson(
      name: subject,
      room: room,
      teachers: [
        MarconiTeacher(
          (json['prof'] as String).toTitleCase(),
        ),
      ],
      hourIndex: hour,
      day: day,
    );
  }
}
