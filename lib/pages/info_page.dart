import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            "\"Cosa abbiamo dopo?\" Chiunque, almeno una volta nella propria vita scolastica al Marconi, si è posto o ha posto questa domanda a qualcuno. Quest'app, realizzata specificatamente per il nostro istituto, giunge in supporto a coloro che vogliono avere una risposta a questa domanda in modo veloce e semplice. È richiesta una connessione ad internet solo per scaricare i gli orari (al primo avvio), mentre è possibile aggiornarli manualmente, in un secondo momento, trascinando verso il basso nella homepage oppure tramite apposito pulsante nelle impostazioni.")
      ],
    );
  }
}
