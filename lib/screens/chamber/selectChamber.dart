import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/drawer.dart';
import '../../utils.dart';
import '../../routes.dart';
import '../../networking/response.dart';
import '../../widgets/loading.dart';
import '../../blocs/chamber/chamberList.dart';
import '../../models/schedule.dart';

class SelectChamber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/doctor_background_low_opacity.png'),
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
              Icon(Icons.work),
              Text(
                'Chamber',
                style: L,
              ),
            ],
          ),
        ),
        drawer: SafeArea(
          child: MyDrawer(Selected.chamber),
        ),
        body: SafeArea(
          child: Center(
            child: ChangeNotifierProvider(
              create: (context) => ChamberListBloc(),
              child: Builder(
                builder: (context) {
                  ChamberListBloc chamberListBloc =
                      Provider.of<ChamberListBloc>(context);
                  return StreamBuilder(
                    stream: chamberListBloc.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Response<List<Schedule>> response = snapshot.data;
                        switch (response.status) {
                          case Status.LOADING:
                            return Loading(response.message);
                          case Status.COMPLETED:
                            return ListView.builder(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
                              shrinkWrap: true,
                              itemCount: response.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, chamberScreen,
                                            arguments: response.data[index]);
                                      },
                                      leading: Icon(
                                        Icons.work,
                                        size: 40.0,
                                        color: blue,
                                      ),
                                      title: Text(
                                        DateFormat('hh:mm a').format(
                                                response.data[index].start) +
                                            ' - ' +
                                            DateFormat('hh:mm a').format(
                                                response.data[index].end),
                                        textAlign: TextAlign.center,
                                        style: L,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          case Status.ERROR:
                            print(response.message);
                            break;
                        }
                      }
                      return Container();
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
