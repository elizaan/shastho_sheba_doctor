import 'package:shastho_sheba_doctor/screens/Prescription/preprescription.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../widgets/loading.dart';
import '../../widgets/error.dart';
import '../../routes.dart';
import '../../networking/response.dart';
import '../../models/appointment.dart';
import '../../blocs/chamber/messenger.dart';
import '../../blocs/timeline.dart';
import 'tile.dart';

class AppointmentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    Messenger messenger = args['messenger'];
    Appointment appointment = args['appointment'];
    bool callable = args['callable'];
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
          title: Text(appointment.patient.name),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => TimelineBloc(appointment),
            builder: (context, child) {
              TimelineBloc timelineBloc = Provider.of<TimelineBloc>(context);
              return StreamBuilder(
                stream: timelineBloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Response<List<Appointment>> response = snapshot.data;
                    switch (response.status) {
                      case Status.LOADING:
                        return Center(
                          child: Loading(response.message),
                        );
                      case Status.COMPLETED:
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            ListView.builder(
                              padding:
                                  EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 50.0),
                              itemCount: response.data.length,
                              itemBuilder: (context, index) {
                                Appointment _appointment = response.data[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  child: Tile(
                                    appointment: _appointment,
                                    onCancelAppointment: () {},
                                    // onCancelAppointment: () =>
                                    //     _cancelAppointment(
                                    //   context,
                                    //   timelineBloc,
                                    //   _appointment.id,
                                    //   response.data.length == 1,
                                    // ),
                                    onViewTransactions: () async {
                                      await Navigator.pushNamed(
                                        context,
                                        transactionsScreen,
                                        arguments: {
                                          'appointmentId': _appointment.id,
                                          'due': _appointment.due,
                                          'verified': _appointment.status ==
                                                  AppointmentStatus.Verified ||
                                              _appointment.status ==
                                                  AppointmentStatus.Finished,
                                        },
                                      );
                                      timelineBloc.fetchTimeline();
                                    },
                                    onShowPrescription: () {
                                      Navigator.pushNamed(
                                        context,
                                        showPrescriptionScreen,
                                        arguments: {
                                          'appointmentId': _appointment.id,
                                          'appointmentDate':
                                              _appointment.dateTime,
                                          'doctorName': MyApp.doctor.name,
                                          'doctorDesignation':
                                              MyApp.doctor.designation,
                                          'doctorInstitution':
                                              MyApp.doctor.institution,
                                          'appointmentList':
                                              timelineBloc.appointmentList(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: blue,
                                  ),
                                  child: FittedBox(
                                    child: IconButton(
                                      icon: Icon(Icons.content_paste),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PreScreen(appointment)),
                                        );
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   addPrescriptionScreen,
                                        //   arguments: appointment,
                                        // );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: callable ? blue : Colors.grey,
                                  ),
                                  child: FittedBox(
                                    child: IconButton(
                                      icon: Icon(Icons.call),
                                      color: Colors.white,
                                      onPressed: callable == true
                                          ? () {
                                              Navigator.pushNamed(
                                                context,
                                                videoCallScreen,
                                                arguments: {
                                                  'messenger': messenger,
                                                  'appointment': appointment,
                                                },
                                              );
                                            }
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      case Status.ERROR:
                        return Center(
                          child: Error(
                            message: response.message,
                            onPressed: () => timelineBloc.fetchTimeline(),
                          ),
                        );
                    }
                  }
                  return Container();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// void _cancelAppointment(BuildContext context, TimelineBloc timelineBloc,
//     String appointmentId, bool onlyAppointment) async {
//   bool confirmation =
//       await confirmationDialog(context, 'This will cancel your appointment');
//   if (confirmation) {
//     try {
//       await showProgressDialog(context, 'Please Wait');
//       await timelineBloc.cancelAppointment(appointmentId);
//       await hideProgressDialog();
//       await successDialog(context, 'Appointment canceled successfully');
//       if (onlyAppointment) {
//         Navigator.popUntil(
//           context,
//           ModalRoute.withName(homeScreen),
//         );
//       } else {
//         timelineBloc.fetchTimeline();
//       }
//     } catch (e) {
//       await hideProgressDialog();
//       await failureDialog(context, e.toString());
//     }
//   }
// }
