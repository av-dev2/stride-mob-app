import 'package:intl/intl.dart';

/// Payment Log — maps to Frappe 'Payment Log' doctype.
class PaymentLog {
  final String name;
  final DateTime postingDate;
  final String postingTime;
  final bool reconciled;
  final double paidAmount;
  final String paymentMethod;
  final String paidTo;
  final String description;

  const PaymentLog({
    required this.name,
    required this.postingDate,
    required this.postingTime,
    required this.reconciled,
    required this.paidAmount,
    required this.paymentMethod,
    required this.paidTo,
    required this.description,
  });

  factory PaymentLog.fromJson(Map<String, dynamic> json) {
    return PaymentLog(
      name: json['name'] as String? ?? '',
      postingDate: json['posting_date'] != null
          ? DateTime.parse(json['posting_date'] as String)
          : DateTime.now(),
      postingTime: json['posting_time'] as String? ?? '00:00:00',
      reconciled: (json['reconciled'] as int?) == 1,
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? '',
      paidTo: json['paid_to'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posting_date': DateFormat('yyyy-MM-dd').format(postingDate),
      'posting_time': postingTime,
      'reconciled': reconciled ? 1 : 0,
      'paid_amount': paidAmount,
      'payment_method': paymentMethod,
      'paid_to': paidTo,
      'description': description,
    };
  }
}
