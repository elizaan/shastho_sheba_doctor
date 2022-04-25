import 'package:shastho_sheba_doctor/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../networking/api.dart';
import '../networking/customException.dart';

class AuthenticationRepository {
  Api _api = Api();
  Future<void> register(Doctor doctor) async {
    await _api.post('/doctor/post/register', false, doctor);
  }

  Future<String> login(String mobileNo, String password) async {
    final data = await _api.post('/doctor/post/login', false,
        {'mobile_no': mobileNo, 'password': password});
    MyApp.doctor = Doctor.fromJson(data['doctor_detail']);
    return data['token'];
  }

  Future<String> checkPreviousLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jwt = sharedPreferences.getString('jwt');
    if (jwt == null) {
      throw CustomException('first');
    }
    final data = await _api.post('/doctor/verify/token', false, {'token': jwt});
    //print(data);
    MyApp.doctor = Doctor.fromJson(data['doctor']);
    return MyApp.doctor.mobileNo;
  }

  Future<void> logOut() async {
    
    await _api.get('/doctor/logout', true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('jwt');
  }
}
