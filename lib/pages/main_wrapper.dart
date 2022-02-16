import 'package:cosa_abbiamo_dopo/pages/tab_view.dart';
import 'package:cosa_abbiamo_dopo/pages/update_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool _skipUpdate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _skipUpdate || kIsWeb
        ? const TabView()
        : UpdatePage(
            refresh: () {
              setState(() {
                _skipUpdate = true;
              });
            },
          );
  }
}
