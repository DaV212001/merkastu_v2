//{
//             "id": "72154904-5b00-4709-bf07-061c50488f21",
//             "amount": 2,
//             "decline_reason": null,
//             "receipt": null,
//             "payment_method": "TELEBIRR",
//             "payment_account": "0944070484",
//             "status": "PENDING"
//         }

import '../utils/payment_methods.dart';

enum WalletWithdrawalStatus { DECLINED, PENDING, TRANSFERRED }

extension WalletWithdrawalStatusExtension on WalletWithdrawalStatus {
  String get name {
    switch (this) {
      case WalletWithdrawalStatus.DECLINED:
        return 'Declined';
      case WalletWithdrawalStatus.PENDING:
        return 'Pending';
      case WalletWithdrawalStatus.TRANSFERRED:
        return 'Transferred';
    }
  }

  static WalletWithdrawalStatus fromName(String name) {
    switch (name) {
      case 'Declined':
        return WalletWithdrawalStatus.DECLINED;
      case 'Pending':
        return WalletWithdrawalStatus.PENDING;
      case 'Transferred':
        return WalletWithdrawalStatus.TRANSFERRED;
      default:
        return WalletWithdrawalStatus.PENDING;
    }
  }
}

class WithdrawalRequest {
  final String? id;
  final int? amount;
  final String? declineReason;
  final String? receipt;
  final PaymentMethod? paymentMethod;
  final String? paymentAccount;
  final WalletWithdrawalStatus? status;

  WithdrawalRequest({
    this.id,
    this.amount,
    this.declineReason,
    this.receipt,
    this.paymentMethod,
    this.paymentAccount,
    this.status,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['id'],
      amount: json['amount'],
      declineReason: json['decline_reason'],
      receipt: json['receipt'],
      paymentMethod: PaymentMethodExtension.fromName(json['payment_method']),
      paymentAccount: json['payment_account'],
      status: WalletWithdrawalStatusExtension.fromName(json['status']),
    );
  }
}
