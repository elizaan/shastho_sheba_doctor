import '../models/appointment.dart';

import '../networking/api.dart';

class AppointmentRepository {
  Api _api = Api();

  Future<List<Appointment>> getAppoinment(var scheduleId) async {
    final data = await _api.get('/doctor/get/appointment/' + scheduleId, true);
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }

  Future<List<Appointment>> getAppointments(String patientMobileNo) async {
    final data = await _api.post('/doctor/get/appointments', true, {
      'patient_mobile_no': patientMobileNo,
    });
    return data['appointments']
        .map<Appointment>((json) => Appointment.fromJson(json))
        .toList();
  }
}
