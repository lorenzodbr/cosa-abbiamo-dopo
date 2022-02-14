import 'dart:io';

import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flowder/flowder.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key, required this.version}) : super(key: key);

  final String version;

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late double _progress;
  late String path = '';

  @override
  void initState() {
    _progress = 0;

    _initDownload();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Aggiornamento disponibile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            widget.version,
            style: const TextStyle(color: CustomColors.grey, fontSize: 18.0),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: CustomColors.darkGrey,
                color: CustomColors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _initDownload() async {
    path = (await _setPath()).path;
    if (!mounted) return;

    var options = DownloaderUtils(
      progressCallback: (current, total) {
        setState(() {
          _progress = (current / total);
        });
      },
      file: File('$path/cosa-abbiamo-dopo-${widget.version}.apk'),
      progress: ProgressImplementation(),
      onDone: () async {
        await _showInstructionDialog();

        OpenFile.open('$path/cosa-abbiamo-dopo-${widget.version}.apk');

        SystemNavigator.pop();
      },
      deleteOnCancel: true,
    );

    Utils.downloadUpdate(options);
  }

  Future<Directory> _setPath() async {
    return await getTemporaryDirectory();
  }

  Future<void> _showInstructionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attenzione'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text(
                  "Se non l'hai già fatto, concedi il permesso per installare l'aggiornamento.",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
