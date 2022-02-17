import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/homepage.dart';
import 'package:flutter/material.dart';

class NoDataCarouselCard extends StatelessWidget {
  const NoDataCarouselCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: HomePage.carouselHeight * Utils.goldenRatio,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: const Color.fromRGBO(192, 192, 192, 1), width: 3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Connettiti a Internet per scaricare gli orari",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(192, 192, 192, 1),
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
