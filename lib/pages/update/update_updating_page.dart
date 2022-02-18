import 'dart:io';

import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/update/update_wrapper.dart';
import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateUpdatingPage extends StatefulWidget {
  const UpdateUpdatingPage({Key? key}) : super(key: key);

  @override
  _UpdateUpdatingPageState createState() => _UpdateUpdatingPageState();
}

class _UpdateUpdatingPageState extends State<UpdateUpdatingPage> {
  double? _progress;

  @override
  void initState() {
    initDownload();

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
            UpdateWrapper.version,
            style: const TextStyle(color: CustomColors.grey, fontSize: 18.0),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: CustomColors.darkGrey,
              color: CustomColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initDownload() async {
    Directory cacheDir = (await Utils.getCachePath());

    String path = cacheDir.path;

    if (!mounted) return;

    await Utils.deleteCachedApk();

    var options = DownloaderUtils(
      progressCallback: (current, total) {
        setState(() {
          _progress = current / total;
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

    Utils.downloadUpdate(options, UpdateWrapper.version);
  }

  Future<void> _showInstructionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.almostBlack,
          title: const Text(
            'Attenzione',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
