/// Customer — maps to ERPNext 'Customer' doctype.
class Customer {
  final String name;
  final String customerName;
  final String customerType;
  final String? mobileNo;
  final String? emailId;
  final int paymentCount;

  const Customer({
    required this.name,
    required this.customerName,
    required this.customerType,
    this.mobileNo,
    this.emailId,
    this.paymentCount = 0,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      customerType: json['customer_type'] as String? ?? 'Company',
      mobileNo: json['mobile_no'] as String?,
      emailId: json['email_id'] as String?,
      paymentCount: json['payment_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_type': customerType,
      'mobile_no': mobileNo,
      'email_id': emailId,
    };
  }
}
