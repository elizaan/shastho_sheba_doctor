import 'package:flutter/material.dart';

import '../utils.dart';
import '../routes.dart';
import '../repositories/authentication.dart';
import 'dialogs.dart';

enum Selected {
  home,
  schedule,
  chamber,
  profile,
  feedback,
  none,
}

class MyDrawer extends StatelessWidget {
  final Selected selected;

  MyDrawer(this.selected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: lightBlue,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(
                  'ShasthoSheba',
                  style: XL.copyWith(color: Colors.white),
                ),
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Home',
              icon: Icons.home,
              selected: selected == Selected.home,
              route: homeScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'My Schedule',
              icon: Icons.schedule,
              selected: selected == Selected.schedule,
              route: scheduleScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'My Chamber',
              icon: Icons.work,
              selected: selected == Selected.chamber,
              route: selectChamberScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'My Profile',
              icon: Icons.person,
              selected: selected == Selected.profile,
              route: profileScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            _Tile(
              title: 'Feedback',
              icon: Icons.feedback,
              selected: selected == Selected.feedback,
              route: feedbackScreen,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            Expanded(
              child: SizedBox(),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: Text(
                'Logout',
                style: M.copyWith(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30,
              ),
              onTap: () => _logOut(context),
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final String route;

  _Tile({this.title, this.icon, this.selected, this.route});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? Colors.white : Colors.transparent,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        title: Text(
          title,
          style: M.copyWith(
            color: selected ? blue : Colors.white,
          ),
        ),
        trailing: Icon(
          icon,
          color: selected ? blue : Colors.white,
          size: 30,
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(homeScreen, (_) => false);
          if (route != homeScreen) {
            Navigator.of(context).pushNamed(route);
          }
        },
      ),
    );
  }
}

void _logOut(BuildContext context) async {
  AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  bool confirmation =
      await confirmationDialog(context, 'Are you sure you want to log out?');
  if (!confirmation) {
    return;
  }
  try {
    showProgressDialog(context, 'Logging Out');
    await authenticationRepository.logOut();
    hideProgressDialog();
    Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
  } catch (e) {
    hideProgressDialog();
    failureDialog(context, e.toString());
  }
}
