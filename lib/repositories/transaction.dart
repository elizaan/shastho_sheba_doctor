import '../models/transaction.dart';
import '../networking/api.dart';

class TransactionRepository {
  Api _api = Api();

  Future<List<Transaction>> getTransactions(String appointmentId) async {
    final data = await _api.post(
        '/doctor/get/transaction/', true, {"appointment_id": appointmentId});
    return data['transactions']
        .map<Transaction>((json) => Transaction.fromJson(json))
        .toList();
  }

  Future<void> updateTransaction(String appointmentId, int status) async {
    await _api.post('/doctor/update/appointment', true,
        {"appointment_id": appointmentId, "status": status});
  }

  Future<void> verifyTransactions(String appointmentId) async {
    await _api.post('/doctor/update/appointment', true,
        {"appointment_id": appointmentId, "status": 2});
  }

  Future<void> cancelVerification(String appointmentId) async {
    await _api.post('/doctor/update/appointment', true,
        {"appointment_id": appointmentId, "status": 1});
  }
}
