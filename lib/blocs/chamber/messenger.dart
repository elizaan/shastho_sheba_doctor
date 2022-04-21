import 'package:shastho_sheba_doctor/models/schedule.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chamber.dart';
import 'signaling.dart';
import '../../models/appointment.dart';

class Messenger {
  String _url;
  Socket _socket;
  Signaling signaling;
  ChamberBloc _chamberBloc;

  Messenger(this._url, this._chamberBloc);

  // void init(Schedule schedule) async {
  //   _socket = io(_url, <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //   });

  void init(List<Appointment> appointments) async {
    _socket = io(_url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    signaling = Signaling();

    _socket.connect();

    _socket.on(
      'connect',
          (_) async {
        print('connect');
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        String jwt = sharedPreferences.getString('jwt');
        appointments.forEach((appointment) {
          print('join');
          print('after join');
          print(appointment);
          _socket.emit('join', {
            'token': 'Bearer ' + jwt,
            'type': 'doctor',
            //'chamberId': appointment.id,
            'chamberId': appointment.scheduleId,
          });
        });
      },
    );

    // _socket.on(
    //   'connect',
    //   (_) async {
    //     print('connect');
    //     SharedPreferences sharedPreferences =
    //         await SharedPreferences.getInstance();
    //     String jwt = sharedPreferences.getString('jwt');
    //
    //       print('join');
    //       _socket.emit('join', {
    //         'token': 'Bearer ' + jwt,
    //         'type': 'doctor',
    //         'chamberId': schedule.id,
    //       });
    //
    //   },
    // );

    _socket.on('msg', (data) {
      signaling.onMessage(data);
    });

    signaling.onSendMessage = (dynamic data) {
      print('sending');
      print(data);
      _socket.emit('msg', data);
    };

    _socket.on('connection', (data) {
      print('connection');
      print(data);
      _chamberBloc.setOnline(data['chamberId']);
    });

    _socket.on('disconnect', (data) {
      print('disconnect');
      print(data);
      if (!(data is String)) {
        _chamberBloc.setOffline(data['chamberId']);
      }
    });

    _socket.on('old_connection', (data) {
      print('old_connection');
      _chamberBloc.setOnline(data['chamberId']);
    });
  }

  void dispose() {
    _socket.dispose();
  }
}
