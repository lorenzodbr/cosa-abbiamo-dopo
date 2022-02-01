import 'package:animations/animations.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/details_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosa_abbiamo_dopo/widgets/carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/loading_carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/out_of_range_carousel_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int hourIndex = 0;
  bool hasData = false;
  bool hasClass = false;
  bool isFetching = false;

  late String selectedClass;
  late String formattedDate;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
    var now = DateTime.now();
    var formatter = DateFormat('EEEE dd MMMM yyyy', 'it');
    formattedDate = formatter.format(now);
  }

  List lessons = [
    "Prima ora",
    "Seconda ora",
    "Terza ora",
    "Quarta ora",
    "Quinta ora",
    "Sesta ora"
  ];

  @override
  Widget build(BuildContext context) {
    int hourIndex = Utils.getCurrentHourIndex();

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: FutureBuilder<String>(
                    future: Utils.getSavedClass(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == '') {
                          Utils.setSavedClass(Utils.getClasses(snapshot.data!)[
                              0]); //implementare fetch dinamico delle classi

                        }
                        return Row(
                          children: [
                            Text(
                              snapshot.data!,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              ' | ' + formattedDate,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            )
                          ],
                        );
                      } else {
                        return const Text(
                          'Caricamento...',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        );
                      }
                    },
                  ),
                ),
                const Text(
                  "Cosa abbiamo dopo?",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 50),
                ),
              ],
            ),
          ),
          hourIndex >= 0
              ? FutureBuilder<List<MarconiLesson>>(
                  future: Utils.getSavedData(),
                  builder: (context, getDataSnapshot) {
                    if (getDataSnapshot.hasError) {
                      print(getDataSnapshot.error);
                    }
                    if (getDataSnapshot.hasData) {
                      return Column(
                        children: [
                          CarouselSlider.builder(
                            itemBuilder: (context, index, realIndex) {
                              return OpenContainer<String>(
                                openBuilder: (_, closeContainer) => DetailsPage(
                                  subject: getDataSnapshot.data![index].name,
                                  teachers:
                                      getDataSnapshot.data![index].teachers,
                                  room: getDataSnapshot.data![index].room,
                                  startHour: getDataSnapshot
                                      .data![index].hours.startingTime,
                                  endHour: getDataSnapshot
                                      .data![index].hours.endingTime,
                                  closeContainer: closeContainer,
                                ),
                                closedBuilder: (_, openContainer) =>
                                    CarouselCard(
                                        openContainer,
                                        getDataSnapshot.data![index].name,
                                        getDataSnapshot.data![index].room),
                                openColor: Colors.black,
                                closedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                closedColor: Colors.black,
                              );
                            },
                            itemCount: getDataSnapshot.data!.length,
                            options: CarouselOptions(
                              initialPage: 0,
                              height: 200,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CarouselSlider.builder(
                        itemBuilder: (context, index, realIndex) {
                          return LoadingCarouselCard();
                        },
                        itemCount: 1,
                        options: CarouselOptions(
                          initialPage: hourIndex,
                          height: 200,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      );
                    }
                  },
                )
              : CarouselSlider.builder(
                  itemBuilder: (context, index, realIndex) {
                    return OutOfRangeCarouselCard(hourIndex);
                  },
                  itemCount: 1,
                  options: CarouselOptions(
                    initialPage: 0,
                    height: 200,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
        ],
      ),
    );
  }
}
