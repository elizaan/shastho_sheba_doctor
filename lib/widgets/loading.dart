import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils.dart';

class Loading extends StatelessWidget {
  final message;

  Loading(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SpinKitFadingCube(
          color: blue,
        ),
        SizedBox(
          height: 25.0,
        ),
        Text(
          message,
          style: M,
        ),
      ],
    );
  }
}
