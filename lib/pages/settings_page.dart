import 'package:clean_settings/clean_settings.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int easterEggCounter = 0;
  late bool wasEasterEggUnlocked;

  @override
  void initState() {
    wasEasterEggUnlocked = Utils.wasEasterEggUnlocked();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingContainer(
        sections: [
          SettingSection(
            title: 'Dati',
            items: [
              _buildClassesPicker(),
              SettingItem(
                title: 'Ultimo aggiornamento degli orari',
                displayValue: Utils.getLastUpdate(),
                onTap: () {},
                onLongPress: () {},
              ),
              SettingItem(
                title: 'Ultima ricerca di aggiornamenti degli orari',
                displayValue: Utils.getLastFetch(),
                onTap: () {},
                onLongPress: () {},
              ),
            ],
          ),
          SettingSection(
            title: 'App',
            items: [
              FutureBuilder<String>(
                future: Utils.getAppVersion(),
                builder: (context, getAppVersionSnapshot) {
                  return SettingItem(
                    title: 'Versione',
                    displayValue: getAppVersionSnapshot.hasData
                        ? getAppVersionSnapshot.data
                        : 'Caricamento...',
                    onTap: () {
                      if (!wasEasterEggUnlocked &&
                          easterEggCounter < Utils.easterEggUpperLimit) {
                        easterEggCounter++;

                        int difference =
                            Utils.easterEggUpperLimit - easterEggCounter;

                        if (difference <= Utils.easterEggStartingLimit &&
                            difference > 0) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                difference == 1
                                    ? 'Manca $difference tocco per sbloccare un easter egg'
                                    : 'Mancano $difference tocchi per sbloccare un easter egg',
                              ),
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        }

                        if (difference == 0) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        }
                      }

                      if (easterEggCounter == Utils.easterEggUpperLimit) {
                        if (!wasEasterEggUnlocked) {
                          Utils.unlockEasterEgg();

                          setState(() {
                            wasEasterEggUnlocked = Utils.wasEasterEggUnlocked();
                          });
                        }
                      }
                    },
                    onLongPress: () {},
                  );
                },
              ),
              ...addEasterEgg(),
            ],
          ),
        ],
      ),
    );
  }

  List<SettingItem> addEasterEgg() {
    if (wasEasterEggUnlocked) {
      return [
        SettingItem(
            title: 'Easter Egg',
            displayValue: 'Riscatta il premio',
            onTap: () async {
              String url = Utils.rickRollUrl;

              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            onLongPress: () {
              setState(() {
                Utils.lockEasterEgg();

                setState(() {
                  wasEasterEggUnlocked = Utils.wasEasterEggUnlocked();
                  easterEggCounter = 0;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Easter Egg nascosto',
                    ),
                  ),
                );
              });
            })
      ];
    } else {
      return [];
    }
  }

  Widget _buildClassesPicker() {
    return FutureBuilder<List<String>>(
      future: Utils.getClasses(),
      builder: (context, getClassesSnapshot) {
        if (getClassesSnapshot.hasError) {
          return SettingItem(
            title: 'Seleziona classe',
            displayValue: 'Connettiti a Internet per cambiare classe',
            priority: ItemPriority.disabled,
            onTap: () {},
            onLongPress: () {},
          );
        }

        if (getClassesSnapshot.hasData) {
          if (getClassesSnapshot.data!.isNotEmpty) {
            String _savedClass = Utils.getSavedClass();

            return SettingItem(
                title: 'Seleziona classe',
                displayValue: _savedClass,
                onTap: () => _showClassPicker(getClassesSnapshot.data!),
                onLongPress: () {});
          } else {
            return SettingItem(
              title: 'Seleziona classe',
              priority: ItemPriority.disabled,
              displayValue: 'Impossibile caricare la lista delle classi',
              onTap: () {},
              onLongPress: () {},
            );
          }
        } else {
          return SettingItem(
            title: 'Seleziona classe',
            displayValue: 'Caricamento...',
            priority: ItemPriority.disabled,
            onTap: () {},
            onLongPress: () {},
          );
        }
      },
    );
  }

  Future<void> _showClassPicker(List<String> _classes) async {
    String _savedClass = Utils.getSavedClass();

    List<PickerItem> _pickerData = Utils.buildClassesForPicker(_classes);

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
                Utils.setSavedClass(previousClass);

                Navigator.pop(context);

                Utils.showErrorDialog(context, 1);
              } else {
                setState(() {});

                Navigator.pop(context);
              }
            } catch (ex) {
              Utils.setSavedClass(previousClass);

              Navigator.pop(context);

              Utils.showErrorDialog(context, 0);
            }
          }
        }).showDialog(context);
  }
}
