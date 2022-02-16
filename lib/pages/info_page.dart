import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/custom_icons_icons.dart';
import 'package:cosa_abbiamo_dopo/globals/item_model.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      header: "Chi è il creatore di quest'app?",
      body: [
        "Quest'app è stata realizzata da\nLorenzo Di Berardino.",
        "Puoi contattarlo con i pulsanti qui sotto."
      ],
      button: [
        ElevatedButton.icon(
          icon: const Icon(CustomIcons.telegramPlane),
          label: const Text("Telegram"),
          onPressed: () async {
            String url = Utils.telegramUrl;

            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.email),
          label: const Text("Email"),
          onPressed: () async {
            String url = Utils.emailUrl;

            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
        ),
      ],
    ),
    ItemModel(
      header: "Come è nata l'idea per quest'app?",
      body: [
        "Be', chiunque, almeno una volta nella propria vita scolastica, si è posto o ha posto a qualcuno la domanda nella Homepage.",
        "Quest'app, realizzata specificatamente per il nostro istituto (ITI G. Marconi), giunge in supporto a coloro che vogliono avere una risposta a quella domanda in modo semplice e veloce."
      ],
    ),
    ItemModel(
      header: "Come funziona quest'app?",
      body: [
        "Il suo funzionamento è rapido e intuitivo: basta aprirla. Verranno ricercati automaticamente aggiornamenti per gli orari, in base a quanto pubblicato dalla scuola, e verranno mostrati con una grafica semplice e minimale."
      ],
    ),
    ItemModel(
      header:
          "È richiesta una connessione a Internet attiva per utilizzare l'app?",
      body: [
        "L'app controlla la presenza di aggiornamenti all'avvio per mantenere sempre un'esperienza ottimale. Nel caso non fosse disponibile una connessione, sarà possibile mostrare i dati salvati precedentemente.",
      ],
    ),
    ItemModel(
      header: "Dove posso trovare il codice sorgente?",
      body: [
        "L'intero progetto è Open Source ed è disponibile su Github.",
        "Puoi accedervi con il pulsante qui sotto."
      ],
      button: [
        ElevatedButton.icon(
          icon: const Icon(CustomIcons.github),
          label: const Text("Progetto"),
          onPressed: () async {
            String url = Utils.baseProjectUrl;

            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
        ),
      ],
    ),
    ItemModel(
      isPlaformDependent: true,
      headers: [
        "Quest'app è disponibile su un'altra piattaforma?",
        "Questa WebApp è disponibile su un'altra piattaforma?"
      ],
      body: [
        "È disponibile anche una WebApp. Puoi accedervi con il pulsante qui sotto.",
        "È disponibile anche un'app per Android. Puoi scaricarla con il pulsante qui sotto."
      ],
      button: [
        ElevatedButton.icon(
          icon: const Icon(Icons.open_in_browser),
          label: const Text("WebApp"),
          onPressed: () async {
            String url = Utils.baseWebAppUrl;

            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.open_in_browser),
          label: const Text("App"),
          onPressed: () async {
            String url = Utils.baseProjectDownloadUrl;

            if (await canLaunch(url)) {
              await launch(url);
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
        ),
      ],
    ),
    ItemModel(
      header: "Quest'app contiene un virus?",
      body: [
        "No, fa solo quello per cui è stata pensata. Niente malware, trojan, ransomware o miner di Bitcoin.",
        "Ma se vuoi controllare personalmente, puoi aprire la pagina del progetto e navigare nel codice."
      ],
    ),
    ItemModel(
      header: "Posso segnalare un problema?",
      body: [
        "Certamente, cercherò di risolverlo nel minor tempo possibile rilasciando un aggiornamento.",
        "Contattami con i pulsanti nella prima sezione."
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.white,
        body: ListView(padding: const EdgeInsets.all(10), children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 7),
                child: Text(
                  "Informazioni",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              ExpansionPanelList(
                children: _getExpansionPanels(),
                expansionCallback: (panelIndex, isExpanded) {
                  itemData[panelIndex].expanded = !isExpanded;
                  setState(() {});
                },
                expandedHeaderPadding: const EdgeInsets.all(0),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  List<ExpansionPanel> _getExpansionPanels() {
    return itemData.map<ExpansionPanel>((ItemModel item) {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(
                item.isPlaformDependent
                    ? item.headers[kIsWeb ? 1 : 0]
                    : item.header,
                style: TextStyle(
                    fontWeight:
                        isExpanded ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          );
        },
        body: _buildExpansionBody(item),
        isExpanded: item.expanded,
        canTapOnHeader: true,
      );
    }).toList();
  }

  Widget _buildExpansionBody(ItemModel item) {
    List<Widget> body = [];

    if (item.isPlaformDependent) {
      body.add(
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
          child: Text(
            item.body[kIsWeb ? 1 : 0],
            textAlign: TextAlign.justify,
          ),
        ),
      );
    } else {
      for (String bodyLine in item.body) {
        body.add(
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: Text(
              bodyLine,
              textAlign: TextAlign.justify,
            ),
          ),
        );
      }
    }

    List<Widget> widgets = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: body,
        ),
      ),
    ];

    if (item.button != null) {
      List<Widget> buttons = [];

      if (item.isPlaformDependent) {
        buttons.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: item.button![kIsWeb ? 1 : 0],
            ),
          ),
        );
      } else {
        for (ElevatedButton button in item.button!) {
          buttons.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: button,
              ),
            ),
          );
        }
      }

      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buttons,
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: widgets,
      ),
    );
  }
}
