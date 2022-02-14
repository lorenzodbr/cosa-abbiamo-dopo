import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/tab_view.dart';
import 'package:cosa_abbiamo_dopo/pages/update_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<String>(
        future: Utils.isUpdated(),
        builder: (context, isUpdatedSnapshot) {
          if (isUpdatedSnapshot.hasData) {
            if (isUpdatedSnapshot.data != Utils.toBeUpdated) {
              return UpdatePage(version: isUpdatedSnapshot.data!);
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
                      "Ricerca aggiornamenti...",
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
      ),
      theme: ThemeData(
        textTheme: GoogleFonts.workSansTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: CustomColors.black,
              primary: CustomColors.black,
            ),
      ),
    );
  }
}
