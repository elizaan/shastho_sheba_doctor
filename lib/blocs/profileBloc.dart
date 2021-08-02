import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/doctor.dart';
import '../models/doctor.dart';

class ProfileBloc extends ChangeNotifier implements BaseBloc {
  DoctorRepository _doctorRepository;
  StreamController _profileController;

  StreamSink<Response<Doctor>> get sink => _profileController.sink;

  Stream<Response<Doctor>> get stream => _profileController.stream;

  ProfileBloc() {
    _doctorRepository = DoctorRepository();
    _profileController = StreamController<Response<Doctor>>();
    getDoctorDetails();
  }

  void getDoctorDetails() async {
    sink.add(Response.loading('Fetching Details'));
    try {
      final data = await _doctorRepository.getDetails();
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> uploadProfilePic() async {
    var selected = await ImagePicker().getImage(source: ImageSource.gallery);
    File image = File(selected.path);
    sink.add(Response.loading('Uploading Image'));
    try {
      final data = await _doctorRepository.uploadProfilePic(image);
      sink.add(Response.completed(data));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  @override
  void dispose() {
    _profileController?.close();
    super.dispose();
  }
}
