import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'baseBloc.dart';
import '../networking/response.dart';
import '../models/schedule.dart';
import '../repositories/schedule.dart';

class ScheduleBloc extends ChangeNotifier implements BaseBloc {
  ScheduleRepository _scheduleRepository;
  StreamController _scheduleController;
  String errorMessage;

  StreamSink<Response<List<Schedule>>> get scheduleSink =>
      _scheduleController.sink;

  Stream<Response<List<Schedule>>> get scheduleStream =>
      _scheduleController.stream;

  ScheduleBloc() {
    _scheduleRepository = ScheduleRepository();
    _scheduleController = StreamController<Response<List<Schedule>>>();
    fetchSchedule();
  }

  void fetchSchedule() async {
    scheduleSink.add(Response.loading("Loading Your Schedule"));
    try {
      List<Schedule> schedules = await _scheduleRepository.getSchedules();
      scheduleSink.add(Response.completed(schedules));
    } catch (e) {
      scheduleSink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _scheduleController?.close();
    super.dispose();
  }
}
