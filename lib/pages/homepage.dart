import 'package:animations/animations.dart';
import 'package:clean_settings/clean_settings.dart';
import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/details_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosa_abbiamo_dopo/widgets/cards/carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/cards/no_data_carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/cards/out_of_range_carousel_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  int _carouselIndex = -1;
  late String _formattedDate;

  late String _savedClass;
  late List<MarconiLesson> _savedData;
  late bool _isFirstGroup;

  late Function refresh;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    DateTime _now = DateTime.now();
    DateFormat _formatter = DateFormat("EEE'.' dd MMMM yyyy", 'it');
    _formattedDate = _formatter.format(_now);

    _savedClass = Utils.getSavedClass();

    try {
      _savedData = Utils.getSavedData();

      _isFirstGroup = Utils.isFirstGroup(_savedData);

      _hourIndex = Utils.getCurrentHourIndex(_isFirstGroup);
    } catch (_) {
      _savedData = [];

      _isFirstGroup = true;

      _hourIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carouselIndex < 0) {
      _carouselIndex = _isFirstGroup ? _hourIndex : _hourIndex - 2;
    }

    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClassAndDateRow(),
                const Text(
                  'Cosa abbiamo dopo?',
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
    Text _formattedDateText = Text(
      '| ' + _formattedDate,
      style: const TextStyle(fontSize: 18, color: CustomColors.grey),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: _savedClass != Utils.empty
            ? [
                TextButton.icon(
                  onPressed: () async {
                    await _showClassSelector();

                    setState(() {
                      _savedClass = Utils.getSavedClass();
                    });
                  },
                  icon: const Icon(Icons.edit, color: CustomColors.grey),
                  label: Text(
                    _savedClass,
                    style:
                        const TextStyle(fontSize: 18, color: CustomColors.grey),
                  ),
                ),
                _formattedDateText,
              ]
            : [
                _formattedDateText,
              ],
      ),
    );
  }

  Future<void> _showClassSelector() async {
    String _savedClass = Utils.getSavedClass();

    int _initialValueIndex = 0;
    int _selectedValueIndex = 0;

    List<String> _classes = [];

    int _changedValueIndex = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, _selectedValueIndex),
            )
          ],
          title: const Text('Seleziona classe'),
          content: Container(
            constraints:
                const BoxConstraints(minHeight: 100.0, maxHeight: 100.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<List<String>>(
                  future: Utils.getClasses(),
                  builder: (context, getClassesSnapshot) {
                    if (getClassesSnapshot.hasError) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.wifi_off,
                              size: 50,
                              color: CustomColors.grey,
                            ),
                            Text(
                              'Nessuna connessione',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: CustomColors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (getClassesSnapshot.hasData) {
                      _classes = getClassesSnapshot.data ?? [];

                      if (_classes.isNotEmpty) {
                        _initialValueIndex = _classes.indexOf(_savedClass);

                        _selectedValueIndex = _initialValueIndex;
                        return Expanded(
                          child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                                initialItem: _selectedValueIndex),
                            itemExtent: 50.0,
                            onSelectedItemChanged: (int value) {
                              _selectedValueIndex = value;
                            },
                            children: getClassesSnapshot.data!
                                .map(
                                  (e) => Center(
                                    child: Text(
                                      e.toString(),
                                      style: GoogleFonts.workSans(
                                        textStyle: kWheelPickerItem,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }
                      return const Expanded(
                        child: Text(
                          "Impossibile caricare l'elenco delle classi",
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (_changedValueIndex != null &&
        _changedValueIndex != _initialValueIndex) {
      Utils.showUpdatingDialog(context);

      String previousClass = Utils.getSavedClass();

      Utils.setSavedClass(_classes[_changedValueIndex]);

      try {
        String _data = await Utils.getRawData(context);

        if (_data == Utils.empty) {
          Utils.setSavedClass(previousClass);

          Navigator.pop(context);

          Utils.showErrorDialog(context, 1);
        } else {
          setState(() {
            _savedData = Utils.getSavedData();
          });

          Navigator.pop(context);
        }
      } catch (ex) {
        Utils.setSavedClass(previousClass);

        Navigator.pop(context);

        Utils.showErrorDialog(context, 0);
      }
    }
  }

  Widget _buildCarousel() {
    if (_hourIndex >= Utils.inSchoolTime) {
      if (_savedData.isNotEmpty) {
        return Column(
          children: [
            CarouselSlider.builder(
              itemBuilder: (context, index, realIndex) {
                return OpenContainer<String>(
                  openBuilder: (_, closeContainer) => DetailsPage(
                    subject: _savedData[index].name,
                    teachers: _savedData[index].teachers,
                    room: _savedData[index].room,
                    startHour: _savedData[index].hours.startingTime,
                    endHour: _savedData[index].hours.endingTime,
                    closeContainer: closeContainer,
                    hourIndex: _isFirstGroup
                        ? _savedData[index].hourIndex
                        : _savedData[index].hourIndex - 2,
                  ),
                  closedBuilder: (_, openContainer) => CarouselCard(
                      openContainer,
                      _savedData[index].name,
                      _savedData[index].room,
                      startingHour:
                          index == (_isFirstGroup ? _hourIndex : _hourIndex - 2)
                              ? _savedData[index].hours.startingTime
                              : null),
                  openColor: CustomColors.black,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  closedColor: CustomColors.black,
                );
              },
              itemCount: _savedData.length,
              options: CarouselOptions(
                initialPage: _isFirstGroup ? _hourIndex : _hourIndex - 2,
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
        );
      } else {
        return CarouselSlider.builder(
          itemBuilder: (context, index, realIndex) {
            return const NoDataCarouselCard();
          },
          itemCount: 1,
          options: CarouselOptions(
            height: 200,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        );
      }
    } else {
      return CarouselSlider.builder(
        itemBuilder: (context, index, realIndex) {
          return OutOfRangeCarouselCard(_hourIndex);
        },
        itemCount: 1,
        options: CarouselOptions(
          height: 200,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }
}
