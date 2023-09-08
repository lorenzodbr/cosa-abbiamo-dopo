import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:settings_ui/settings_ui.dart';
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
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: Colors.white,
          title: const Text(
            "Impostazioni",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        body: SettingsList(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          platform: DevicePlatform.android,
          lightTheme: const SettingsThemeData(
            settingsListBackground: CustomColors.white,
            leadingIconsColor: CustomColors.grey,
          ),
          sections: [
            SettingsSection(
              title: _buildTitleText('Dati'),
              tiles: [
                CustomSettingsTile(
                  child: _buildClassesPicker(),
                ),
                SettingsTile(
                  leading: const Icon(Icons.search),
                  title: _buildHeaderText(
                    'Ultima ricerca di aggiornamenti degli orari',
                  ),
                  value: _buildValueText(
                    Utils.getLastFetch(),
                  ),
                  onPressed: (_) {},
                ),
                SettingsTile(
                  leading: const Icon(Icons.download_outlined),
                  title: _buildHeaderText(
                    'Ultimo aggiornamento degli orari',
                  ),
                  value: _buildValueText(
                    Utils.getLastUpdate(),
                  ),
                  onPressed: (_) {},
                ),
              ],
            ),
            SettingsSection(
              title: _buildTitleText('App'),
              tiles: [
                CustomSettingsTile(
                  child: FutureBuilder<String>(
                    future: Utils.getAppVersion(),
                    builder: (context, getAppVersionSnapshot) {
                      return SettingsTile(
                        leading: const Icon(Icons.info_outline),
                        title: _buildHeaderText('Versione'),
                        value: _buildValueText(
                          getAppVersionSnapshot.hasData
                              ? getAppVersionSnapshot.data!
                              : 'Caricamento...',
                        ),
                        onPressed: (_) {
                          if (wasEasterEggUnlocked) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                          }

                          if (!wasEasterEggUnlocked &&
                              easterEggCounter < Utils.easterEggUpperLimit) {
                            easterEggCounter++;

                            int difference =
                                Utils.easterEggUpperLimit - easterEggCounter;

                            if (difference <= Utils.easterEggStartingLimit &&
                                difference > 0) {
                              ScaffoldMessenger.of(context).clearSnackBars();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    difference == 1
                                        ? 'Ancora $difference tocco per sbloccare l\'Easter Egg'
                                        : 'Ancora $difference tocchi per sbloccare l\'Easter Egg',
                                    style: GoogleFonts.workSans(),
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                ),
                              );
                            }

                            if (difference == 0) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                            }
                          }

                          if (easterEggCounter == Utils.easterEggUpperLimit) {
                            if (!wasEasterEggUnlocked) {
                              Utils.unlockEasterEgg();

                              setState(() {
                                wasEasterEggUnlocked =
                                    Utils.wasEasterEggUnlocked();
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
                ...addEasterEgg(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<CustomSettingsTile> addEasterEgg() {
    if (wasEasterEggUnlocked) {
      return [
        CustomSettingsTile(
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                Utils.lockEasterEgg();

                setState(() {
                  wasEasterEggUnlocked = Utils.wasEasterEggUnlocked();
                  easterEggCounter = 0;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Easter Egg nascosto',
                      style: GoogleFonts.workSans(),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              });
            },
            child: SettingsTile(
              leading: const Icon(Icons.card_giftcard),
              title: _buildHeaderText('Easter Egg'),
              value: _buildValueText('Riscatta il premio'),
              onPressed: (_) async {
                String url = Utils.rickRollUrl;
                Uri uri = Uri.parse(url);

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            ),
          ),
        )
      ];
    } else {
      return [];
    }
  }

  Text _buildTitleText(String text) {
    return Text(text, style: GoogleFonts.workSans(color: CustomColors.black));
  }

  Text _buildHeaderText(String text) {
    return Text(text,
        style: GoogleFonts.workSans(
            color: CustomColors.almostBlack, fontSize: 16));
  }

  Text _buildValueText(String text) {
    return Text(text,
        style:
            GoogleFonts.workSans(color: CustomColors.darkGrey, fontSize: 14));
  }

  Widget _buildClassesPicker() {
    return FutureBuilder<List<String>>(
      future: Utils.getClasses(),
      builder: (context, getClassesSnapshot) {
        if (getClassesSnapshot.hasError) {
          return SettingsTile(
            leading: const Icon(Icons.wifi_off),
            title: _buildHeaderText('Seleziona classe'),
            value: _buildValueText(
              'Connettiti a Internet per cambiare classe',
            ),
            enabled: false,
          );
        }

        if (getClassesSnapshot.hasData) {
          if (getClassesSnapshot.data!.isNotEmpty) {
            String _savedClass = Utils.getSavedClass();

            return SettingsTile(
              leading: const Icon(
                Icons.school_outlined,
              ),
              title: _buildHeaderText('Seleziona classe'),
              value: _buildValueText(_savedClass),
              onPressed: (_) => _showClassPicker(getClassesSnapshot.data!),
            );
          } else {
            return SettingsTile(
              leading: const Icon(Icons.error),
              title: _buildHeaderText('Seleziona classe'),
              enabled: false,
              value: Text('Impossibile caricare la lista delle classi',
                  style: GoogleFonts.workSans()),
            );
          }
        } else {
          return SettingsTile(
            leading: const Icon(Icons.school_outlined),
            title: _buildHeaderText('Seleziona classe'),
            value: _buildValueText('Caricamento...'),
            enabled: false,
          );
        }
      },
    );
  }

  Future<void> _showClassPicker(List<String> _classes) async {
    String _savedClass = Utils.getSavedClass();

    List<PickerItem> _pickerData = Utils.encodeClassesForPicker(_classes);

    int _classYear = int.parse(_savedClass[0]);

    String _classSection = _savedClass.substring(1);

    Picker(
      adapter: PickerDataAdapter(
        data: _pickerData,
      ),
      magnification: 1.2,
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
      },
    ).showDialog(context);
  }
}
