import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'messenger.dart';
import '../baseBloc.dart';
import '../../models/appointment.dart';
import '../../models/schedule.dart';
import '../../networking/response.dart';
import '../../repositories/chamber.dart';

class ChamberBloc extends ChangeNotifier implements BaseBloc {
  ChamberRepository _chamberRepository;
  StreamController _chamberController;
  Messenger messenger;
  Schedule _schedule;
  Map<String, bool> online = Map<String, bool>();

  StreamSink<Response<List<Appointment>>> get sink => _chamberController.sink;

  Stream<Response<List<Appointment>>> get stream => _chamberController.stream;

  ChamberBloc(this._schedule) {
    _chamberRepository = ChamberRepository();
    _chamberController = StreamController<Response<List<Appointment>>>();
    messenger = Messenger(_chamberRepository.getURL(), this);
    fetchChamberList();
  }

  Future<void> fetchChamberList() async {
    sink.add(Response.loading("Loading Appointment List"));
    try {
      List<Appointment> data =
          await _chamberRepository.appointmentList(_schedule);
      messenger.init(data);
      data.forEach((appointment) => online.addAll({appointment.id: false}));
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  double getFee() {
    return _schedule.fee;
  }

  bool getStatus(String appointmentId) {
    return online[appointmentId];
  }

  void setOnline(String appointmentId) {
    online.update(appointmentId, (prev) => true, ifAbsent: () => true);
    notifyListeners();
  }

  void setOffline(String appointmentId) {
    online.update(appointmentId, (prev) => false, ifAbsent: () => false);
    notifyListeners();
  }

  @override
  void dispose() {
    _chamberController?.close();
    messenger.dispose();
    super.dispose();
  }
}
