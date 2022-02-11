import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/item_model.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      header: "Come è nata quest'app?",
      body:
          "Chiunque, almeno una volta nella propria vita scolastica al Marconi, si è posto o ha posto a qualcuno questa domanda.\nQuest'app, realizzata specificatamente per il nostro istituto, giunge in supporto a coloro che vogliono avere una risposta a questa domanda in modo semplice e veloce.",
    ),
    ItemModel(
      header: "Come funziona quest'app?",
      body:
          "Il funzionamento è rapido e intuitivo: basta aprire l'app, verranno ricercati automaticamente aggiornamenti per gli orari e verranno mostrati senza che l'utente debba fare qualcosa.",
    ),
    ItemModel(
      header:
          "Devo avere una connessione a Internet attiva per utilizzare l'app?",
      body:
          "La connessione è richiesta solo al primo avvio. I dati verranno salvati in cache, quindi anche se successivamente non è disponibile una connessione a Internet gli orari (seppur non aggiornati) verranno mostrati lo stesso.",
    ),
    ItemModel(
      header: "Chi è il creatore di quest'app?",
      body:
          "Il creatore di quest'app è Lorenzo Di Berardino. Puoi contattarlo con il pulsante qui sotto.",
      button: ElevatedButton(
        child: const Text("Contattami"),
        onPressed: () async {
          String url = "https://t.me/lorenzodiberardino";

          if (await canLaunch(url)) await launch(url);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
      ),
    ),
    ItemModel(
      header: "È disponibile il codice sorgente?",
      body:
          "Certo, l'intero progetto è Open Source e disponibile su Github. Puoi accedere al codice con il pulsante qui sotto.",
      button: ElevatedButton(
        child: const Text("Progetto su Github"),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20, left: 7),
              child: Text(
                "Informazioni",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
              ),
            ),
            ExpansionPanelList(
              children: _getExpansionPanels(),
              expansionCallback: (panelIndex, isExpanded) {
                itemData[panelIndex].expanded = !isExpanded;
                setState(() {});
              },
              expandedHeaderPadding: const EdgeInsets.all(5),
            ),
          ],
        ),
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
                item.header,
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
    List<Widget> widgets = [
      ListTile(
        title: Text(
          item.body,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 14.0),
        ),
      )
    ];

    if (item.button != null) {
      widgets.add(
        SizedBox(
          width: 300,
          child: item.button!,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: widgets,
      ),
    );
  }
}
