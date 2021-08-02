import '../models/schedule.dart';
import '../networking/api.dart';

class ScheduleRepository {
  Api _api = Api();

  Future<List<Schedule>> getSchedules() async {
    final data = await _api.get('/doctor/get/schedule/', true);
    return data['schedules']
        .map<Schedule>((json) => Schedule.fromJson(json))
        .toList();
  }

  Future<void> editSchedule(Schedule schedule) async {
    final data =
        await _api.post('/doctor/edit/schedule', true, schedule.toJson());
    print(data);
  }

  Future<void> addSchedule(Schedule schedule) async {
    final data =
        await _api.post('/doctor/post/schedule', true, schedule.toJson());
    print(data);
  }

  Future<void> deleteSchedule(var id) async {
    final data = await _api.get('/doctor/delete/schedule/' + id, true);
    print(data);
  }
}
