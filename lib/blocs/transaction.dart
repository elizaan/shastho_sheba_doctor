import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'baseBloc.dart';
import '../models/transaction.dart';
import '../networking/response.dart';
import '../repositories/transaction.dart';

class TransactionBloc extends ChangeNotifier implements BaseBloc {
  TransactionRepository _transactionRepository;
  StreamController _transactionController;
  List<Transaction> _transactionList;
  String _appointmentId;
  double due;
  double total;
  double fee;
  bool _verified;

  StreamSink<Response<List<Transaction>>> get sink =>
      _transactionController.sink;

  Stream<Response<List<Transaction>>> get stream =>
      _transactionController.stream;

  bool get verified => _verified;

  set verified(bool value) {
    _verified = value;
    notifyListeners();
  }

  TransactionBloc(this._appointmentId, this._verified, {this.due, this.fee}) {
    assert(due == null && fee != null || due != null && fee == null);
    _transactionRepository = TransactionRepository();
    _transactionController = StreamController<Response<List<Transaction>>>();
    fetchTransactions();
  }

  void fetchTransactions() async {
    sink.add(Response.loading('Fetching Transactions'));
    try {
      _transactionList =
          await _transactionRepository.getTransactions(_appointmentId);
      total = 0.0;
      _transactionList.forEach((element) => total = total + element.amount);
      if (due == null) {
        due = fee - total;
      } else if (fee == null) {
        fee = total + due;
      }
      sink.add(Response.completed(_transactionList));
    } catch (e) {
      sink.add(Response.error(e.toString()));
    }
  }

  Future<void> verifyTransactions(String appointmentId) async {
    await _transactionRepository.verifyTransactions(appointmentId);
  }

  Future<void> cancelVerification(String appointmentId) async {
    await _transactionRepository.cancelVerification(appointmentId);
  }

  @override
  void dispose() {
    _transactionController?.close();
    super.dispose();
  }
}
