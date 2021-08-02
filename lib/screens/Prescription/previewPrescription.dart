import 'package:shastho_sheba_doctor/networking/api.dart';
import 'package:shastho_sheba_doctor/repositories/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../routes.dart';
import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../blocs/prescription/addPresription.dart';
import '../../models/prescription.dart';

// ignore: must_be_immutable
class PreviewPrescriptionScreen extends StatelessWidget {
  final double cellPadding = 5.0;

  final Widget svg = SvgPicture.asset(
    stethoscope,
    height: 28.0,
    width: 28.0,
    color: blue,
  );

  AddPrescriptionBloc addPrescriptionBloc;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;

    addPrescriptionBloc = map['bloc'];

    String doctorName = MyApp.doctor.name;
    String institution = MyApp.doctor.institution;
    String designation = MyApp.doctor.designation;

    DateFormat dateFormatter = DateFormat('dd-MM-yyyy');

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
          title: Text('Prescription'),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.none),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Dr. $doctorName',
                                style: M.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                designation,
                                style: M.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                institution,
                                style: M.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                  'Date: ${dateFormatter.format(addPrescriptionBloc.appointment.dateTime)}',
                                  style:
                                      M.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: blue,
                        thickness: 2.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Patient Name: ',
                                style: M.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  addPrescriptionBloc.name,
                                  style: M,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Gender: ',
                                style: M.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                addPrescriptionBloc.gender,
                                style: M,
                              ),
                              Spacer(),
                              Text(
                                'Age: ',
                                style: M.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                addPrescriptionBloc.age,
                                style: M,
                              ),
                            ],
                          ),
                          Divider(
                            color: blue,
                            thickness: 2.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Weight(Kg): ',
                                style: M.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                (addPrescriptionBloc.weight.length == 0
                                    ? 'N/A'
                                    : addPrescriptionBloc.weight),
                                style: M,
                              ),
                              Spacer(),
                              Text(
                                'Body Temperature: ',
                                style: M.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                addPrescriptionBloc.temp.length == 0
                                    ? 'N/A'
                                    : addPrescriptionBloc.temp,
                                style: M,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Pulse Count: ',
                                style: M.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                addPrescriptionBloc.pc.length == 0
                                    ? 'N/A'
                                    : addPrescriptionBloc.pc,
                                style: M,
                              ),
                              Spacer(),
                              Text(
                                'Blood Pressure: ',
                                style: M.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                addPrescriptionBloc.bp.length == 0
                                    ? 'N/A'
                                    : addPrescriptionBloc.bp,
                                style: M,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Blood Sugar Level: ',
                                style: M.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                addPrescriptionBloc.bs.length == 0
                                    ? 'N/A'
                                    : addPrescriptionBloc.bs,
                                style: M,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: blue,
                        thickness: 2.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: <Widget>[
                            svg,
                            Text(
                              'Rx',
                              style: XL.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Symptoms',
                          style: L.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ...addPrescriptionBloc.symptoms
                          .asMap()
                          .map<int, Widget>(
                            (index, symptom) {
                              return MapEntry(
                                index,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    '${index + 1}. $symptom',
                                    style: M,
                                  ),
                                ),
                              );
                            },
                          )
                          .values
                          .toList(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Medicines',
                          style: L.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Table(
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FlexColumnWidth(3.0),
                          1: FlexColumnWidth(3.0),
                        },
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                child: Text(
                                  'Name',
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                child: Text(
                                  'Dose',
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                child: Text(
                                  'Days',
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          ...addPrescriptionBloc.medicines
                              .asMap()
                              .map<int, TableRow>((index, medicine) {
                                return MapEntry(
                                  index,
                                  TableRow(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Text(
                                          '${index + 1}. ${medicine.name}',
                                          style: M,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Text(
                                          medicine.dose,
                                          style: M,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(cellPadding),
                                        child: Text(
                                          medicine.days,
                                          style: M,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                              .values
                              .toList(),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Tests',
                          style: L.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ...addPrescriptionBloc.tests
                          .asMap()
                          .map<int, Widget>(
                            (index, test) {
                              return MapEntry(
                                index,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    '${index + 1}. $test',
                                    style: M,
                                  ),
                                ),
                              );
                            },
                          )
                          .values
                          .toList(),
                      SizedBox(
                        height: 5.0,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Special Advices',
                          style: L.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      ...addPrescriptionBloc.advises
                          .asMap()
                          .map<int, Widget>(
                            (index, advice) {
                              return MapEntry(
                                index,
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    '${index + 1}. $advice',
                                    style: M,
                                  ),
                                ),
                              );
                            },
                          )
                          .values
                          .toList(),
                    ],
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: blue,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ), // <-- Your text.
                      onPressed: () {
                        _submitPrescription(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitPrescription(BuildContext context) async {
    dynamic data = await Api().post(
        '/doctor/save/prescription',
        true,
        Prescription(
            appointmentId: addPrescriptionBloc.appointment.id,
            medicine: addPrescriptionBloc.medicines,
            prescriptionImg: null,
            symptoms: addPrescriptionBloc.symptoms,
            specialAdvice: addPrescriptionBloc.advises,
            tests: addPrescriptionBloc.tests,
            patientName: addPrescriptionBloc.name,
            patientAge: addPrescriptionBloc.age,
            patientSex: addPrescriptionBloc.gender,
            patientWeight: addPrescriptionBloc.weight,
            patientBP: addPrescriptionBloc.bp,
            patientTemperature: addPrescriptionBloc.temp,
            patientBloodSugar: addPrescriptionBloc.bs,
            patientPulseCount: addPrescriptionBloc.pc));

    await TransactionRepository()
        .updateTransaction(addPrescriptionBloc.appointment.id, 3);
    _dialog(context);
  }

  Future<void> _dialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmation',
            style: L.copyWith(color: blue),
          ),
          content: Text('prescription saved!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).popUntil((Route<dynamic> route) {
                  bool shouldPop = false;
                  if (route.settings.name == appointmentDetailsScreen) {
                    shouldPop = true;
                  }
                  return shouldPop;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
