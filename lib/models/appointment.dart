import 'schedule.dart';
import 'doctor.dart';
import 'patient.dart';

enum AppointmentStatus { NoPayment, NotVerified, Verified, Finished }

Map<int, AppointmentStatus> map = {
  0: AppointmentStatus.NoPayment,
  1: AppointmentStatus.NotVerified,
  2: AppointmentStatus.Verified,
  3: AppointmentStatus.Finished,
};

class Appointment {
  final String id;
  Schedule schedule;
  Doctor doctor;
  Patient patient;
  final DateTime dateTime;
  final DateTime createdAt;
  final AppointmentStatus status;
  final int serialNo;
  final double due;

  Appointment({
    this.id,
    this.doctor,
    this.patient,
    this.dateTime,
    this.createdAt,
    this.schedule,
    this.status,
    this.serialNo,
    this.due,
  });

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value + .0;
    }
    return value;
  }

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        status = map[json['status']],
        serialNo = json['serial_no'],
        due = _parseDouble(json['due']),
        createdAt = json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        dateTime = DateTime.parse(json['appointment_date_time']) {
    if (!(json['schedule_id'] is String)) {
      schedule = Schedule.fromJson(json['schedule_id']);
    }
    if (!(json['doctorId'] is String)) {
      doctor = Doctor.fromJson(json['doctorId']);
    }
    if (!(json['patientId'] is String)) {
      patient = Patient.fromJson(json['patientId']);
    }
  }
}
