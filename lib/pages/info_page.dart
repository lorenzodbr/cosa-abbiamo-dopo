import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/custom_icons_icons.dart';
import 'package:cosa_abbiamo_dopo/globals/item_model.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final List<ItemModel> _sections = <ItemModel>[
    ItemModel(
      leading: const Icon(Icons.person_outline),
      header: "Chi è il creatore di quest'applicazione?",
      body: [
        "Quest'applicazione è stata realizzata da Lorenzo Di Berardino.",
        "Puoi contattarlo con i pulsanti qui sotto."
      ],
      button: [
        ElevatedButton.icon(
          icon: const Icon(CustomIcons.telegramPlane),
          label: const Text("Telegram"),
          onPressed: () async {
            String url = Utils.telegramUrl;
            Uri uri = Uri.parse(url);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.email),
          label: const Text("Email"),
          onPressed: () async {
            String url = Utils.emailUrl;
            Uri uri = Uri.parse(url);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
      ],
    ),
    ItemModel(
      leading: const Icon(Icons.lightbulb_outline),
      header: "Come è nata l'idea per quest'applicazione?",
      body: [
        "Almeno una volta durante la propria carriera scolastica, chiunque si è posto o ha rivolto a qualcuno la domanda che dà il titolo a questa applicazione.",
        "Sviluppata appositamente per l'ITI G. Marconi, quest'applicazione offre un valido supporto a coloro che desiderano ottenere una risposta a quella domanda in modo rapido e intuitivo."
      ],
    ),
    ItemModel(
      leading: const Icon(MdiIcons.wrenchOutline),
      header: "Come funziona quest'applicazione?",
      body: [
        "La procedura è semplice: all'apertura, l'applicazione effettuerà automaticamente una ricerca degli aggiornamenti sugli orari, basandosi sulle informazioni pubblicate dalla scuola, e li presenterà con un'interfaccia grafica essenziale e minimalista."
      ],
    ),
    ItemModel(
      leading: const Icon(Icons.wifi_outlined),
      header:
          "È richiesta una connessione a Internet attiva per utilizzare l'applicazione?",
      body: [
        "Al fine di garantire un'esperienza sempre ottimale, l'applicazione verifica la disponibilità di aggiornamenti ad ogni avvio, connettendosi a Internet.",
        "Se non fosse disponibile una connessione, l'applicazione permetterà di visualizzare (eventuali) orari memorizzati precedentemente, che potrebbero però non essere aggiornati.",
      ],
    ),
    ItemModel(
      leading: const Icon(
        Icons.code_outlined,
      ),
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
            Uri uri = Uri.parse(url);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
      ],
    ),
    ItemModel(
      leadings: const [
        Icon(Icons.computer_outlined),
        Icon(Icons.phone_android_outlined),
      ],
      isPlaformDependent: true,
      headers: [
        "Quest'applicazione è disponibile su un'altra piattaforma?",
        "Questa WebApp è disponibile su un'altra piattaforma?"
      ],
      body: [
        "È disponibile anche una WebApp. Puoi accedervi con il pulsante qui sotto.",
        "È disponibile anche un'applicazione per Android, per un'esperienza più fluida. Puoi scaricarla con il pulsante qui sotto."
      ],
      button: [
        ElevatedButton.icon(
          icon: const Icon(Icons.open_in_browser),
          label: const Text("WebApp"),
          onPressed: () async {
            String url = Utils.baseWebAppUrl;
            Uri uri = Uri.parse(url);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.download),
          label: const Text("App"),
          onPressed: () async {
            String url = Utils.baseProjectDownloadUrl + '/latest';
            Uri uri = Uri.parse(url);

            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
        ),
      ],
    ),
    ItemModel(
      leading: const Icon(MdiIcons.virusOffOutline),
      header: "Quest'applicazione contiene un virus?",
      body: [
        "No, fa solo quello per cui è stata pensata. Niente malware, trojan, ransomware o miner di Bitcoin.",
        "Ma se vuoi controllare personalmente, puoi aprire la pagina del progetto e navigare nel codice."
      ],
    ),
    ItemModel(
      leading: const Icon(Icons.bug_report_outlined),
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
        appBar: AppBar(
          elevation: 2,
          shadowColor: Colors.white,
          title: const Text(
            "Informazioni",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[200],
        ),
        backgroundColor: CustomColors.white,
        body: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.all(10),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 810),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionPanelList(
                      dividerColor: CustomColors.white,
                      children: _getExpansionPanels(),
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _sections[panelIndex].expanded = !isExpanded;
                        });
                      },
                      expandedHeaderPadding: const EdgeInsets.all(0),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: Text(
                              'Lorenzo Di Berardino\nITI G. Marconi, Verona\n\nDistribuzione sotto Licenza MIT',
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 30,
                          ),
                          child: Image.asset(
                            'assets/logo/marconi.png',
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ExpansionPanel> _getExpansionPanels() {
    return _sections.map<ExpansionPanel>((ItemModel item) {
      return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: ListTile(
              leading: item.isPlaformDependent
                  ? item.leadings![kIsWeb ? 1 : 0]
                  : item.leading,
              title: Text(
                item.isPlaformDependent
                    ? item.headers![kIsWeb ? 1 : 0]
                    : item.header!,
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
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }
}
