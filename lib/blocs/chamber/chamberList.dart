import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../baseBloc.dart';
import '../../models/schedule.dart';
import '../../networking/response.dart';
import '../../repositories/chamber.dart';

class ChamberListBloc extends ChangeNotifier implements BaseBloc {
  ChamberRepository _chamberRepository;
  StreamController _chamberListController;

  StreamSink<Response<List<Schedule>>> get sink => _chamberListController.sink;

  Stream<Response<List<Schedule>>> get stream => _chamberListController.stream;

  ChamberListBloc() {
    _chamberRepository = ChamberRepository();
    _chamberListController = StreamController<Response<List<Schedule>>>();
    fetchChamberList();
  }

  void fetchChamberList() async {
    sink.add(Response.loading("Loading Chamber List"));
    try {
      List<Schedule> data = await _chamberRepository.chamberList();
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _chamberListController?.close();
    super.dispose();
  }
}
