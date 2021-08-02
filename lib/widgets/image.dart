import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utils.dart';

class ShowImage extends StatelessWidget {
  final String _url;
  // final double _size;

  // ShowImage(this._url, this._size);
  ShowImage(this._url);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SpinKitRing(
            color: blue,
            // size: _size,
          ),
        ),
        Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: _url,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
