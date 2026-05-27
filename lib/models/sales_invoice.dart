/// Sales Invoice — for reconciliation dialog.
class SalesInvoice {
  final String name;
  final String customerName;
  final DateTime dueDate;
  final double grandTotal;
  final double outstandingAmount;
  final String status;

  const SalesInvoice({
    required this.name,
    required this.customerName,
    required this.dueDate,
    required this.grandTotal,
    required this.outstandingAmount,
    required this.status,
  });

  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    return SalesInvoice(
      name: json['name'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : DateTime.now(),
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      outstandingAmount: (json['outstanding_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Unpaid',
    );
  }
}
