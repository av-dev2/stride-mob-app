import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_log.dart';
import '../models/customer.dart';
import '../models/sales_invoice.dart';

/// Frappe REST API client for Stride.
///
/// Uses token-based auth: `Authorization: token api_key:api_secret`
///
/// When connecting from an Android emulator, the site hostname (e.g., 'rental')
/// may not be resolvable. Use the host machine's IP address as the Site URL
/// and optionally provide the original hostname so it's sent as a Host header
/// for nginx routing.
class FrappeApi {
  String? _siteUrl;
  String? _apiToken;
  String? _hostHeader;

  void configure({required String siteUrl, required String apiToken, String? hostHeader}) {
    _siteUrl = siteUrl.endsWith('/') ? siteUrl.substring(0, siteUrl.length - 1) : siteUrl;
    _apiToken = apiToken;
    _hostHeader = hostHeader;
  }

  bool get isConfigured => _siteUrl != null && _apiToken != null;

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Authorization': 'token $_apiToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_hostHeader != null && _hostHeader!.isNotEmpty) {
      headers['Host'] = _hostHeader!;
    }
    return headers;
  }

  /// Test the connection to the Frappe site.
  Future<String> testConnection() async {
    final response = await http.get(
      Uri.parse('$_siteUrl/api/method/frappe.auth.get_logged_user'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['message'] as String? ?? 'Connected';
    }
    throw Exception('Connection failed: ${response.statusCode}');
  }

  /// Fetch payment logs with optional filters.
  Future<List<PaymentLog>> getPaymentLogs({
    Map<String, dynamic>? filters,
    String orderBy = 'posting_date desc',
    int limit = 20,
    int offset = 0,
  }) async {
    final params = <String, String>{
      'doctype': 'Payment Log',
      'fields': '["name","posting_date","posting_time","reconciled","paid_amount","payment_method","paid_to","description"]',
      'order_by': orderBy,
      'limit_page_length': '$limit',
      'limit_start': '$offset',
    };
    if (filters != null) {
      params['filters'] = json.encode(filters);
    }
    final response = await http.get(
      Uri.parse('$_siteUrl/api/resource/Payment Log').replace(queryParameters: params),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['data'] as List<dynamic>;
      return list.map((e) => PaymentLog.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch payment logs: ${response.statusCode}');
  }

  /// Get count of payment logs, optionally filtered by reconciled status.
  Future<int> getPaymentLogCount({bool? reconciled}) async {
    final filters = <String, dynamic>{};
    if (reconciled != null) {
      filters['reconciled'] = reconciled ? 1 : 0;
    }
    final params = <String, String>{
      'doctype': 'Payment Log',
      'limit_page_length': '0',
    };
    if (filters.isNotEmpty) {
      params['filters'] = json.encode(filters);
    }
    final response = await http.get(
      Uri.parse('$_siteUrl/api/method/frappe.client.get_count').replace(
        queryParameters: params,
      ),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['message'] as num?)?.toInt() ?? 0;
    }
    throw Exception('Failed to fetch count: ${response.statusCode}');
  }

  /// Fetch customers.
  Future<List<Customer>> getCustomers({
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    final params = <String, String>{
      'doctype': 'Customer',
      'fields': '["name","customer_name","customer_type","mobile_no","email_id"]',
      'order_by': 'customer_name asc',
      'limit_page_length': '$limit',
      'limit_start': '$offset',
    };
    if (search != null && search.isNotEmpty) {
      params['filters'] = json.encode([['customer_name', 'like', '%$search%']]);
    }
    final response = await http.get(
      Uri.parse('$_siteUrl/api/resource/Customer').replace(queryParameters: params),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['data'] as List<dynamic>;
      return list.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch customers: ${response.statusCode}');
  }

  /// Fetch outstanding sales invoices for a customer.
  Future<List<SalesInvoice>> getOutstandingSalesInvoices({
    String? customer,
  }) async {
    final filters = [
      ['outstanding_amount', '>', 0],
      ['docstatus', '=', 1],
    ];
    if (customer != null) {
      filters.add(['customer', '=', customer]);
    }
    final params = <String, String>{
      'doctype': 'Sales Invoice',
      'fields': '["name","customer_name","due_date","grand_total","outstanding_amount","status"]',
      'filters': json.encode(filters),
      'order_by': 'due_date asc',
      'limit_page_length': '20',
    };
    final response = await http.get(
      Uri.parse('$_siteUrl/api/resource/Sales Invoice').replace(queryParameters: params),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['data'] as List<dynamic>;
      return list.map((e) => SalesInvoice.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch invoices: ${response.statusCode}');
  }

  /// Create a new Payment Log.
  Future<PaymentLog> createPaymentLog(PaymentLog log) async {
    final response = await http.post(
      Uri.parse('$_siteUrl/api/resource/Payment Log'),
      headers: _headers,
      body: json.encode({'data': log.toJson()}),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PaymentLog.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Failed to create payment log: ${response.statusCode}');
  }

  /// Mark a payment log as reconciled.
  Future<void> reconcilePaymentLog(String name) async {
    final response = await http.put(
      Uri.parse('$_siteUrl/api/resource/Payment Log/$name'),
      headers: _headers,
      body: json.encode({'reconciled': 1}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reconcile: ${response.statusCode}');
    }
  }
}
