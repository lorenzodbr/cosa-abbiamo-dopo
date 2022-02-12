import 'package:cosa_abbiamo_dopo/globals/marconi_teacher.dart';
import 'package:cosa_abbiamo_dopo/widgets/detail_row.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final TimeOfDay startHour;
  final TimeOfDay endHour;
  final List<MarconiTeacher> teachers;
  final String subject;
  final String room;
  final int hourIndex;

  final VoidCallback closeContainer;

  const DetailsPage({
    required this.subject,
    required this.teachers,
    required this.room,
    required this.hourIndex,
    required this.endHour,
    required this.startHour,
    required this.closeContainer,
  });

  static const hours = [
    "Prima",
    "Seconda",
    "Terza",
    "Quarta",
    "Quinta",
    "Sesta",
    "Settima",
    "Ottava"
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy > 15) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Dettagli"),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: "Chiudi",
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.black,
          body: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                DetailRow(
                  text: 'Materia',
                  value: subject,
                ),
                DetailRow(
                  text: 'Docent' + (teachers.length == 1 ? 'e' : 'i'),
                  value: _buildTeachersText(),
                ),
                DetailRow(
                  text: room.startsWith('L')
                      ? 'Laboratorio'
                      : room.startsWith('P')
                          ? 'Palestra'
                          : 'Aula',
                  value: room,
                ),
                DetailRow(
                  text: 'Ora',
                  value: hours[hourIndex - 1],
                ),
                DetailRow(
                  text: 'Ora di inizio',
                  value: startHour.format(context),
                ),
                DetailRow(
                  text: 'Ora di fine',
                  value: endHour.format(context),
                ),
              ],
            ),
          ),
        ));
  }

  String _buildTeachersText() {
    String res = "";

    for (int i = 0; i < teachers.length - 1; i++) {
      res += teachers[i].nameSurname + "\n";
    }

    res += teachers.last.nameSurname;

    return res;
  }
}
