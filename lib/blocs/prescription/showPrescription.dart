import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../baseBloc.dart';
import '../../models/prescription.dart';
import '../../networking/response.dart';
import '../../repositories/prescription.dart';

class ShowPrescriptionBloc extends ChangeNotifier implements BaseBloc {
  PrescriptionRepository _prescriptionRepository;
  StreamController _prescriptionController;
  List<String> _appointmentList;
  String _currentAppointment;

  StreamSink<Response<Prescription>> get sink => _prescriptionController.sink;

  Stream<Response<Prescription>> get stream => _prescriptionController.stream;

  ShowPrescriptionBloc(this._currentAppointment, this._appointmentList) {
    _prescriptionRepository = PrescriptionRepository();
    _prescriptionController = StreamController<Response<Prescription>>();
    getPrescription();
  }

  void getPrescription() async {
    sink.add(Response.loading('Fetching Prescription'));
    try {
      final prescription =
          await _prescriptionRepository.getPrescription(_currentAppointment);
      sink.add(Response.completed(prescription));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  String prevAppointment() {
    int index = _appointmentList.indexOf(_currentAppointment);
    if (index == 0) {
      return null;
    }
    return _appointmentList[index - 1];
  }

  String nextAppointment() {
    int index = _appointmentList.indexOf(_currentAppointment);
    if (index == _appointmentList.length - 1) {
      return null;
    }
    return _appointmentList[index + 1];
  }

  void setCurrentAppointment(String appointmentId) {
    _currentAppointment = appointmentId;
    getPrescription();
  }

  @override
  void dispose() {
    _prescriptionController?.close();
    super.dispose();
  }
}
