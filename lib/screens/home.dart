import 'package:flutter/material.dart';

import '../routes.dart';
import '../utils.dart';
import '../widgets/drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String message = ModalRoute.of(context).settings.arguments;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home),
              Text(
                'Home',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.home),
        ),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (message != null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                );
              }
              return Center(
                child: Center(
                  child: GridView.count(
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: <Widget>[
                      _Tile('My Schedule', Icons.schedule, scheduleScreen),
                      _Tile('My Chamber', Icons.work, selectChamberScreen),
                      _Tile('My Profile', Icons.person, profileScreen),
                      _Tile('Feedback', Icons.feedback, feedbackScreen),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  _Tile(this.title, this.icon, this.route);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 40,
            color: blue,
          ),
          Text(
            title,
            style: L.copyWith(color: blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
