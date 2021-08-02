import 'dart:io';
import 'package:shastho_sheba_doctor/main.dart';

import '../networking/api.dart';
import '../models/doctor.dart';

class DoctorRepository {
  Api _api = Api();

  Future<Doctor> getDetails() async {
    final data = await _api.get('/doctor/get/profile', true);
    MyApp.doctor = Doctor.fromJson(data['doctor']);
    return Doctor.fromJson(data['doctor']);
  }

  Future<Doctor> uploadProfilePic(File image) async {
    final data =
        await _api.uploadImage('/doctor/upload/profile_picture', image);
    return Doctor.fromJson(data['doctor']);
  }
}
