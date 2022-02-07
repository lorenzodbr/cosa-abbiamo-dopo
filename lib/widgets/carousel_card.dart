import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/extensions/time_of_day_extension.dart';
import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  final String lessonName;
  final String room;
  final VoidCallback openContainer;

  final TimeOfDay? startingHour;

  const CarouselCard(this.openContainer, this.lessonName, this.room,
      {this.startingHour});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
      ),
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildCardContent(),
      ),
    );
  }

  List<Widget> _buildCardContent() {
    List<Widget> res = [];

    if (startingHour != null) {
      int minutes = _timeToGo().inMinutes;

      Text timeToGo = Text(
        "fra $minutes minut" + (minutes == 1 ? "o" : "i"),
        style: const TextStyle(
          color: CustomColors.silver,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );

      res.add(timeToGo);
    }

    res.addAll([
      Text(
        lessonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        room,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);

    return res;
  }

  Duration _timeToGo() {
    TimeOfDay now = TimeOfDay.now();

    return startingHour!.timeFrom(now);
  }
}
