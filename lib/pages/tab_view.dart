import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/homepage.dart';
import 'package:cosa_abbiamo_dopo/pages/info_page.dart';
import 'package:cosa_abbiamo_dopo/pages/settings_page.dart';
import 'package:flutter/material.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  int _pageIndex = 0;
  bool _skipLoading = false;

  late PageController _controller;

  List<Widget> tabPages = [
    const HomePage(),
    const Settings(),
    const InfoPage(),
  ];

  @override
  void initState() {
    super.initState();

    Utils.setPortrait();
    Utils.setOptimalDisplayMode();
    _controller = PageController(initialPage: _pageIndex);
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
              controller: _controller,
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
          return Scaffold(
            backgroundColor: CustomColors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 30),
                    child: Text(
                      "Ottengo gli orari...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: CurvedAnimation(
                      parent: AnimationController(
                        duration: const Duration(seconds: 3),
                        vsync: this,
                      )..forward(),
                      curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Ci sta volendo\npiù tempo del previsto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Padding(padding: EdgeInsets.all(2)),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _skipLoading = true;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: CustomColors.darkGrey),
                            primary: CustomColors.white,
                          ),
                          child: const Text(
                            "Mostra dati salvati",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
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
    _controller.jumpToPage(index);
  }

  @override
  dispose() {
    Utils.unsetPortrait();
    super.dispose();
  }
}
