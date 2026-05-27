import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../services/frappe_api.dart';

/// State management for Customers.
class CustomerProvider extends ChangeNotifier {
  final FrappeApi _api;

  List<Customer> _customers = [];
  int _totalCount = 0;
  bool _isLoading = false;
  String? _error;

  CustomerProvider({required FrappeApi api}) : _api = api;

  List<Customer> get customers => _customers;
  int get totalCount => _totalCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch all customers.
  Future<void> fetchCustomers({String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _customers = await _api.getCustomers(search: search);
      _totalCount = _customers.length;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
