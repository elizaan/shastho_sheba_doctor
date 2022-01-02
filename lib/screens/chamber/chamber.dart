import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../models/schedule.dart';
import '../../models/appointment.dart';
import '../../blocs/chamber/chamber.dart';
import '../../networking/response.dart';

class ChamberScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Schedule schedule = ModalRoute.of(context).settings.arguments;
    String chamberName = DateFormat('hh:mm a').format(schedule.start) +
        ' - ' +
        DateFormat('hh:mm a').format(schedule.end);
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
            title: Text(chamberName),
          ),
          drawer: SafeArea(
            child: MyDrawer(Selected.none),
          ),
          body: SafeArea(
              child: ChangeNotifierProvider(
                  create: (context) => ChamberBloc(schedule),
                  child: Builder(builder: (context) {
                    ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
                    return RefreshIndicator(
                        onRefresh: () => chamberBloc.fetchChamberList(),
                        child: StreamBuilder(
                            stream: chamberBloc.stream,
                            builder: (context, snapshot) {
                              return _Expandable(schedule);
                            }));
                  }))),
        ));
  }
}

class _Expandable extends StatelessWidget {
  final Schedule schedule;

  _Expandable(this.schedule);

  _buildList(BuildContext context) {
    ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Day: ${schedule.day}",
          style: M.copyWith(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.timeline),
              textColor: Colors.white,
              color: blue,
              label: Text(
                'Timeline',
                style: M,
              ),
              // onPressed: () async {
              //   await Navigator.pushNamed(
              //     context,
              //     appointmentDetailsScreen,
              //     arguments: {
              //       'messenger': chamberBloc.messenger,
              //       'appointment': appointment,
              //       'callable':
              //           appointment.status == AppointmentStatus.Verified &&
              //               chamberBloc.getStatus(appointment.id),
              //     },
              //   );
              //   chamberBloc.fetchChamberList();
              // },
              onPressed: chamberBloc.getStatus(schedule.id) == true
                  ? () {
                      Navigator.pushNamed(
                        context,
                        videoCallScreen,
                        arguments: {
                          'messenger': chamberBloc.messenger,
                          'schedule': schedule
                        },
                      );
                    }
                  : null,
            ),
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Card(
          color: lightBlue,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: ScrollOnExpand(
                  child: ExpandablePanel(
                    header: Text(
                      'hello',
                      style: L.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //                 // collapsed: Text(
                    //                 //   "Serial No: ${appointment.serialNo}",
                    //                 //   style: TextStyle(color: Colors.white),
                    //                 //   softWrap: true,
                    //                 //   maxLines: 1,
                    //                 //   overflow: TextOverflow.ellipsis,
                    //                 // ),
                    expanded: _buildList(context),
                    theme: ExpandableThemeData(
                      iconColor: blue,
                      tapBodyToExpand: true,
                    ),
                    //tapHeaderToExpand: true,
                    // hasIcon: true,
                  ),
                ),
              ),
              _Status(chamberBloc.getStatus(schedule.id)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final bool status;

  _Status(this.status);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      right: 0.0,
      child: Container(
        transform: Matrix4.translationValues(0.0, -3.0, 0.0),
        padding: EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 6.0,
        ),
        decoration: BoxDecoration(
          color: status ? lightMint : lightRed,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: status ? mint : red,
          ),
        ),
        child: Text(
          status ? 'Online' : 'Offline',
          style: S.copyWith(color: status ? mint : red),
        ),
      ),
    );
  }
}
