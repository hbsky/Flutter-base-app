import 'package:base_app/bloc/base_bloc.dart';
import 'package:base_app/popup/show_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class BaseStatefulWidgetState<SF extends StatefulWidget,
    B extends BaseBloc> extends State<SF> {
  bool isShowLoading = false;

  B bloc;

  ShowPopup showPopup;

  BaseBloc initBloc();

  Widget buildWidgets(BuildContext context);

  @override
  void initState() {
    bloc = initBloc();

    // Callback when `onError()` was called
    bloc?.setOnErrorListener(_showErrorPopup);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showPopup = ShowPopup(context);
    return buildWidgets(context);
  }

  // ---------- PRIVATE COMMANDS ---------- \\
  void _setShowLoading(bool isLoad) {
    if (mounted) {
      setState(() {
        isShowLoading = isLoad;
      });
    }
  }

  void _showErrorPopup(Object error, StackTrace stacktrace) {
    _setShowLoading(false);
    showPopup.showNotification(error.toString());
  }
}
