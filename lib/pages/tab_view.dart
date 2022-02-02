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

    Utils.setPortrait();
    Utils.setOptimalDisplayMode();
    controller = PageController(initialPage: _index);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Utils.getRawData(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.hasError) {
            if (snapshot.data == '') {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Servizio momentaneamente non disponibile, riprova più tardi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                ],
              );
            }

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

  @override
  dispose() {
    Utils.unsetPortrait();
    super.dispose();
  }
}
