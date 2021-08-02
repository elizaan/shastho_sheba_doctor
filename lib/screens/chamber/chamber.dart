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
            child: Builder(
              builder: (context) {
                ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
                return RefreshIndicator(
                  onRefresh: () => chamberBloc.fetchChamberList(),
                  child: StreamBuilder(
                    stream: chamberBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<List<Appointment>> response = snapshot.data;
                        switch (response.status) {
                          case Status.LOADING:
                            return Center(
                              child: Loading(response.message),
                            );
                          case Status.COMPLETED:
                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
                              itemCount: response.data.length,
                              itemBuilder: (context, index) {
                                return _Expandable(response.data[index]);
                              },
                            );
                          case Status.ERROR:
                            print(response.message);
                            return Center(
                              child: Error(
                                message: response.message,
                                onPressed: () => chamberBloc.fetchChamberList(),
                              ),
                            );
                        }
                      }
                      return Container();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Expandable extends StatelessWidget {
  final Appointment appointment;

  _Expandable(this.appointment);

  _buildList(BuildContext context) {
    ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
    Duration difference = DateTime.now().difference(appointment.patient.dob);
    int age = (difference.inDays ~/ 365).toInt();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Serial No: ${appointment.serialNo}",
          style: M.copyWith(color: Colors.white),
        ),
        Text(
          "Age: ${age.toString()}",
          style: M.copyWith(color: Colors.white),
        ),
        Text(
          "Sex: ${appointment.patient.sex}",
          style: M.copyWith(color: Colors.white),
        ),
        Row(
          children: <Widget>[
            Text(
              "Payment: ",
              style: M.copyWith(color: Colors.white),
            ),
            appointment.status == AppointmentStatus.NoPayment
                ? Text('No Payment Provided', style: M.copyWith(color: red))
                : appointment.status == AppointmentStatus.NotVerified
                    ? RaisedButton.icon(
                        icon: Icon(Icons.verified_user),
                        textColor: Colors.white,
                        color: blue,
                        label: Text(
                          'Verify',
                          style: M,
                        ),
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            transactionsScreen,
                            arguments: {
                              'appointmentId': appointment.id,
                              'fee': chamberBloc.getFee(),
                              'verified': false,
                            },
                          );
                          chamberBloc.fetchChamberList();
                        },
                      )
                    : Text(
                        'Verified',
                        style: M.copyWith(color: mint),
                      )
          ],
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
              onPressed: () async {
                await Navigator.pushNamed(
                  context,
                  appointmentDetailsScreen,
                  arguments: {
                    'messenger': chamberBloc.messenger,
                    'appointment': appointment,
                    'callable':
                        appointment.status == AppointmentStatus.Verified &&
                            chamberBloc.getStatus(appointment.id),
                  },
                );
                chamberBloc.fetchChamberList();
              },
            ),
          ],
        ),
      ],
    );
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
                      appointment.patient.name,
                      style: L.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    collapsed: Text(
                      "Serial No: ${appointment.serialNo}",
                      style: TextStyle(color: Colors.white),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
              _Status(chamberBloc.getStatus(appointment.id)),
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
