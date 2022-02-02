import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "\"Cosa abbiamo dopo?\"",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Chiunque, almeno una volta nella propria vita scolastica al Marconi, si è posto o ha posto a qualcuno questa domanda.\n\nQuest'app, realizzata specificatamente per il nostro istituto, giunge in supporto a coloro che vogliono avere una risposta a questa domanda in modo semplice e veloce.\n\nÈ richiesta una connessione ad internet solo per scaricare i gli orari (all'avvio). L'aggiornamento degli stessi avviene, dunque, in maniera totalmente automatica in base a quanto pubblicato dall'istituto.",
            style: TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.justify,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
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
