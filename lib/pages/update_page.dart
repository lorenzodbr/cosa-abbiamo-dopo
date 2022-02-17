import 'dart:io';

import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/tab_view.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({Key? key, required this.refresh}) : super(key: key);

  final VoidCallback refresh;

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  double _progress = 0;
  late String? _version;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.black,
      child: FutureBuilder<String>(
        future: Utils.isUpdated(),
        builder: (context, isUpdatedSnapshot) {
          if (isUpdatedSnapshot.hasError) {
            return _buildErrorWidget();
          }

          if (isUpdatedSnapshot.hasData) {
            if (isUpdatedSnapshot.data == Utils.notToBeUpdated) {
              return const TabView();
            } else {
              _version = isUpdatedSnapshot.data!;
              return _buildUpdateWidget();
            }
          } else {
            return Material(
              color: CustomColors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 30),
                    child: Text(
                      "Ricerca aggiornamenti",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUpdateWidget() {
    _initDownload();

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
          _version!,
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
          onPressed: widget.refresh,
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
    Directory cacheDir = (await Utils.getCachePath());

    String path = cacheDir.path;

    if (!mounted) return;

    await Utils.deleteCachedApk();

    var options = DownloaderUtils(
      progressCallback: (current, total) {
        setState(() {
          _progress = (current / total);
        });
      },
      file: File('$path/${Utils.apkFileName}'),
      progress: ProgressImplementation(),
      onDone: () async {
        bool permission = await Permission.requestInstallPackages.isGranted;

        if (!permission) {
          await _showInstructionDialog();
        }

        OpenFile.open('$path/${Utils.apkFileName}');

        SystemNavigator.pop();
      },
      deleteOnCancel: true,
    );

    Utils.downloadUpdate(options, _version);
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
