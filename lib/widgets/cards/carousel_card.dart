import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/extensions/time_of_day_extension.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';

class CarouselCard extends StatefulWidget {
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
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
      ),
      width: HomePage.carouselHeight * Utils.goldenRatio,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildCardContent(),
      ),
    );
  }

  List<Widget> _buildCardContent() {
    List<Widget> res = [];

    if (widget.startingHour != null) {
      var _timeToGoWidget =
          TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
        Duration _timeToGoDuration =
            widget.startingHour!.timeFromDateTime(DateTime.now());

        String _timeToGoFormatted = '';

        if (_timeToGoDuration.isNegative) {
          WidgetsBinding.instance!.addPostFrameCallback((_) => () {
                print('refresh');
                widget.refresh!.call();
              });
        } else {
          _timeToGoFormatted =
              "fra ${_timeToGoDuration.inMinutes.remainder(60)}m ${(_timeToGoDuration.inSeconds.remainder(60))}s";
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
        widget.lessonName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        widget.room,
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
