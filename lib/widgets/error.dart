import 'package:flutter/material.dart';
import '../utils.dart';

class Error extends StatelessWidget {
  final message;
  final void Function() onPressed;

  Error({this.message, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          message,
          style: M,
        ),
        SizedBox(
          height: 10.0,
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text(
            'Retry',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: red,
        ),
      ],
    );
  }
}
