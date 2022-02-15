import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/tab_view.dart';
import 'package:cosa_abbiamo_dopo/pages/update_page.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool _skipUpdate = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Utils.isUpdated(),
      builder: (context, isUpdatedSnapshot) {
        if (isUpdatedSnapshot.hasError && !_skipUpdate) {
          return UpdatePage(
            hasError: true,
            skipUpdate: () {
              setState(() {
                _skipUpdate = true;
              });
            },
          );
        }

        if (isUpdatedSnapshot.hasData || _skipUpdate) {
          if (isUpdatedSnapshot.data != Utils.toBeUpdated) {
            return UpdatePage(
              version: isUpdatedSnapshot.data,
              hasError: false,
            );
          } else {
            return const TabView();
          }
        } else {
          return Material(
            color: CustomColors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.white),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(
                    "Ricerca di aggiornamenti",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
