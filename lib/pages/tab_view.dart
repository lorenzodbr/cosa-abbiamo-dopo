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

  late PageController _pageController;
  late Animation<double> _animation;
  late AnimationController _animationController;

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

    _pageController = PageController(
      initialPage: _pageIndex,
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeIn),
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
          return Material(
            child: Container(
              color: CustomColors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 400,
                    child: Column(
                      children: const [
                        CircularProgressIndicator(color: Colors.white),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 30),
                          child: Text(
                            "Caricamento...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    child: FadeTransition(
                      opacity: _animation,
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
                              side: const BorderSide(
                                  color: CustomColors.darkGrey),
                              primary: CustomColors.white,
                            ),
                            child: const Text(
                              "Mostra dati salvati",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
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
    _pageController.jumpToPage(index);
  }

  @override
  dispose() {
    Utils.unsetPortrait();
    super.dispose();
  }
}
