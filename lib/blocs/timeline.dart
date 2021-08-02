import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/appointment.dart';
import '../networking/response.dart';
import '../repositories/appointment.dart';

class TimelineBloc extends ChangeNotifier implements BaseBloc {
  AppointmentRepository _appointmentRepository;
  StreamController _timelineController;
  Appointment _appointment;
  List<Appointment> _appointmentList;

  StreamSink<Response<List<Appointment>>> get sink => _timelineController.sink;

  Stream<Response<List<Appointment>>> get stream => _timelineController.stream;

  TimelineBloc(this._appointment) {
    _appointmentRepository = AppointmentRepository();
    _timelineController = StreamController<Response<List<Appointment>>>();
    fetchTimeline();
  }

  void fetchTimeline() async {
    sink.add(Response.loading('Fetching Timeline'));
    try {
      _appointmentList = await _appointmentRepository
          .getAppointments(_appointment.patient.mobileNo);
      sink.add(Response.completed(_appointmentList));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  // Future<void> cancelAppointment(String appointmentId) async {
  //   await _appointmentRepository.cancelAppointment(appointmentId);
  // }

  List<String> appointmentList() {
    List<String> result = List<String>();
    _appointmentList.forEach((element) {
      if (element.status == AppointmentStatus.Finished) {
        result.add(element.id);
      }
    });
    return result;
  }

  @override
  void dispose() {
    _timelineController?.close();
    super.dispose();
  }
}
