import 'package:clean_settings/clean_settings.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String classe;

  List<String> classi = [
    "1AI",
    "1BI",
    "1CI",
    "1DI",
    "1EI",
    "1FL",
    "1GL",
    "1HL",
    "1IL",
    "1LE",
    "1ME",
    "1NE",
    "1OE",
    "1PE",
    "1QL",
    "1RI",
    "1SE",
    "2AI",
    "2BI",
    "2CI",
    "2DI",
    "2EI",
    "2FL",
    "2GL",
    "2HL",
    "2IL",
    "2LE",
    "2ME",
    "2NE",
    "2OE",
    "2PE",
    "3AC",
    "3AE",
    "3AI",
    "3AL",
    "3AT",
    "3AT1",
    "3BE",
    "3BI",
    "3BL",
    "3CI",
    "3DI",
    "3EI",
    "3FI",
    "3GI",
    "4AC",
    "4AE",
    "4AI",
    "4AL",
    "4AT",
    "4AT1",
    "4BE",
    "4BI",
    "4BL",
    "4CI",
    "4DI",
    "4EI",
    "5AC",
    "5AE",
    "5AI",
    "5AL",
    "5AT",
    "5AT1",
    "5BI",
    "5BL",
    "5CI",
    "5DI",
    "5EI"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingContainer(sections: [
        SettingSection(
          title: 'Dati',
          items: [
            FutureBuilder<String>(
              future: Utils.getSavedClass(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SettingWheelPickerItem(
                    title: 'Seleziona classe',
                    //priority: ItemPriority.disabled,
                    initialValueIndex: classi.indexOf(snapshot.data!),
                    displayValue:
                        snapshot.data != '' ? snapshot.data : 'Caricamento...',
                    items: classi,
                    onChanged: (v) {
                      _showMyDialog();
                      Utils.setSavedClass(classi[v]);
                      Utils.getData();
                      Navigator.pop(context);
                      setState(() {});
                    },
                  );
                } else {
                  return SettingRadioItem<String>(
                    title: 'Seleziona classe',
                    items: const [],
                    onChanged: (_) {},
                    displayValue: 'Caricamento...',
                  );
                }
              },
            ),
          ],
        ),
        SettingSection(
          title: 'Aspetto',
          items: [
            SettingCheckboxItem(
                title: 'Inverti colori',
                value: false,
                onChanged: (v) => setState(() {}),
                description: 'Cambia la veste grafica invertendo i colori'),
          ],
        ),
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
