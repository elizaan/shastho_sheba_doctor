import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../blocs/prescription/addPresription.dart';

class AdviseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AddPrescriptionBloc addPrescriptionBloc =
        Provider.of<AddPrescriptionBloc>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            children: <Widget>[
              ...addPrescriptionBloc.advises.map<Container>((advise) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: Text(advise),
                );
              }).toList(),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: addPrescriptionBloc.adviseController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    labelText: 'Advise',
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blue,
                    ),
                    child: FittedBox(
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: addPrescriptionBloc.addAdvise,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: blue,
              child: Text(
                'Preview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ), // <-- Your text.
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  previewPrescriptionScreen,
                  arguments: {
                    'bloc': addPrescriptionBloc,
                  },
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
