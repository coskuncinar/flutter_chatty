import 'dart:io';

import 'package:fchatty/custom_widget/custom_alert_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends CustomAlertWidget {
  final String title;
  final String content;
  final String okButtonCaption;
  String? cancelButtonCaption;

  CustomAlertDialog(
      {Key? key, required this.title, required this.content, required this.okButtonCaption, this.cancelButtonCaption})
      : super(key: key);

  Future<bool> showAlertDialog(BuildContext context) async {
    bool result = false;
    if (Platform.isIOS) {
      await showCupertinoDialog<bool?>(context: context, builder: (context) => this).then((value) => result = value!);
    } else {
      await showDialog<bool?>(context: context, builder: (context) => this, barrierDismissible: false)
          .then((value) => result = value!);
    }
    return result;
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonConfig(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonConfig(context),
    );
  }

  List<Widget> _dialogButtonConfig(BuildContext context) {
    final allButtons = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonCaption != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButtonCaption!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        CupertinoDialogAction(
          child: Text(okButtonCaption),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonCaption != null) {
        allButtons.add(
          TextButton(
            child: Text(cancelButtonCaption!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        TextButton(
          child: Text(okButtonCaption),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return allButtons;
  }
}
