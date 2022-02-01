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

class _TabViewState extends State<TabView> {
  int _index = 0;
  late PageController controller;

  late DateTime dataTime;

  List<Widget> tabPages = [
    const HomePage(),
    const Settings(),
    const InfoPage(),
  ];

  @override
  void initState() {
    super.initState();

    Utils.setOptimalDisplayMode();
    controller = PageController(initialPage: _index);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Utils.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError && !snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Servizio momentaneamente non disponibile,\nriprova più tardi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                )
              ],
            );
          }

          if (snapshot.hasData || snapshot.hasError) {
            return Scaffold(
                body: PageView(
                  children: tabPages,
                  onPageChanged: onPageChanged,
                  controller: controller,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _index,
                  onTap: onTabTapped,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "Impostazioni"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.info), label: "Info"),
                  ],
                ));
          } else {
            return Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    height: 50,
                    width: 50,
                  )
                ],
              ),
            );
          }
        });
  }

  void onPageChanged(int page) {
    setState(() {
      _index = page;
    });
  }

  void onTabTapped(int index) {
    controller.jumpToPage(index);
  }
}
