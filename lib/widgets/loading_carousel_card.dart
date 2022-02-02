import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:flutter/material.dart';

class LoadingCarouselCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
      ),
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Caricamento...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
