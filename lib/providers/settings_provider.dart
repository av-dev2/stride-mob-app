import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// State management for app settings.
class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;

  bool _autoSync = true;
  bool _autoReconcile = false;
  bool _notifications = true;

  SettingsProvider({StorageService? storage})
      : _storage = storage ?? StorageService();

  bool get autoSync => _autoSync;
  bool get autoReconcile => _autoReconcile;
  bool get notifications => _notifications;

  /// Load settings from storage.
  Future<void> loadSettings() async {
    _autoSync = await _storage.getAutoSync();
    _autoReconcile = await _storage.getAutoReconcile();
    _notifications = await _storage.getNotifications();
    notifyListeners();
  }

  /// Toggle auto-sync.
  Future<void> setAutoSync(bool value) async {
    _autoSync = value;
    await _storage.setAutoSync(value);
    notifyListeners();
  }

  /// Toggle auto-reconcile.
  Future<void> setAutoReconcile(bool value) async {
    _autoReconcile = value;
    await _storage.setAutoReconcile(value);
    notifyListeners();
  }

  /// Toggle notifications.
  Future<void> setNotifications(bool value) async {
    _notifications = value;
    await _storage.setNotifications(value);
    notifyListeners();
  }
}
