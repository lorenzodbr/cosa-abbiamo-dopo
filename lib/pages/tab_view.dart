import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/homepage.dart';
import 'package:cosa_abbiamo_dopo/pages/info_page.dart';
import 'package:cosa_abbiamo_dopo/pages/loading_page.dart';
import 'package:cosa_abbiamo_dopo/pages/settings_page.dart';
import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  int _pageIndex = 0;
  bool _skipLoading = false;

  late PageController _pageController;

  List<Widget> tabPages = [
    const HomePage(),
    const Settings(),
    const InfoPage(),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: _pageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.getRawData(context),
      builder: (context, getRawDataSnapshot) {
        if (getRawDataSnapshot.hasData ||
            getRawDataSnapshot.hasError ||
            _skipLoading) {
          return Scaffold(
            body: PageView(
              children: tabPages,
              onPageChanged: onPageChanged,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _pageIndex,
              onTap: onTabTapped,
              backgroundColor: Colors.white,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Impostazioni"),
                BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
              ],
            ),
          );
        } else {
          return LoadingPage(setState: () {
            setState(() {
              _skipLoading = true;
            });
          });
        }
      },
    );
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  dispose() {
    Utils.unsetPortrait();
    super.dispose();
  }
}
