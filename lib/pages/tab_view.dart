import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/homepage.dart';
import 'package:cosa_abbiamo_dopo/pages/info_page.dart';
import 'package:cosa_abbiamo_dopo/pages/loading_page.dart';
import 'package:cosa_abbiamo_dopo/pages/settings_page.dart';
import 'package:flutter/material.dart';

enum TabViewState {
  loading,
  ready,
}

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  late TabViewState _state;

  int _pageIndex = 0;

  late PageController _pageController;

  List<Widget> tabPages = [
    const HomePage(),
    const Settings(),
    const InfoPage(),
  ];

  @override
  void initState() {
    _state = TabViewState.loading;

    _pageController = PageController(
      initialPage: _pageIndex,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getRawData(context),
      builder: (context, getRawDataSnapshot) {
        if (getRawDataSnapshot.hasData ||
            getRawDataSnapshot.hasError ||
            _state == TabViewState.ready) {
          return Scaffold(
            body: PageView(
              children: tabPages,
              onPageChanged: _onPageChanged,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _pageIndex,
              onDestinationSelected: _onTabTapped,
              backgroundColor: Colors.grey[200],
              // selectedItemColor: CustomColors.black,
              shadowColor: CustomColors.black,
              elevation: 10,
              destinations: <Widget>[
                NavigationDestination(
                  icon: Icon(
                    _pageIndex == 0
                        ? Icons.access_time_filled
                        : Icons.access_time,
                  ),
                  label: "Orari",
                ),
                NavigationDestination(
                  icon: Icon(
                    _pageIndex == 1 ? Icons.settings : Icons.settings_outlined,
                  ),
                  label: "Impostazioni",
                ),
                NavigationDestination(
                  icon: Icon(
                    _pageIndex == 2 ? Icons.info : Icons.info_outline,
                  ),
                  label: "Informazioni",
                ),
              ],
            ),
          );
        } else {
          return LoadingPage(
            refresh: () => _setTabViewState(TabViewState.ready),
          );
        }
      },
    );
  }

  void _setTabViewState(TabViewState state) {
    setState(() {
      _state = state;
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void _onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }
}
