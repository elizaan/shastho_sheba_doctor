import '../models/patient.dart';

import '../networking/api.dart';

class PatientRepository {
  Api _api = Api();

  Future<Patient> getPatient(var appointmentId) async {
    final data = await _api.post('/doctor/get/appointmentDetail', true,
        {'appointment_id': appointmentId});
    return Patient.fromJson(data['patient']);
  }
}
