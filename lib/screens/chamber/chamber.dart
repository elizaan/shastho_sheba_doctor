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
                            if(response.data.length==0)
                              {
                                return Center(child:
                                Text('No appointments today',
                                style:TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                )
                                    
                                ); }
                            return ListView.builder(
                              padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
                              itemCount: response.data.length,
                              itemBuilder: (context, index) {
                                print(response.data[index]);
                                return _Expandable(response.data[index], schedule);
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
  final Schedule schedule;

  _Expandable(this.appointment, this.schedule);

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
              onPressed: chamberBloc.getStatus(appointment.scheduleId) == true
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
              // onPressed: () async {
              //   await Navigator.pushNamed(
              //     context,
              //     appointmentDetailsScreen,
              //     arguments: {
              //       'messenger': chamberBloc.messenger,
              //       'appointment': appointment,
              //       'callable':
              //       appointment.status == AppointmentStatus.Verified &&
              //           chamberBloc.getStatus(appointment.id),
              //     },
              //   );
              //   chamberBloc.fetchChamberList();
              // },
            ),
            Expanded(
              child: new Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton.icon( icon: Icon(Icons.medical_services_outlined),
                    textColor: Colors.white,
                    color: blue,
                    label: Text(
                      'Add prescription',
                      style: M,
                    ),
                    onPressed: (){

                      Navigator.pushNamed(
                        context,
                        addPrescriptionScreen,
                        arguments: {
                          'name': appointment.patient.name,
                          'gender': appointment.patient.sex,
                          'age': age.toString(),
                          'appointment': appointment,
                        },
                      );
                    }),
              ),
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
              _Status(chamberBloc.getStatus(appointment.scheduleId)),
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



// import 'package:flutter/material.dart';
// import 'package:expandable/expandable.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../utils.dart';
// import '../../routes.dart';
// import '../../widgets/drawer.dart';
// import '../../widgets/loading.dart';
// import '../../widgets/error.dart';
// import '../../models/schedule.dart';
// import '../../models/appointment.dart';
// import '../../blocs/chamber/chamber.dart';
// import '../../networking/response.dart';
// import '../../repositories/chamber.dart';
//
// class ChamberScreen extends StatelessWidget {
//   ChamberRepository _chamberRepository = ChamberRepository();
//   Future<List<Appointment>> chmber_data(Schedule schedule) async
//   {
//     List<Appointment> chamber_data= await _chamberRepository.appointmentList(schedule);
//     return chamber_data;
//   }
//  Appointment appointment1;
//
//   @override
//   Widget build(BuildContext context) {
//     Schedule schedule = ModalRoute
//         .of(context)
//         .settings
//         .arguments;
//     String chamberName = DateFormat('hh:mm a').format(schedule.start) +
//         ' - ' +
//         DateFormat('hh:mm a').format(schedule.end);
// print('my chamber name' + chamberName);
// print(schedule);
//     List<Appointment> appnt;
//
//     return Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(backgroundimage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               elevation: 0.0,
//               backgroundColor: lightBlue,
//               centerTitle: true,
//               title: Text(chamberName),
//             ),
//             drawer: SafeArea(
//               child: MyDrawer(Selected.none),
//             ),
//             body: SafeArea(
//                 child: ChangeNotifierProvider(
//                     create: (context) => ChamberBloc(schedule),
//                     child: FutureBuilder<List<Appointment>>
//
//                       (future: _chamberRepository.appointmentList(schedule),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<List<Appointment>> snapshot) {
//                         if (!snapshot.hasData) {
//                           // while data is loading:
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         else {
//                           final List<Appointment> data_app = snapshot.data;
//                           Appointment appointment = data_app[0];
//                           return _Expandable(schedule, appointment);
//                         }
//                         //ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
//
//                         // return RefreshIndicator(
//                         //     onRefresh: () => chamberBloc.fetchChamberList(),
//                         //     child: StreamBuilder(
//                         //         stream: chamberBloc.stream,
//                         //         builder: (context, snapshot) {
//                         // if (snapshot.hasData) {
//                         // Response<List<Schedule>> response = snapshot.data;
//                         // switch (response.status) {
//                         // case Status.LOADING:
//                         // return Center(
//                         // child: Loading(response.message),
//                         // );
//                         // case Status.COMPLETED:
//                         // return ListView.builder(
//                         // padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
//                         // itemCount: response.data.length,
//                         // itemBuilder: (context, index) {
//                         // return _Expandable(schedule);
//                         // },
//                         // );
//                         // case Status.ERROR:
//                         // print(response.message);
//                         // return Center(
//                         // child: Error(
//                         // message: response.message,
//                         // onPressed: () => chamberBloc.fetchChamberList(),
//                         // ),
//                         // );
//                         return _Expandable(schedule, appointment1);
//                         // }} return Container();
//                       },)))
//         ));
//
//   }
//   }
//
//
// class _Expandable extends StatelessWidget {
//
//   final Schedule schedule;
//   final Appointment appointment;
//   _Expandable(this.schedule,this.appointment);
//
//
//   _buildList(BuildContext context) {
//     ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
//
//     return Container(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "day: ${schedule.day}",
//           style: M.copyWith(color: Colors.white),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: <Widget>[
//             RaisedButton.icon(
//               icon: Icon(Icons.timeline),
//               textColor: Colors.white,
//               color: blue,
//               label: Text(
//                 'Timeline',
//                 style: M,
//               ),
//
//               onPressed: chamberBloc.getStatus(schedule.id) == true
//                   ? () {
//                       Navigator.pushNamed(
//                         context,
//                         videoCallScreen,
//                         arguments: {
//                           'messenger': chamberBloc.messenger,
//                           'schedule': schedule
//                         },
//                       );
//                     }
//                   : null,
//             ),
//             Expanded(
//               child: new Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: RaisedButton.icon( icon: Icon(Icons.medical_services_outlined),
//                     textColor: Colors.white,
//                     color: blue,
//                     label: Text(
//                       'Add prescription',
//                       style: M,
//                     ),
//                     onPressed: (){
//
//                         Navigator.pushNamed(
//                           context,
//                           addPrescriptionScreen,
//                           arguments: appointment,
//                         );
//                     }),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     ChamberBloc chamberBloc = Provider.of<ChamberBloc>(context);
//     List<Appointment> appt;
//
//     return ExpandableNotifier(
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 5.0),
//         child: Card(
//           color: lightBlue,
//           child: Stack(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 10.0, vertical: 15.0),
//                 child: ScrollOnExpand(
//                   child: ExpandablePanel(
//                     header: Text(
//                       appointment.patient.name,
//                       style: L.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//
//
//
//                     //                 // collapsed: Text(
//                     //                 //   "Serial No: ${appointment.serialNo}",
//                     //                 //   style: TextStyle(color: Colors.white),
//                     //                 //   softWap: true,
//                     //                 //   maxLines: 1,
//                     //                 //   overflow: TextOverflow.ellipsis,
//                     //                 // ),
//                     expanded: _buildList(context),
//                     theme: ExpandableThemeData(
//                       iconColor: blue,
//                       tapBodyToExpand: true,
//                     ),
//
//                     //tapHeaderToExpand: true,
//                     // hasIcon: true,
//                   ),
//                 ),
//               ),
//
//
//               _Status(chamberBloc.getStatus(schedule.id)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Status extends StatelessWidget {
//   final bool status;
//
//   _Status(this.status);
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 0.0,
//       right: 0.0,
//       child: Container(
//         transform: Matrix4.translationValues(0.0, -3.0, 0.0),
//         padding: EdgeInsets.symmetric(
//           vertical: 4.0,
//           horizontal: 6.0,
//         ),
//         decoration: BoxDecoration(
//           color: status ? lightMint : lightRed,
//           borderRadius: BorderRadius.circular(12.0),
//           border: Border.all(
//             color: status ? mint : red,
//           ),
//         ),
//         child: Text(
//           status ? 'Online' : 'Offline',
//           style: S.copyWith(color: status ? mint : red),
//         ),
//       ),
//     );
//   }
// }
