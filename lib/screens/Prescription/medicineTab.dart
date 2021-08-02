import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';
import '../../routes.dart';
import '../../blocs/prescription/addPresription.dart';

class MedicineTab extends StatelessWidget {
  final double cellPadding = 10.0;
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
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(3.0),
                  1: FlexColumnWidth(3.0),
                  2: FlexColumnWidth(1.0),
                },
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(cellPadding),
                        child: Text(
                          'Name',
                          style: M,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(cellPadding),
                        child: Text(
                          'Dose',
                          style: M,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(cellPadding),
                        child: Text(
                          'Day',
                          style: M,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  ...addPrescriptionBloc.medicines
                      .asMap()
                      .map<int, TableRow>((index, medicine) {
                        return MapEntry(
                          index,
                          TableRow(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  '${medicine.name}',
                                  style: M,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  medicine.dose,
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(cellPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  medicine.days,
                                  style: M,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .values
                      .toList(),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        child: TextFormField(
                          controller: addPrescriptionBloc.medicineController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'Medicine',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: TextFormField(
                          controller: addPrescriptionBloc.dosageController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'Dose',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: addPrescriptionBloc.durationController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          labelText: 'Day',
                        ),
                      ),
                    ),
                  ],
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
                        onPressed: addPrescriptionBloc.addMedicine,
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
