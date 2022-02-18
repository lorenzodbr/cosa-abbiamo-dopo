import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:flutter/material.dart';

class UpdateErrorPage extends StatelessWidget {
  const UpdateErrorPage({Key? key, required this.refresh}) : super(key: key);

  final VoidCallback refresh;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.black,
      child: Column(
        children: [
          const Spacer(
            flex: 5,
          ),
          const Icon(
            Icons.wifi_off,
            size: 80,
            color: CustomColors.grey,
          ),
          const Text(
            "Nessuna connessione a internet.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          OutlinedButton(
            onPressed: refresh,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: CustomColors.darkGrey),
              primary: CustomColors.white,
            ),
            child: const Text(
              "Mostra dati salvati",
              style: TextStyle(color: Colors.white, fontSize: 12),
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
