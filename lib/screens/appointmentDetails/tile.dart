import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils.dart';
import '../../models/appointment.dart';

class Tile extends StatelessWidget {
  final Appointment appointment;
  final void Function() onCancelAppointment;
  final void Function() onViewTransactions;
  final void Function() onShowPrescription;

  final double _iconSize = 35.0;

  Tile({
    this.appointment,
    this.onCancelAppointment,
    this.onViewTransactions,
    this.onShowPrescription,
  });

  @override
  Widget build(BuildContext context) {
    final String assetName = 'images/icons/taka.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      height: 5,
      width: 5,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Text(
            DateFormat('MMM dd\nyyyy').format(appointment.dateTime),
            textAlign: TextAlign.center,
            style: XS,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (appointment.status == AppointmentStatus.NotVerified)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'There is '),
                            TextSpan(
                              text: '${appointment.due}',
                              style: TextStyle(
                                color: appointment.due > 0 ? red : mint,
                              ),
                            ),
                            TextSpan(text: '/- due.'),
                          ],
                          style: M.copyWith(color: Colors.white),
                        ),
                      ),
                      // if (appointment.status == AppointmentStatus.NoPayment)
                      //   Container(
                      //     height: _iconSize,
                      //     width: _iconSize,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.white,
                      //     ),
                      //     child: FittedBox(
                      //       child: IconButton(
                      //         icon: Icon(
                      //           Icons.delete,
                      //           size: _iconSize - 5,
                      //         ),
                      //         color: red,
                      //         onPressed: onCancelAppointment,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.0),
                          height: _iconSize,
                          width: _iconSize,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: FittedBox(
                            child: GestureDetector(
                              onTap: onViewTransactions,
                              child: svg,
                            ),
                          ),
                        ),
                        Text(
                          'Transactions',
                          style: XS.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (appointment.status == AppointmentStatus.Finished)
                      SizedBox(
                        width: 5.0,
                      ),
                    if (appointment.status == AppointmentStatus.Finished)
                      Column(
                        children: [
                          Container(
                            height: _iconSize,
                            width: _iconSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: FittedBox(
                              child: IconButton(
                                icon: Icon(
                                  Icons.content_paste,
                                  size: _iconSize - 5,
                                ),
                                color: blue,
                                onPressed: onShowPrescription,
                              ),
                            ),
                          ),
                          Text(
                            'Prescription',
                            style: XS.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    // SizedBox(
                    //   width: 15.0,
                    // ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       height: _iconSize,
                    //       width: _iconSize,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.grey,
                    //       ),
                    //       child: FittedBox(
                    //         child: IconButton(
                    //           icon: Icon(
                    //             Icons.file_upload,
                    //             size: _iconSize-5,
                    //           ),
                    //           color: blue,
                    //           onPressed: null,
                    //         ),
                    //       ),
                    //     ),
                    //     Text(
                    //       'Report',
                    //       style: XS.copyWith(
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Spacer(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Created on ${DateFormat.yMMMMd('en_US').format(appointment.createdAt)}',
                    style: XS.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
