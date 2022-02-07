import 'package:clean_settings/clean_settings.dart';
import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String classe;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Impostazioni",
          style: TextStyle(color: CustomColors.black),
        ),
        backgroundColor: CustomColors.white,
      ),
      body: SettingContainer(sections: [
        SettingSection(
          title: 'Dati',
          items: [
            FutureBuilder<List<String>>(
              future: Utils.getClasses(),
              builder: (context, getClassesSnapshot) {
                if (getClassesSnapshot.hasError) {
                  return SettingRadioItem<String>(
                    title: 'Seleziona classe',
                    priority: ItemPriority.disabled,
                    items: const [],
                    onChanged: (_) {},
                    displayValue:
                        'Connettiti a internet per poter cambiare classe',
                  );
                }

                if (getClassesSnapshot.hasData) {
                  return FutureBuilder<String>(
                    future: Utils.getSavedClass(),
                    builder: (context, getSavedClassSnapshot) {
                      if (getSavedClassSnapshot.hasData) {
                        return SettingWheelPickerItem(
                          title: 'Seleziona classe',
                          initialValueIndex: getClassesSnapshot.data!
                              .indexOf(getSavedClassSnapshot.data!),
                          displayValue: getSavedClassSnapshot.data!,
                          items: getClassesSnapshot.data,
                          onChanged: (v) {
                            _showMyDialog();

                            Utils.setSavedClass(getClassesSnapshot.data![v]);
                            Utils.getData(context);

                            Navigator.pop(context);
                            setState(() {});
                          },
                        );
                      } else {
                        return SettingRadioItem<String>(
                          priority: ItemPriority.disabled,
                          title: 'Seleziona classe',
                          items: const [],
                          onChanged: (_) {},
                          displayValue: 'Caricamento...',
                        );
                      }
                    },
                  );
                } else {
                  return SettingRadioItem<String>(
                    title: 'Seleziona classe',
                    priority: ItemPriority.disabled,
                    items: const [],
                    onChanged: (_) {},
                    displayValue: 'Caricamento...',
                  );
                }
              },
            ),
            FutureBuilder<String>(
              future: Utils.getLastFetch(),
              builder: (context, getLastUpdateSnapshot) {
                return SettingItem(
                  title: 'Ultima ricerca di aggiornamenti',
                  displayValue: getLastUpdateSnapshot.hasData
                      ? getLastUpdateSnapshot.data != ''
                          ? getLastUpdateSnapshot.data
                          : "-"
                      : "Caricamento...",
                  onTap: () {},
                );
              },
            ),
            FutureBuilder<String>(
              future: Utils.getLastUpdate(),
              builder: (context, getLastFetchSnapshot) {
                return SettingItem(
                  title: 'Ultimo aggiornamento',
                  displayValue: getLastFetchSnapshot.hasData
                      ? getLastFetchSnapshot.data != ''
                          ? getLastFetchSnapshot.data
                          : "-"
                      : "Caricamento...",
                  onTap: () {},
                );
              },
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
                      : "Caricamento...",
                  onTap: () {},
                  priority: getAppVersionSnapshot.hasData
                      ? ItemPriority.normal
                      : ItemPriority.disabled,
                );
              },
            ),
          ],
        ),
        // SettingSection(
        //   title: 'Aspetto',
        //   items: [
        //     SettingCheckboxItem(
        //       title: 'Inverti colori',
        //       value: false,
        //       onChanged: (v) => setState(() {}),
        //       description: 'Seleziona il colore dell\'app',
        //     ),
        //   ],
        // ),
      ]),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Aggiornamento dati'),
                    CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
