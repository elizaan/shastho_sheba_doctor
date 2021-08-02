import '../networking/api.dart';
import '../models/schedule.dart';
import '../models/appointment.dart';

class ChamberRepository {
  Api _api = Api();

  String getURL() {
    return _api.baseUrl;
  }

  Future<List<Schedule>> chamberList() async {
    final data = await _api.get('/doctor/schedule/today', true);
    return data['schedules']
        .map<Schedule>(
          (schedule) => Schedule.fromJson(schedule),
        )
        .toList();
  }

  Future<List<Appointment>> appointmentList(Schedule schedule) async {
    final data = await _api.get('/doctor/get/appointment/${schedule.id}', true);
    return data['appointments']
        .map<Appointment>(
          (appointment) => Appointment.fromJson(appointment),
        )
        .toList();
  }
}
