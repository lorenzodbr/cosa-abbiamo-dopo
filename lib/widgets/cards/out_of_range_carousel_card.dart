import 'package:cosa_abbiamo_dopo/globals/extensions/string_extensions.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OutOfRangeCarouselCard extends StatelessWidget {
  final int hourRange;

  const OutOfRangeCarouselCard(this.hourRange, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.carouselWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color.fromRGBO(192, 192, 192, 1),
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _selectOutOfRangeText(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(192, 192, 192, 1),
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _selectOutOfRangeText() {
    switch (hourRange) {
      case Utils.beforeSchoolTime:
        return "È ancora presto,\nripassa dalle 7:00";
      case Utils.afterSchoolTime:
        return "Lezioni finite,\nripassa domani";
      case Utils.noSchoolDay:
        return "Lezioni finite,\nripassa lunedì";
      case Utils.schoolEnded:
        return "Lezioni finite,\nripassa a Settembre";
      case Utils.schoolYetToStart:
        return "Lezioni finite,\nripassa il " +
            DateFormat("d MMMM", 'it')
                .format(Utils.firstDayOfSchool)
                .toString()
                .toTitleCase();
      default:
        return "Nessun orario da mostrare";
    }
  }
}
