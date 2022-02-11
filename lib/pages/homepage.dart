import 'package:animations/animations.dart';
import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/details_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosa_abbiamo_dopo/widgets/carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/out_of_range_carousel_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _hourIndex = 0;
  bool hasData = false;
  bool hasClass = false;
  bool isFetching = false;

  int _carouselIndex = -1;
  late String _formattedDate;
  late CarouselController _controller;

  late String _savedClass;
  late List<MarconiLesson> _savedData;
  late bool _isFirstGroup;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    DateTime _now = DateTime.now();
    DateFormat _formatter = DateFormat('EEEE dd MMMM yyyy', 'it');
    _formattedDate = _formatter.format(_now);

    _savedClass = Utils.getSavedClass();

    _savedData = Utils.getSavedData();

    _isFirstGroup = Utils.isFirstGroup(_savedData);

    _hourIndex = Utils.getCurrentHourIndex(_isFirstGroup);

    _controller = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    if (_carouselIndex < 0) {
      _carouselIndex = _hourIndex;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClassAndDateRow(),
                const Text(
                  "Cosa abbiamo dopo?",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 50,
                  ),
                ),
              ],
            ),
          ),
          _buildCarousel(),
        ],
      ),
    );
  }

  Widget _buildClassAndDateRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(
            _savedClass + ' | ' + _formattedDate,
            style: const TextStyle(fontSize: 18, color: CustomColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return _hourIndex >= 0
        ? Column(
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                itemBuilder: (context, index, realIndex) {
                  return OpenContainer<String>(
                    openBuilder: (_, closeContainer) => DetailsPage(
                      subject: _savedData[index].name,
                      teachers: _savedData[index].teachers,
                      room: _savedData[index].room,
                      startHour: _savedData[index].hours.startingTime,
                      endHour: _savedData[index].hours.endingTime,
                      closeContainer: closeContainer,
                    ),
                    closedBuilder: (_, openContainer) => CarouselCard(
                      openContainer,
                      _savedData[index].name,
                      _savedData[index].room,
                      startingHour: _savedData[0].hourIndex == 1
                          ? (index == _hourIndex
                              ? _savedData[index].hours.startingTime
                              : null)
                          : (index == _hourIndex - 2
                              ? _savedData[index].hours.startingTime
                              : null),
                    ),
                    openColor: CustomColors.black,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    closedColor: CustomColors.black,
                  );
                },
                itemCount: _savedData.length,
                options: CarouselOptions(
                  initialPage: _hourIndex,
                  height: 200,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _carouselIndex = index;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: AnimatedSmoothIndicator(
                  activeIndex: _carouselIndex,
                  count: _savedData.length,
                  effect: const WormEffect(
                    activeDotColor: CustomColors.black,
                    dotColor: CustomColors.silver,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
              )
            ],
          )
        : CarouselSlider.builder(
            itemBuilder: (context, index, realIndex) {
              return OutOfRangeCarouselCard(_hourIndex);
            },
            itemCount: 1,
            options: CarouselOptions(
              initialPage: 0,
              height: 200,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
          );
  }
}
