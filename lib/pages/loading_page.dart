import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.refresh}) : super(key: key);

  final VoidCallback refresh;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.black,
      child: Column(
        children: [
          const Spacer(
            flex: 5,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Colors.white),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 30),
                child: Text(
                  "Caricamento",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
          DelayedDisplay(
            fadingDuration: const Duration(milliseconds: 200),
            delay: const Duration(seconds: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Ci sta volendo più tempo del previsto',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.all(5),
                ),
                OutlinedButton(
                  onPressed: () {
                    widget.refresh.call();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: CustomColors.darkGrey,
                    ),
                    primary: CustomColors.white,
                  ),
                  child: const Text(
                    "Mostra dati salvati",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
