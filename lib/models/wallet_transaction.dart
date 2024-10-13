class WalletTransaction {
  final String? id;
  final TransactionType? transactionType;
  final int? amount;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletTransaction({
    this.id,
    this.transactionType,
    this.amount,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      transactionType:
          TransactionTypeExtension.fromName(json['transaction_type']),
      amount: json['amount'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

enum TransactionType {
  deposit,
  withdrawal,
  unknown,
}

extension TransactionTypeExtension on TransactionType {
  String get name {
    switch (this) {
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      default:
        return 'Unknown';
    }
  }

  static TransactionType fromName(String name) {
    switch (name) {
      case 'DEPOSITE':
        return TransactionType.deposit;
      case 'WITHDRAW':
        return TransactionType.withdrawal;
    }
    return TransactionType.unknown;
  }
}
