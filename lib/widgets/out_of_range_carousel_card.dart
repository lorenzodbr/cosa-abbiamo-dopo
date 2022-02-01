import 'package:flutter/material.dart';

class OutOfRangeCarouselCard extends StatelessWidget {
  final int hourRange;

  const OutOfRangeCarouselCard(this.hourRange);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color.fromRGBO(192, 192, 192, 1), width: 3)),
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
      case -1:
        return "È ancora presto,\nripassa dalle 7:00";
      case -2:
        return "Lezioni finite,\nripassa domani";
      default:
        return "Lezioni finite,\nripassa lunedì";
    }
  }
}
