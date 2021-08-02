import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../utils.dart';
import 'loading.dart';

Future<void> successDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Congratulations!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

Future<void> failureDialog(BuildContext context, String message) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Something Went Wrong!'),
        content: Text(message + '. Please Try Again'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

Future<bool> confirmationDialog(BuildContext context, String message) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Are You Sure?'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop<bool>(context, false);
            },
            child: Text(
              'No',
              style: TextStyle(color: red),
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop<bool>(context, true);
            },
            child: Text(
              'Yes',
              style: TextStyle(color: mint),
            ),
          ),
        ],
      );
    },
  );
}

ProgressDialog progressDialog;

Future<bool> showProgressDialog(BuildContext context, String message) async {
  progressDialog = ProgressDialog(
    context,
    isDismissible: false,
    customBody: Container(
      margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
      child: Loading(message),
    ),
  );
  return await progressDialog.show();
}

Future<bool> hideProgressDialog() async {
  return await progressDialog.hide();
}
