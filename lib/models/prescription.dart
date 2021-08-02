import 'medicine.dart';

class Prescription {
  final String appointmentId;
  final String prescriptionImg;
  final String patientName;
  final String patientAge;
  final String patientSex;
  final String patientWeight;
  final String patientBP;
  final String patientTemperature;
  final String patientBloodSugar;
  final String patientPulseCount;
  final List<String> symptoms;
  final List<String> tests;
  final List<String> specialAdvice;
  final List<Medicine> medicine;

  Prescription({
    this.appointmentId,
    this.prescriptionImg,
    this.patientName,
    this.patientAge,
    this.patientSex,
    this.patientWeight,
    this.patientBP,
    this.patientTemperature,
    this.patientBloodSugar,
    this.patientPulseCount,
    this.medicine,
    this.symptoms,
    this.tests,
    this.specialAdvice,
  });

  Prescription.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointment_id'],
        prescriptionImg = json['prescription_img'],
        patientName = json['patient_name'],
        patientAge = json['patient_age'],
        patientSex = json['patient_sex'],
        patientWeight = json['patient_weight'],
        patientBP = json['patient_bp'],
        patientTemperature = json['patient_temperature'],
        patientBloodSugar = json['patient_blood_sugar'],
        patientPulseCount = json['patient_pulse_count'],
        symptoms = json['symptoms'].cast<String>(),
        tests = json['tests'].cast<String>(),
        specialAdvice = json['special_advice'].cast<String>(),
        medicine = json['medicine'] != null
            ? json['medicine']
                .map<Medicine>((json) => Medicine.fromJson(json))
                .toList()
            : null;
  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'prescription_img': prescriptionImg,
      'patient_name': patientName,
      'patient_age': patientAge,
      'patient_sex': patientSex,
      'patient_weight': patientWeight,
      'patient_bp': patientBP,
      'patient_temperature': patientTemperature,
      'patient_blood_sugar': patientBloodSugar,
      'patient_pulse_count': patientPulseCount,
      'symptoms': symptoms,
      'tests': tests,
      'medicine': medicine,
      'special_advice': specialAdvice
    };
  }
}
