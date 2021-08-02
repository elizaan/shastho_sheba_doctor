import '../networking/api.dart';
import '../models/prescription.dart';

class PrescriptionRepository {
  Api _api = Api();

  Future<Prescription> getPrescription(String appointmentId) async {
    final data = await _api.post(
        '/doctor/get/prescription', true, {'appointment_id': appointmentId});

    return Prescription.fromJson(data['prescription'][0]);
  }
}
