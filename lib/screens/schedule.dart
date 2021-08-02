import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils.dart';
import '../widgets/drawer.dart';
import '../blocs/schedule.dart';
import '../models/schedule.dart';
import '../networking/response.dart';
import '../repositories/schedule.dart';
import '../routes.dart';
import '../widgets/loading.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: lightBlue,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule),
              Text(
                'Schedule',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.schedule),
        ),
        body: SafeArea(
          child: Center(
            child: ChangeNotifierProvider(
              create: (context) => ScheduleBloc(),
              child: Builder(
                builder: (context) {
                  ScheduleBloc scheduleBloc =
                      Provider.of<ScheduleBloc>(context);
                  return StreamBuilder(
                    stream: scheduleBloc.scheduleStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<List<Schedule>> data = snapshot.data;
                        switch (data.status) {
                          case Status.LOADING:
                            return Loading(data.message);
                          case Status.COMPLETED:
                            return _ScheduleScreen(data.data);
                            break;
                          case Status.ERROR:
                            scheduleBloc.errorMessage = data.message;
                            break;
                        }
                      }
                      return _ScheduleScreen(List<Schedule>());
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleScreen extends StatelessWidget {
  final List<Schedule> schedules;
  _ScheduleScreen(this.schedules);
  final Map<int, String> _map = {
    1: 'Monday',
    2: 'Tuesday',
    3: 'Wednesday',
    4: 'Thursday',
    5: 'Friday',
    6: 'Saturday',
    7: 'Sunday'
  };

  @override
  Widget build(BuildContext context) {
    List<List<Schedule>> scheduleList = List<List<Schedule>>(7);
    for (int i = 0; i < 7; i++) {
      scheduleList[i] = List<Schedule>();
    }
    if (schedules != null) {
      for (int i = 0; i < schedules.length; i++) {
        scheduleList[schedules[i].weekDay - 1].add(schedules[i]);
        //print(schedules[i].weekDay);
      }
    }
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
      itemCount: 7,
      itemBuilder: (context, index) {
        return _Expandable(_map[index + 1], scheduleList[index], index + 1);
      },
    );
  }
}

class _Expandable extends StatefulWidget {
  final String dayName;
  final List<Schedule> schedules;
  final int weekDay;
  _Expandable(this.dayName, this.schedules, this.weekDay);
  @override
  _ExpandableState createState() =>
      _ExpandableState(this.dayName, this.schedules, this.weekDay);
}

class _ExpandableState extends State<_Expandable> {
  final String dayName;
  final List<Schedule> schedules;
  final int weekDay;
  _ExpandableState(this.dayName, this.schedules, this.weekDay);

  Future<void> _deleteDialog(BuildContext context, Schedule schedule) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmation',
            style: L.copyWith(color: blue),
          ),
          content: Text('Would you like to delete this schedule?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                ScheduleRepository scheduleRepository = ScheduleRepository();
                try {
                  await scheduleRepository.deleteSchedule(schedule.id);
                } catch (error) {
                  Fluttertoast.showToast(
                      msg: "Error occurred.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                Navigator.of(context).pushNamedAndRemoveUntil(scheduleScreen,
                    (Route<dynamic> route) {
                  bool shouldPop = false;
                  if (route.settings.name == homeScreen) {
                    shouldPop = true;
                  }
                  return shouldPop;
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editDialog(BuildContext context, Schedule schedule) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit a schedule', style: L.copyWith(color: blue)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '1000.0',
                    labelText: 'Fee',
                  ),
                  validator: (value) {
                    if (value.isEmpty || double.parse(value) < 0) {
                      return 'Please enter fee';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '100',
                    labelText: 'Patient Limit',
                  ),
                  validator: (value) {
                    if (value.isEmpty || int.parse(value) <= 0) {
                      return 'Please enter patient limit';
                    }
                    return null;
                  },
                ),
                TimePickerFormField(
                  format: timeFormat,
                  initialTime: startTime,
                  decoration: InputDecoration(labelText: 'Start Time'),
                  onChanged: (t) => setState(() => startTime = t),
                ),
                TimePickerFormField(
                  format: timeFormat,
                  initialTime: endTime,
                  decoration: InputDecoration(labelText: 'End Time'),
                  onChanged: (t) => setState(() => endTime = t),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                if (DateTime(2020, 1, 1, endTime.hour, endTime.minute)
                        .difference(DateTime(
                            2020, 1, 1, startTime.hour, startTime.minute))
                        .inSeconds <
                    0) {
                  Fluttertoast.showToast(
                      msg: "Ending time is lower than starting time.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                if (_limitController.text.length != 0 &&
                    int.parse(_limitController.text) <= 0) {
                  Fluttertoast.showToast(
                      msg: "Patient limit can not be negative.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                if (_feeController.text.length != 0 &&
                    double.parse(_feeController.text) < 0) {
                  Fluttertoast.showToast(
                      msg: "Fee can not be negative.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM);
                  return;
                }

                ScheduleRepository scheduleRepository = ScheduleRepository();
                try {
                  await scheduleRepository.editSchedule(Schedule(
                      id: schedule.id,
                      fee: double.parse(_feeController.text),
                      limit: int.parse(_limitController.text),
                      weekDay: schedule.weekDay,
                      start: DateTime(
                          2020, 1, 1, startTime.hour, startTime.minute),
                      end: DateTime(2020, 1, 1, endTime.hour, endTime.minute)));
                } catch (error) {
                  Fluttertoast.showToast(
                      msg: "Error occurred.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                Navigator.of(context).pushNamedAndRemoveUntil(scheduleScreen,
                    (Route<dynamic> route) {
                  bool shouldPop = false;
                  if (route.settings.name == homeScreen) {
                    shouldPop = true;
                  }
                  return shouldPop;
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final timeFormat = DateFormat("h:mm a");
  TimeOfDay startTime;
  TimeOfDay endTime;
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  Future<void> _addScheduleDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new schedule', style: L.copyWith(color: blue)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '1000',
                    labelText: 'Fee',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter fee';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '100',
                    labelText: 'Patient Limit',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter patient limit';
                    }
                    return null;
                  },
                ),
                TimePickerFormField(
                  format: timeFormat,
                  initialTime: startTime,
                  decoration: InputDecoration(labelText: 'Start Time'),
                  onChanged: (t) => setState(() => startTime = t),
                ),
                TimePickerFormField(
                  format: timeFormat,
                  initialTime: endTime,
                  decoration: InputDecoration(labelText: 'End Time'),
                  onChanged: (t) => setState(() => endTime = t),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Update',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                if (DateTime(2020, 1, 1, endTime.hour, endTime.minute)
                        .difference(DateTime(
                            2020, 1, 1, startTime.hour, startTime.minute))
                        .inSeconds <
                    0) {
                  Fluttertoast.showToast(
                      msg: "Ending time is lower than starting time.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                if (_limitController.text.length != 0 &&
                    int.parse(_limitController.text) <= 0) {
                  Fluttertoast.showToast(
                      msg: "Patient limit can not be negative.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                if (_feeController.text.length != 0 &&
                    double.parse(_feeController.text) < 0) {
                  Fluttertoast.showToast(
                      msg: "Fee can not be negative.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                ScheduleRepository scheduleRepository = ScheduleRepository();
                try {
                  await scheduleRepository.addSchedule(Schedule(
                      id: null,
                      fee: double.parse(_feeController.text),
                      limit: int.parse(_limitController.text),
                      weekDay: weekDay,
                      start: DateTime(
                          2020, 1, 1, startTime.hour, startTime.minute),
                      end: DateTime(2020, 1, 1, endTime.hour, endTime.minute)));
                } catch (error) {
                  Fluttertoast.showToast(
                      msg: "Error occurred.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity
                          .BOTTOM // also possible "TOP" and "CENTER"
                      );
                  return;
                }
                Navigator.of(context).pushNamedAndRemoveUntil(scheduleScreen,
                    (Route<dynamic> route) {
                  bool shouldPop = false;
                  if (route.settings.name == homeScreen) {
                    shouldPop = true;
                  }
                  return shouldPop;
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _buildItem(int serial, Schedule schedule, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$serial. " +
              DateFormat('hh:mm:a').format(schedule.start) +
              " - " +
              DateFormat('hh:mm:a').format(schedule.end),
          textAlign: TextAlign.left,
          style: M.copyWith(
            color: Colors.white,
          ),
        ),
        Expanded(child: SizedBox()),
        Container(
          height: 30.0,
          width: 30.0,
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: FittedBox(
            child: IconButton(
              icon: Icon(
                Icons.edit,
              ),
              color: blue,
              onPressed: () {
                _feeController.text = schedule.fee.toString();
                _limitController.text = schedule.limit.toString();
                startTime = TimeOfDay(
                    hour: schedule.start.hour, minute: schedule.start.minute);
                endTime = TimeOfDay(
                    hour: schedule.end.hour, minute: schedule.end.minute);
                _editDialog(context, schedule);
              },
            ),
          ),
        ),
        Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: FittedBox(
            child: IconButton(
              icon: Icon(
                Icons.delete,
              ),
              color: red,
              onPressed: () {
                _feeController.text = schedule.fee.toString();
                _limitController.text = schedule.limit.toString();
                startTime = TimeOfDay(
                    hour: schedule.start.hour, minute: schedule.start.minute);
                endTime = TimeOfDay(
                    hour: schedule.end.hour, minute: schedule.end.minute);
                _deleteDialog(context, schedule);
              },
            ),
          ),
        ),
      ],
    );
  }

  _buildList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          if (schedules != null)
            for (int i = 0; i < schedules.length; i++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: _buildItem(i + 1, schedules[i], context),
              ),
          //_buildItem("2. 1.00PM-2.00PM"),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: FittedBox(
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: blue,
                  ),
                  onPressed: () {
                    startTime = TimeOfDay.now();
                    endTime = TimeOfDay.now();
                    _addScheduleDialog(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: schedules.length < 1 ? lightRed : lightBlue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: ExpandablePanel(
          header: Text(
            this.dayName,
            style: L.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          collapsed: Text(
            schedules.length <= 1
                ? schedules.length.toString() + " schedule"
                : schedules.length.toString() + " schedules",
            style: TextStyle(
              color: Colors.white,
            ),
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          expanded: _buildList(context),
          theme: ExpandableThemeData(
            iconColor: schedules.length < 1 ? red : blue,
            tapBodyToExpand: true,
          ),
          //tapHeaderToExpand: true,
          // hasIcon: true,
        ),
      ),
    );
  }
}
