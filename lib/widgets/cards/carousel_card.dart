import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/extensions/time_of_day_extension.dart';
import 'package:cosa_abbiamo_dopo/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class CarouselCard extends StatelessWidget {
  final String lessonName;
  final String room;
  final VoidCallback openContainer;

  final VoidCallback? refresh;
  final TimeOfDay? startingHour;

  const CarouselCard(
      {required this.openContainer,
      required this.lessonName,
      required this.room,
      this.startingHour,
      this.refresh,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
      ),
      width: HomePage.carouselWidth,
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
      var _timeToGoWidget =
          TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
        Duration _timeToGoDuration =
            startingHour!.timeFromDateTime(DateTime.now());

        String _timeToGoFormatted = '';

        if (_timeToGoDuration.inSeconds.isNegative) {
          if (refresh != null) {
            WidgetsBinding.instance!
                .addPostFrameCallback((_) => refresh!.call());
          }
        } else {
          _timeToGoFormatted += 'fra';

          int hours = _timeToGoDuration.inHours;
          int minutes = _timeToGoDuration.inMinutes.remainder(60);
          int seconds = _timeToGoDuration.inSeconds.remainder(60);

          if (hours != 0) {
            _timeToGoFormatted += ' ${hours}h';
          }

          if (minutes != 0 || hours != 0) {
            _timeToGoFormatted += ' ${minutes}m';
          }

          _timeToGoFormatted += ' ${seconds}s';
        }

        return Text(
          _timeToGoFormatted,
          style: const TextStyle(
            color: CustomColors.silver,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
      });

      res.add(_timeToGoWidget);
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
}
