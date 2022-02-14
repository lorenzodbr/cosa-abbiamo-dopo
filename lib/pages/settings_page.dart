import 'package:clean_settings/clean_settings.dart';
import 'package:cosa_abbiamo_dopo/globals/marconi_lesson.dart';
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
                title: 'Ultimo aggiornamento degli orari',
                displayValue: Utils.getLastUpdate(),
                onTap: () {},
              ),
              SettingItem(
                title: 'Ultima ricerca di aggiornamenti degli orari',
                displayValue: Utils.getLastFetch(),
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
                        : 'Caricamento...',
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
            displayValue: 'Impossibile caricare la lista delle classi',
          );
        }

        if (getClassesSnapshot.hasData) {
          if (getClassesSnapshot.data!.isNotEmpty) {
            String _savedClass = Utils.getSavedClass();

            return SettingWheelPickerItem(
              title: 'Seleziona classe',
              initialValueIndex: getClassesSnapshot.data!.indexOf(_savedClass),
              displayValue: _savedClass,
              items: getClassesSnapshot.data,
              onChanged: (v) async {
                Utils.showUpdatingDialog(context);

                String previousClass = Utils.getSavedClass();

                Utils.setSavedClass(getClassesSnapshot.data![v]);

                try {
                  String data = await Utils.getRawData(context);

                  if (data == '') {
                    Utils.setSavedClass(previousClass);

                    Navigator.pop(context);

                    setState(() {});

                    Utils.showErrorDialog(context, 1);
                  } else {
                    Navigator.pop(context);

                    setState(() {});
                  }
                } catch (ex) {
                  Utils.setSavedClass(previousClass);

                  Navigator.pop(context);

                  setState(() {});

                  Utils.showErrorDialog(context, 0);
                }
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
}
