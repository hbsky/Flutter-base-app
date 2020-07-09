import 'package:base_app/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

Widget wBuildLoading() {
  return LoadingBouncingLine.circle(
      backgroundColor: colorLoading, size: 120.0, borderColor: colorLoading);
}

Widget wBaseShowLoading(Widget child, bool isShowLoading) {
  return Stack(
    children: <Widget>[
      IgnorePointer(
        ignoring: isShowLoading,
        child: child,
      ),
      Visibility(
          visible: isShowLoading,
          child: Container(
            color: Colors.black54,
            height: double.infinity,
            width: double.infinity,
            child: wBuildLoading(),
          )),
    ],
  );
}
