import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../baseBloc.dart';
import '../../models/prescription.dart';
import '../../models/appointment.dart';
import '../../models/medicine.dart';
import '../../networking/response.dart';

class AddPrescriptionBloc extends ChangeNotifier implements BaseBloc {
  StreamController _prescriptionController;
  List<Medicine> _medicineList;
  List<String> _symptomList;
  List<String> _adviseList;
  List<String> _testList;

  Appointment appointment;
  String name;
  String gender;
  String age;
  String weight, bp, temp, bs, pc;

  TextEditingController medicineController;
  TextEditingController dosageController;
  TextEditingController durationController;

  TextEditingController symptomController;

  TextEditingController adviseController;

  TextEditingController testController;

  StreamSink<Response<Prescription>> get sink => _prescriptionController.sink;

  Stream<Response<Prescription>> get stream => _prescriptionController.stream;

  UnmodifiableListView<Medicine> get medicines =>
      UnmodifiableListView<Medicine>(_medicineList);

  UnmodifiableListView<String> get symptoms =>
      UnmodifiableListView<String>(_symptomList);

  UnmodifiableListView<String> get advises =>
      UnmodifiableListView<String>(_adviseList);

  UnmodifiableListView<String> get tests =>
      UnmodifiableListView<String>(_testList);

  AddPrescriptionBloc(
      {this.appointment,
      this.name,
      this.gender,
      this.age,
      this.weight,
      this.bp,
      this.temp,
      this.bs,
      this.pc}) {
    _prescriptionController = StreamController<Response<Prescription>>();

    medicineController = TextEditingController();
    dosageController = TextEditingController();
    durationController = TextEditingController();
    symptomController = TextEditingController();
    adviseController = TextEditingController();
    testController = TextEditingController();

    _medicineList = List<Medicine>();
    _symptomList = List<String>();
    _adviseList = List<String>();
    _testList = List<String>();
  }

  void addMedicine() {
    Medicine medicine = Medicine(
      name: medicineController.text,
      dose: dosageController.text,
      days: durationController.text,
    );
    _medicineList.add(medicine);
    medicineController.clear();
    dosageController.clear();
    durationController.clear();
    notifyListeners();
  }

  void addSymptom() {
    _symptomList.add(symptomController.text);
    symptomController.clear();
    notifyListeners();
  }

  void addAdvise() {
    _adviseList.add(adviseController.text);
    adviseController.clear();
    notifyListeners();
  }

  void addTest() {
    _testList.add(testController.text);
    testController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _prescriptionController?.close();
    super.dispose();
  }
}
