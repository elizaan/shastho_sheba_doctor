import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'adviseTab.dart';
import 'medicineTab.dart';
import 'symptomTab.dart';
import 'testTab.dart';
import '../../models/appointment.dart';
import '../../utils.dart';
import '../../widgets/drawer.dart';
import '../../blocs/prescription/addPresription.dart';

class AddPrescriptionScreen extends StatefulWidget {
  AddPrescriptionScreen();
  @override
  _PrescriptionScreenState createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<AddPrescriptionScreen>
    with SingleTickerProviderStateMixin {
  _PrescriptionScreenState();
  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.help_outline),
          //Text('Symptoms'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.healing),
          // Text('Medicines'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.import_contacts),
          //Text('Tests'),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.note),
          //Text('Advises'),
        ],
      ),
    ),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = ModalRoute.of(context).settings.arguments;
    Appointment appointment = map['appointment'];
    String name = map['name'];
    String gender = map['gender'];
    String age = map['age'];

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundimage),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            title: Text('Prescription Form'),
            backgroundColor: lightBlue,
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: myTabs,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                color: Colors.white,
              ),
              labelColor: blue,
              unselectedLabelColor: Colors.white,
            ),
          ),
          drawer: SafeArea(
            child: MyDrawer(Selected.none),
          ),
          body: SafeArea(
            child: ChangeNotifierProvider(
              create: (context) => AddPrescriptionBloc(
                  appointment: appointment,
                  name: name,
                  gender: gender,
                  age: age,
                  weight: map['weight'],
                  bp: map['bp'],
                  temp: map['temp'],
                  bs: map['bs'],
                  pc: map['pc']),
              child: TabBarView(
                controller: _tabController,
                children: [
                  SymptomTab(),
                  MedicineTab(),
                  TestTab(),
                  AdviseTab(),
                ],
              ),
            ),
          ),
        ));
  }
}
