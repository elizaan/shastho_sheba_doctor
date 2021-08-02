import 'package:shastho_sheba_doctor/models/appointment.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../utils.dart';

class PreScreen extends StatelessWidget {
  final Appointment appointment;
  PreScreen(this.appointment);
  @override
  Widget build(BuildContext context) {
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
          title: Text('Prescription Form'),
        ),
        body: SafeArea(child: MyCustomForm(appointment)),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final Appointment appointment;
  MyCustomForm(this.appointment);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState(appointment);
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final Appointment appointment;
  MyCustomFormState(this.appointment);
  final _formKey = GlobalKey<FormState>();
  TextEditingController patientName;

  TextEditingController ageController;
  TextEditingController weightController;
  TextEditingController bpController;
  TextEditingController tempController;
  TextEditingController bsController;
  TextEditingController pcController;
  String year, month;

  void initState() {
    super.initState();
    year = (DateTime.now().difference(appointment.patient.dob).inDays ~/ 365)
        .toString();
    month =
        (((DateTime.now().difference(appointment.patient.dob).inDays).toInt() %
                    365) ~/
                30)
            .toString();
    print(year + ' ' + month);
    patientName = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    weightController.text = null;
    bpController = TextEditingController();
    bpController.text = null;
    tempController = TextEditingController();
    tempController.text = null;
    bsController = TextEditingController();
    bsController.text = null;
    pcController = TextEditingController();
    pcController.text = null;
    patientName.text = appointment.patient.name;
    ageController.text = year + ' yr ' + month + ' months';

    dropdownValue = appointment.patient.sex;
  }

  String dropdownValue;
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Expanded(child: SizedBox()),
                TextFormField(
                  controller: patientName,
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    //icon: Icon(Icons.person),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 40.0),
                      child: Text(
                        'Gender:',
                        style: M,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'Male',
                              groupValue: dropdownValue,
                              onChanged: (String value) {
                                setState(() {
                                  dropdownValue = value;
                                });
                              },
                            ),
                            Text(
                              'Male',
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: 'Female',
                              groupValue: dropdownValue,
                              onChanged: (String value) {
                                setState(() {
                                  dropdownValue = value;
                                });
                              },
                            ),
                            Text(
                              'Female',
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    //icon: Icon(Icons.calendar_today),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(
                    hintText: '50 kg',
                    labelText: 'Weight',
                    //icon: Icon(Icons.calendar_today),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: bpController,
                  decoration: InputDecoration(
                    hintText: '120/80 mm Hg',
                    labelText: 'Blood Pressure',
                    //icon: Icon(Icons.calendar_today),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: tempController,
                  decoration: InputDecoration(
                    hintText: '98 F',
                    labelText: 'Temperature',
                    //icon: Icon(Icons.calendar_today),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: bsController,
                  decoration: InputDecoration(
                    hintText: '120 mg/dL',
                    labelText: 'Blood Suger',
                    //icon: Icon(Icons.calendar_today),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: pcController,
                  decoration: InputDecoration(
                    hintText: '40 BPM',
                    labelText: 'Pulse Count',
                    //icon: Icon(Icons.calendar_today),
                    //errorText: 'Enter Patient Name',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  child: Text(
                    'Go to write prescription',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: blue,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      addPrescriptionScreen,
                      arguments: {
                        'name': patientName.text,
                        'gender': dropdownValue,
                        'age': ageController.text,
                        'weight': weightController.text,
                        'bp': bpController.text,
                        'temp': tempController.text,
                        'bs': bsController.text,
                        'pc': pcController.text,
                        'appointment': appointment,
                      },
                    );
                  },
                ),
                //Expanded(child: SizedBox()),
              ],
            ),
          ),
        ]);
  }
}
