import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/patient.dart';
import '../repositories/patient.dart';
import 'baseBloc.dart';
import '../networking/response.dart';

class PatientBloc extends ChangeNotifier implements BaseBloc {
  PatientRepository _patientRepository;
  StreamController _patientController;
  String errorMessage;

  StreamSink<Response<Patient>> get patientSink => _patientController.sink;

  Stream<Response<Patient>> get patientStream => _patientController.stream;

  PatientBloc() {
    _patientRepository = PatientRepository();
    _patientController = StreamController<Response<Patient>>();
  }

  void fetchPatient(var appointmentId) async {
    patientSink.add(Response.loading("Loading Your Patient"));
    try {
      Patient patient = await _patientRepository.getPatient(appointmentId);
      patientSink.add(Response.completed(patient));
    } catch (e) {
      patientSink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _patientController?.close();
    super.dispose();
  }
}
