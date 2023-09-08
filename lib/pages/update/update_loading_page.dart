import 'package:cosa_abbiamo_dopo/globals/custom_colors.dart';
import 'package:cosa_abbiamo_dopo/globals/utils.dart';
import 'package:cosa_abbiamo_dopo/pages/update/update_wrapper.dart';
import 'package:flutter/material.dart';

class UpdateLoadingPage extends StatelessWidget {
  const UpdateLoadingPage(
      {Key? key, required this.refresh, required this.setVersion})
      : super(key: key);

  final Function(UpdateWrapperState) refresh;
  final Function(String) setVersion;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.black,
      child: FutureBuilder<String>(
        future: Utils.isUpdated(),
        builder: (context, isUpdatedSnapshot) {
          if (isUpdatedSnapshot.hasError) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => refresh(UpdateWrapperState.error));

            return Container();
          }

          if (isUpdatedSnapshot.hasData) {
            if (isUpdatedSnapshot.data == Utils.notToBeUpdated) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => refresh(UpdateWrapperState.updated));
              return Container();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setVersion.call(isUpdatedSnapshot.data!);
                refresh(UpdateWrapperState.updating);
              });
              return Container();
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
}
