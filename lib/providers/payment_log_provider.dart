import 'package:flutter/foundation.dart';
import '../models/payment_log.dart';
import '../services/frappe_api.dart';

/// State management for Payment Logs.
class PaymentLogProvider extends ChangeNotifier {
  final FrappeApi _api;

  List<PaymentLog> _logs = [];
  int _totalCount = 0;
  int _reconciledCount = 0;
  int _unreconciledCount = 0;
  bool _isLoading = false;
  String? _error;

  PaymentLogProvider({required FrappeApi api}) : _api = api;

  List<PaymentLog> get logs => _logs;
  int get totalCount => _totalCount;
  int get reconciledCount => _reconciledCount;
  int get unreconciledCount => _unreconciledCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch payment logs with optional reconciled filter.
  Future<void> fetchLogs({bool? reconciled, int limit = 20, int offset = 0}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final filters = <String, dynamic>{};
      if (reconciled != null) {
        filters['reconciled'] = reconciled ? 1 : 0;
      }
      _logs = await _api.getPaymentLogs(
        filters: filters.isNotEmpty ? filters : null,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch counts for reconciled and unreconciled logs.
  Future<void> fetchCounts() async {
    try {
      _reconciledCount = await _api.getPaymentLogCount(reconciled: true);
      _unreconciledCount = await _api.getPaymentLogCount(reconciled: false);
      _totalCount = _reconciledCount + _unreconciledCount;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Mark a payment log as reconciled.
  Future<void> reconcile(String name) async {
    try {
      await _api.reconcilePaymentLog(name);
      final index = _logs.indexWhere((l) => l.name == name);
      if (index != -1) {
        _logs[index] = PaymentLog(
          name: _logs[index].name,
          postingDate: _logs[index].postingDate,
          postingTime: _logs[index].postingTime,
          reconciled: true,
          paidAmount: _logs[index].paidAmount,
          paymentMethod: _logs[index].paymentMethod,
          paidTo: _logs[index].paidTo,
          description: _logs[index].description,
        );
        _reconciledCount++;
        _unreconciledCount--;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
