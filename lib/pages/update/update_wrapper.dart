import 'package:cosa_abbiamo_dopo/pages/update/update_error_page.dart';
import 'package:cosa_abbiamo_dopo/pages/update/update_loading_page.dart';
import 'package:cosa_abbiamo_dopo/pages/update/update_updating_page.dart';
import 'package:flutter/material.dart';

enum UpdateWrapperState { loading, updating, error, updated }

class UpdateWrapper extends StatefulWidget {
  const UpdateWrapper({Key? key, required this.refresh}) : super(key: key);

  final VoidCallback refresh;
  static String version = '0';

  @override
  _UpdateWrapperState createState() => _UpdateWrapperState();
}

class _UpdateWrapperState extends State<UpdateWrapper> {
  late UpdateWrapperState _state;

  @override
  void initState() {
    _state = UpdateWrapperState.loading;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case UpdateWrapperState.updated:
        WidgetsBinding.instance!
            .addPostFrameCallback((_) => widget.refresh.call());
        return Container();
      case UpdateWrapperState.updating:
        return const UpdateUpdatingPage();
      case UpdateWrapperState.loading:
        return UpdateLoadingPage(
          refresh: (state) => setWrapperState(state),
          setVersion: (version) {
            UpdateWrapper.version = version;
          },
        );
      case UpdateWrapperState.error:
        return UpdateErrorPage(refresh: widget.refresh);
    }
  }

  void setWrapperState(UpdateWrapperState state) {
    setState(() {
      _state = state;
    });
  }
}
