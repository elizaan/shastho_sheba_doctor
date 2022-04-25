import 'package:flutter/material.dart';
import 'package:shastho_sheba_doctor/screens/Registration.dart';

import 'models/doctor.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/schedule.dart';
import 'screens/chamber/selectChamber.dart';
import 'screens/chamber/chamber.dart';
import 'screens/appointmentDetails/details.dart';
import 'screens/showPrescription.dart';
import 'screens/prescription/previewPrescription.dart';
import 'screens/prescription/prescription.dart';
import 'screens/videoCall.dart';
import 'screens/feedback.dart';
import 'screens/transactions.dart';
import 'routes.dart';
import 'utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Doctor doctor;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(color: blue),
          subtitle1: TextStyle(color: blue),
          headline6: TextStyle(color: blue),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: lightBlue,
          actionTextColor: Colors.white,
        ),
      ),
      initialRoute: splashScreen,
      routes: {
        splashScreen: (context) => SplashScreen(),
        loginScreen: (context) => LoginScreen(),
        homeScreen: (context) => HomeScreen(),
        selectChamberScreen: (context) => SelectChamber(),
        scheduleScreen: (context) => ScheduleScreen(),
        chamberScreen: (context) => ChamberScreen(),
        appointmentDetailsScreen: (context) => AppointmentDetails(),
        showPrescriptionScreen: (context) => ShowPrescriptionScreen(),
        previewPrescriptionScreen: (context) => PreviewPrescriptionScreen(),
        feedbackScreen: (context) => FeedbackScreen(),
        addPrescriptionScreen: (context) => AddPrescriptionScreen(),
        videoCallScreen: (context) => VideoCallScreen(),
        profileScreen: (context) => ProfileScreen(),
        transactionsScreen: (context) => TransactionsScreen(),
        registScreen:(context)=> Registration(),
      },
    );
  }
}
