class Transaction {
  final String appointmentId;
  final String transactionId;
  final double amount;
  final DateTime createdAt;

  Transaction(
      {this.appointmentId, this.transactionId, this.amount, this.createdAt});

  static double _parseDouble(dynamic value) {
    if (value is int) {
      return value + .0;
    }
    return value;
  }

  Transaction.fromJson(Map<String, dynamic> json)
      : appointmentId = json['appointment_id'],
        transactionId = json['transaction_id'],
        createdAt = DateTime.parse(json['createdAt']),
        amount = _parseDouble(json['amount']);

  Map<String, dynamic> toJson() => {
        'appointment_id': appointmentId,
        'transaction_id': transactionId,
        'amount': amount,
      };
}
