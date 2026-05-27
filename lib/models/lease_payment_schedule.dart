/// Lease Payment Schedule — child table of Lease doctype.
class LeasePaymentSchedule {
  final String name;
  final int period;
  final DateTime fromDate;
  final DateTime toDate;
  final DateTime dueDate;
  final double amount;
  final String status;
  final String? salesInvoice;
  final String? paymentEntry;
  final String? parent;

  const LeasePaymentSchedule({
    required this.name,
    required this.period,
    required this.fromDate,
    required this.toDate,
    required this.dueDate,
    required this.amount,
    required this.status,
    this.salesInvoice,
    this.paymentEntry,
    this.parent,
  });

  factory LeasePaymentSchedule.fromJson(Map<String, dynamic> json) {
    return LeasePaymentSchedule(
      name: json['name'] as String? ?? '',
      period: json['period'] as int? ?? 0,
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Pending',
      salesInvoice: json['sales_invoice'] as String?,
      paymentEntry: json['payment_entry'] as String?,
      parent: json['parent'] as String?,
    );
  }
}
