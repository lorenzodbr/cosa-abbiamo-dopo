import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/tab_view.dart';
import 'package:cosa_abbiamo_dopo/pages/update/update_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum MainWrapperState {
  update,
  tabview,
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late MainWrapperState _state;

  @override
  void initState() {
    if (kIsWeb) {
      _state = MainWrapperState.tabview;
    } else {
      _state = MainWrapperState.update;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case MainWrapperState.update:
        return UpdateWrapper(
          refresh: () => setWrapperState(MainWrapperState.tabview),
        );
      case MainWrapperState.tabview:
      default:
        return const TabView();
    }
  }

  void setWrapperState(MainWrapperState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      Utils.unsetPortrait();
    }

    super.dispose();
  }
}
