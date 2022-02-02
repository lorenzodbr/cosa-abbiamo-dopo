import 'package:flutter/material.dart';

class LoadingCarouselCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
      ),
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
