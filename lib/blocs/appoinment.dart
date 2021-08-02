import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../repositories/appointment.dart';
import '../networking/response.dart';

class AppointmentBloc extends ChangeNotifier implements BaseBloc {
  AppointmentRepository _appointmentRepository;
  StreamController _appointmentController;
  String errorMessage;

  StreamSink<Response<List<Appointment>>> get appointmentSink =>
      _appointmentController.sink;

  Stream<Response<List<Appointment>>> get appointmentStream =>
      _appointmentController.stream;

  AppointmentBloc() {
    _appointmentRepository = AppointmentRepository();
    _appointmentController = StreamController<Response<List<Appointment>>>();
  }

  void fetchAppointment(var scheduleId) async {
    appointmentSink.add(Response.loading("Loading Your  appointment"));
    try {
      List<Appointment> appointments =
          await _appointmentRepository.getAppoinment(scheduleId);
      appointmentSink.add(Response.completed(appointments));
    } catch (e) {
      appointmentSink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _appointmentController?.close();
    super.dispose();
  }
}
