import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shastho_sheba_doctor/models/doctor.dart';

import 'baseBloc.dart';
import '../networking/response.dart';
import '../repositories/authentication.dart';
import '../models/patient.dart';

class RegistrationBloc extends ChangeNotifier implements BaseBloc {
  AuthenticationRepository _authenticationRepository;
  StreamController _registrationController;
  String _sex = 'Male';
  DateTime _selectedDate;
  final formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final name = TextEditingController();
  final mobileNo = TextEditingController();
  final email =TextEditingController();
  final institution=TextEditingController();
  final designation=TextEditingController();
  final reg_number=TextEditingController();
  final about_me=TextEditingController();
  final specialization=[];
  Validator validator;

  StreamSink<Response<String>> get sink => _registrationController.sink;

  Stream<Response<String>> get stream => _registrationController.stream;


  set special(String val)
  {
    specialization.add(val);
    notifyListeners();
  }


  RegistrationBloc() {
    _authenticationRepository = AuthenticationRepository();
    _registrationController = StreamController<Response<String>>();
    validator = Validator(pass);
  }

  void register() async {
    if (formKey.currentState.validate()) {
      Doctor doctor = Doctor(
        name: name.text,
        email: email.text,
        mobileNo: mobileNo.text,
        institution: institution.text,
        //specialization: specialization,
        designation: designation.text,
        registrationNo: reg_number.text,
        image: '',
        password: pass.text,
      );
      sink.add(Response.loading('Please Wait'));
      try {
        await _authenticationRepository.register(doctor);
        sink.add(Response.completed('Registered Successfully'));
      } catch (e) {
        sink.add(Response.error(e.toString()));
      }
    }
  }

  @override
  void dispose() {
    _registrationController?.close();

    pass.dispose();
    name.dispose();
    mobileNo.dispose();
    institution.dispose();
    designation.dispose();
    super.dispose();
  }
}

class Validator {
  TextEditingController pass;

  Validator(this.pass);

  String nameValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String mobileNoValidator(String value) {
    if (value.isEmpty) {
      return "Please enter your Mobile Number";
    }
    return null;
  }

  String dobValidator(String value) {
    if (value.isEmpty) {
      return "Please enter your Date of Birth";
    }
    return null;
  }

  String passwordValidator(String value) {
    if (value.isEmpty) {
      return "Please provide a password";
    }
    return null;
  }

  String confirmPasswordValidator(String value) {
    if (value != pass.text) {
      return 'Password does not match';
    }
    return null;
  }
}