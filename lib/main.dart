import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/update_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await GetStorage.init();

  Utils.setPortrait();
  Utils.setOptimalDisplayMode();
  Utils.deleteCacheDir();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainWrapper(),
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
