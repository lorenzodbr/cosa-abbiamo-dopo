import 'dart:io';

import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flowder/flowder.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage(
      {Key? key,
      required this.version,
      required this.hasError,
      this.skipUpdate})
      : super(key: key);

  final String version;
  final bool hasError;
  final VoidCallback? skipUpdate;

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late double _progress;
  late String _path;

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
      child: widget.hasError ? _buildErrorWidget() : _buildUpdateWidget(),
    );
  }

  Widget _buildUpdateWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 7),
          child: Text(
            "Aggiornamento",
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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: CustomColors.darkGrey,
              color: CustomColors.white),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      children: [
        const Spacer(
          flex: 5,
        ),
        const Icon(
          Icons.wifi_off,
          size: 80,
          color: CustomColors.grey,
        ),
        const Text(
          "Nessuna connessione a internet.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const Spacer(
          flex: 2,
        ),
        OutlinedButton(
          onPressed: () {
            widget.skipUpdate;
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: CustomColors.darkGrey),
            primary: CustomColors.white,
          ),
          child: const Text(
            "Mostra dati salvati",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }

  Future<void> _initDownload() async {
    Directory cacheDir = (await _setPath());

    String path = cacheDir.path;

    if (!mounted) return;

    await Utils.deleteCacheDir(cacheDir);

    var options = DownloaderUtils(
      progressCallback: (current, total) {
        setState(() {
          _progress = (current / total);
        });
      },
      file: File('$path/cosa-abbiamo-dopo-${widget.version}.apk'),
      progress: ProgressImplementation(),
      onDone: () async {
        if (!(await Permission.requestInstallPackages.isGranted)) {
          await _showInstructionDialog();
        }

        OpenFile.open('$path/cosa-abbiamo-dopo-${widget.version}.apk');

        SystemNavigator.pop();
      },
      deleteOnCancel: true,
    );

    Utils.downloadUpdate(options, widget.version);
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
          backgroundColor: CustomColors.darkGrey,
          title: const Text('Attenzione'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text(
                  "Concedi il permesso per installare l'aggiornamento.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
