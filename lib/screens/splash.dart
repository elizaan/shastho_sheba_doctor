import 'dart:async';
import 'package:flutter/material.dart';

import '../routes.dart';
import '../utils.dart';
import '../repositories/authentication.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool status = false;
  bool login = true;
  String message;

  void _goToLoginScreen() {
    if (status == true) {
      Navigator.of(context)
          .pushReplacementNamed(loginScreen, arguments: message);
    }
    status = true;
  }

  void _goToHomeScreen() {
    if (status == true) {
      Navigator.of(context)
          .pushReplacementNamed(homeScreen, arguments: message);
    }
    status = true;
    login = false;
  }

  void _checkLogin() async {
    AuthenticationRepository authenticationRepository =
        AuthenticationRepository();
    try {
      final mobileNo = await authenticationRepository.checkPreviousLogin();
      message = 'Logged in with $mobileNo';
      _goToHomeScreen();
    } catch (e) {
      if (e.toString() == 'first') {
        _goToLoginScreen();
      } else {
        message = 'Session Expired. Please log in again';
        _goToLoginScreen();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLogin();
    Timer(
      Duration(seconds: 2),
      () {
        if (login) {
          _goToLoginScreen();
        } else {
          _goToHomeScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(splashbackgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  '  Welcome To\nShasthoSheba',
                  style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}
