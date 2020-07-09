import 'package:base_app/const/dimens.dart';
import 'package:base_app/const/string_value.dart';
import 'package:base_app/widget/base_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// ShowPopup is Singleton class
///
/// It will help you show a dialog in a easy way
class ShowPopup extends BaseShowPopup {
  factory ShowPopup(BuildContext context) {
    _instance.context = context;
    return _instance;
  }

  static final _instance = ShowPopup._internal();

  ShowPopup._internal();

  // ---------- PRIVATE COMMANDS ---------- \\
  Widget _buildDialogLoadingWave() {
    return Center(
      child: wBuildLoading(),
    );
  }

  Widget _buildDialogTitle() {
    return Text(
      sNotify,
      style: TextStyle(fontSize: fontBiggest),
    );
  }

  Widget _buildDialogContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: fontSizeMedium),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDialogClose() {
    return Text(
      sClose,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  // ---------- COMMANDS ---------- \\
  /// Show notification with default widgets
  void showNotification(String content,
      {bool isActiveBack = true,
      Function function,
      bool isChangeContext = false}) {
    showDialogNotification(_buildDialogTitle(), _buildDialogContent(content),
        _buildDialogClose(), content,
        isActiveBack: isActiveBack,
        function: function,
        isChangeContext: isChangeContext);
  }

  @override
  void showLoadingWave({bool isActiveBack = true}) {
    _showDialog(_buildDialogLoadingWave(), isActiveBack);
  }

  @override
  void showDialogNotification(Widget titleWidget, Widget contentWidget,
      Widget closeWidget, String content,
      {bool isActiveBack = true,
      Function function,
      bool isChangeContext = false}) {
    _showDialog(
        Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Icon(
                    _buildIconDialog(content),
                    size: sizeSmallIcon,
                    color: Colors.blueAccent,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 15.0,
                  ),
                  child: titleWidget,
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: contentWidget,
                ),
                Divider(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: () {
                      _dismissDialog(isAutoCloseDialog: isChangeContext);
                      if (function != null) {
                        function();
                      }
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: closeWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
        isActiveBack);
  }
}

/// Extends this class if you need to override show popup functions
abstract class BaseShowPopup {
  /// required
  BuildContext context;

  int numberOfDialogs = 0;

  /// Show dialog with default loading widget
  ///
  /// `isActiveBack` default value is `true`, just work on Android, if `true` user can click back to dismiss dialog
  void showLoadingWave({bool isActiveBack = true});

  /// Show dialog with default view
  ///
  /// `titleWidget` widget will be showed as title of the dialog
  ///
  /// `contentWidget` widget will be showed as content of the dialog
  ///
  /// `closeWidget` widget will be showed at bottom of the dialog
  ///
  /// `function` callback when clicking `Close`
  ///
  /// `isActiveBack` default value is `true`, just work on Android, if `true` user can click back to dismiss dialog
  ///
  /// `isChangeContext` default true: when `function` is called, dialog will not be closed,
  /// when context is changed, dialog will be closed automatically
  void showDialogNotification(Widget titleWidget, Widget contentWidget,
      Widget closeWidget, String content,
      {bool isActiveBack = true,
      Function function,
      bool isChangeContext = false});

  // ---------- PRIVATE COMMANDS ---------- \\
  void _showDialog(Widget dialog, bool isActiveBack) {
    assert(context != null, "Context must be not null");

    if (context != null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () => _onBackPress(isActiveBack),
              child: dialog,
            );
          });
      numberOfDialogs++;
    }
  }

  Future<bool> _onBackPress(bool isActiveBack) {
    if (isActiveBack) {
      numberOfDialogs--;
    }
    return Future.value(isActiveBack);
  }

  void _dismissDialog({bool isAutoCloseDialog = false}) {
    if (numberOfDialogs >= 1) {
      numberOfDialogs--;
      if (!isAutoCloseDialog) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  IconData _buildIconDialog(String errorStr) {
    IconData iconData;
    switch (errorStr) {
      case sErrorConnectTimeOut:
        iconData = Icons.alarm_off;
        break;
      case sError401:
      case sError404:
      case sError502:
      case sError503:
      case sErrorAccountNotActived:
      case sErrorInternalServer:
        iconData = Icons.error_outline;
        break;
      case sErrorConnectFailedStr:
        iconData = Icons.signal_wifi_off;
        break;
      default:
        iconData = Icons.notifications_none;
    }
    return iconData;
  }
}
