import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Informazioni",
          style: TextStyle(color: CustomColors.black),
        ),
        backgroundColor: CustomColors.white,
      ),
      body: Column(
        children: [
          ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Come è nata quest'app?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            collapsed: Container(),
            expanded: const Text(
              "Chiunque, almeno una volta nella propria vita scolastica al Marconi, si è posto o ha posto a qualcuno questa domanda.\nQuest'app, realizzata specificatamente per il nostro istituto, giunge in supporto a coloro che vogliono avere una risposta a questa domanda in modo semplice e veloce.",
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              );
            },
          ),
          Divider(),
          ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Come funziona quest'app?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            collapsed: Container(),
            expanded: const Text(
              "Il funzionamento è rapido e intuitivo: basta aprire l'app, verranno ricercati automaticamente aggiornamenti per gli orari e verranno mostrati senza che l'utente debba fare qualcosa",
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              );
            },
          ),
          ExpandablePanel(
            theme: const ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              tapBodyToCollapse: true,
            ),
            header: const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Devo avere una connessione a Internet attiva per utilizzare l'app?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            collapsed: Container(),
            expanded: const Text(
              "La connessione è richiesta solo al primo avvio. I dati verranno salvati in cache, quindi anche se successivamente non è disponibile una connessione a Internet gli orari (seppur non aggiornati) verranno mostrati lo stesso",
              softWrap: true,
              textAlign: TextAlign.justify,
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(
                    crossFadePoint: 0,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Contattami"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Codice sorgente"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
