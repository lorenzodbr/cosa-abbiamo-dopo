import 'package:clean_settings/clean_settings.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingContainer(
        sections: [
          SettingSection(
            title: 'Dati',
            items: [
              _buildClassesWheel(),
              SettingItem(
                title: 'Ultima ricerca di aggiornamenti',
                displayValue: Utils.getLastFetch(),
                onTap: () {},
              ),
              SettingItem(
                title: 'Ultimo aggiornamento dei dati',
                displayValue: Utils.getLastUpdate(),
                onTap: () {},
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
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassesWheel() {
    return FutureBuilder<List<String>>(
      future: Utils.getClasses(),
      builder: (context, getClassesSnapshot) {
        if (getClassesSnapshot.hasError) {
          return SettingRadioItem<String>(
            title: 'Seleziona classe',
            priority: ItemPriority.disabled,
            items: const [],
            onChanged: (_) {},
            displayValue:
                'Impossibile caricare la lista delle classi. Riprova più tardi',
          );
        }

        if (getClassesSnapshot.hasData) {
          if (getClassesSnapshot.data!.isNotEmpty) {
            String classe = Utils.getSavedClass();

            return SettingWheelPickerItem(
              title: 'Seleziona classe',
              initialValueIndex: getClassesSnapshot.data!.indexOf(classe),
              displayValue: classe,
              items: getClassesSnapshot.data,
              onChanged: (v) async {
                _showMyDialog();

                String previousClass = Utils.getSavedClass();

                Utils.setSavedClass(getClassesSnapshot.data![v]);
                if ((await Utils.getData(context)).isEmpty) {
                  Utils.setSavedClass(previousClass);
                }

                Navigator.pop(context);
                setState(() {});
              },
            );
          } else {
            return SettingWheelPickerItem(
              title: 'Seleziona classe',
              displayValue: 'Connettiti a Internet per cambiare classe',
              items: const [],
              onChanged: (_) {},
              priority: ItemPriority.disabled,
            );
          }
        } else {
          return SettingRadioItem<String>(
            title: 'Seleziona classe',
            items: const [],
            onChanged: (_) {},
            displayValue: 'Caricamento...',
            priority: ItemPriority.disabled,
          );
        }
      },
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
