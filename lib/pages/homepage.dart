import 'package:animations/animations.dart';
import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/details_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cosa_abbiamo_dopo/widgets/cards/carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/cards/no_data_carousel_card.dart';
import 'package:cosa_abbiamo_dopo/widgets/cards/out_of_range_carousel_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_picker/flutter_picker.dart';

enum ClassesChooserState { fetching, ready, error }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _hourIndex = 0;
  int _carouselIndex = 0;

  late String _formattedDate;
  late String _savedClass;
  late List<MarconiLesson> _savedData;
  late bool _isFirstGroup;
  late CarouselController _carouselController;
  late ClassesChooserState _classesChooserState;

  @override
  void initState() {
    initializeDateFormatting();

    _carouselController = CarouselController();

    DateTime _now = DateTime.now();
    DateFormat _formatter = DateFormat("EEE'.' dd MMMM yyyy", 'it');
    _formattedDate = _formatter.format(_now);

    _savedClass = Utils.getSavedClass();
    _classesChooserState = ClassesChooserState.ready;

    try {
      _savedData = Utils.getSavedData();

      _isFirstGroup = Utils.isFirstGroup(_savedData);

      _hourIndex = Utils.getNextHourIndex(_isFirstGroup);

      _carouselIndex = _isFirstGroup ? _hourIndex : _hourIndex - 2;
    } catch (_) {
      _savedData = [];

      _isFirstGroup = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: Utils.carouselWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                    await _showClassPicker();
                  },
                  icon: _classesChooserState == ClassesChooserState.fetching
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: CustomColors.grey,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          _classesChooserState == ClassesChooserState.ready
                              ? Icons.edit
                              : Icons.wifi_off,
                          color: CustomColors.grey,
                          size: 20,
                        ),
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

  Future<void> _showClassPicker() async {
    setState(() {
      _classesChooserState = ClassesChooserState.fetching;
    });

    try {
      List<String> _classes = await Utils.getClasses();

      setState(() {
        _classesChooserState = ClassesChooserState.ready;
      });

      List<PickerItem> _pickerData = Utils.encodeClassesForPicker(_classes);

      int _classYear = int.parse(_savedClass[0]);

      String _classSection = _savedClass.substring(1);

      Picker(
        adapter: PickerDataAdapter(
          data: _pickerData,
        ),
        hideHeader: true,
        title: const Text('Seleziona classe'),
        cancelText: 'Annulla',
        confirmText: 'OK',
        selecteds: [
          _classYear - 1,
          _pickerData[_classYear - 1].children!.indexWhere(((element) {
            return element.value == _classSection;
          }))
        ],
        magnification: 1.2,
        onConfirm: (Picker picker, List value) async {
          String newClass =
              picker.getSelectedValues()[0] + picker.getSelectedValues()[1];

          if (newClass != _savedClass) {
            Utils.showUpdatingDialog(context);

            String previousClass = Utils.getSavedClass();

            Utils.setSavedClass(
                picker.getSelectedValues()[0] + picker.getSelectedValues()[1]);

            try {
              String _data = await Utils.getRawData(context);

              if (_data == Utils.empty) {
                setState(() {
                  _classesChooserState = ClassesChooserState.ready;
                });

                Utils.setSavedClass(previousClass);

                Navigator.pop(context);

                Utils.showErrorDialog(context, 1);
              } else {
                setState(() {
                  _classesChooserState = ClassesChooserState.ready;
                  _savedData = Utils.getSavedData();
                  _savedClass = Utils.getSavedClass();
                  _isFirstGroup = Utils.isFirstGroup(_savedData);
                  _hourIndex = Utils.getNextHourIndex(_isFirstGroup);
                });

                Navigator.pop(context);

                if (_hourIndex >= 0) {
                  _carouselController.animateToPage(
                    _isFirstGroup ? _hourIndex : _hourIndex - 2,
                    curve: Curves.elasticOut,
                    duration: const Duration(milliseconds: 2500),
                  );
                }
              }
            } catch (ex) {
              setState(() {
                _classesChooserState = ClassesChooserState.ready;
              });

              Utils.setSavedClass(previousClass);

              Navigator.pop(context);

              Utils.showErrorDialog(context, 0);
            }
          } else {
            setState(() {
              _classesChooserState = ClassesChooserState.ready;
            });
          }
        },
        onCancel: () {
          setState(() {
            _classesChooserState = ClassesChooserState.ready;
          });
        },
      ).showDialog(context);
    } catch (_) {
      setState(
        () {
          _classesChooserState = ClassesChooserState.error;
        },
      );
    }
  }

  Widget _buildCarousel() {
    bool _isCurrentHourCard;
    bool _isNextHourCard;

    if (_hourIndex >= Utils.inSchoolTime) {
      if (_savedData.isNotEmpty) {
        return Column(
          children: [
            CarouselSlider.builder(
              itemBuilder: (context, index, realIndex) {
                _isCurrentHourCard =
                    index + 1 == (_isFirstGroup ? _hourIndex : _hourIndex - 2);

                _isNextHourCard =
                    index == (_isFirstGroup ? _hourIndex : _hourIndex - 2);

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
                    openContainer: openContainer,
                    lessonName: _savedData[index].name,
                    room: _savedData[index].room,
                    startingHour: index >=
                            (_isFirstGroup ? _hourIndex : _hourIndex - 2) - 1
                        ? _savedData[index].hours.startingTime
                        : null,
                    refresh: _isNextHourCard
                        ? () {
                            setState(() {
                              _hourIndex =
                                  Utils.getNextHourIndex(_isFirstGroup);

                              if (_hourIndex >= 0 &&
                                  _hourIndex != _carouselIndex) {
                                _carouselController.animateToPage(
                                  _isFirstGroup ? _hourIndex : _hourIndex - 2,
                                  curve: Curves.elasticOut,
                                  duration: const Duration(seconds: 2),
                                );
                              }

                              _carouselIndex = _hourIndex;
                            });
                          }
                        : null,
                    isCurrentHour: _isCurrentHourCard,
                  ),
                  openColor: CustomColors.black,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  closedColor: CustomColors.black,
                );
              },
              carouselController: _carouselController,
              itemCount: _savedData.length,
              options: CarouselOptions(
                height: Utils.carouselHeight,
                initialPage: _isFirstGroup ? _hourIndex : _hourIndex - 2,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _carouselIndex = index;
                    _isCurrentHourCard =
                        index == (_isFirstGroup ? _hourIndex : _hourIndex - 2);
                    _hourIndex = Utils.getNextHourIndex(_isFirstGroup);
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
                  dotHeight: Utils.dotIndicatorsSize,
                  dotWidth: Utils.dotIndicatorsSize,
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
            height: Utils.carouselHeight,
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
          height: Utils.carouselHeight,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }
}
