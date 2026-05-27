import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persistent storage for app settings and credentials.
class StorageService {
  static const _keySiteUrl = 'stride_site_url';
  static const _keyApiToken = 'stride_api_token';
  static const _keyAutoSync = 'stride_auto_sync';
  static const _keyAutoReconcile = 'stride_auto_reconcile';
  static const _keyNotifications = 'stride_notifications';
  static const _keyOnboarded = 'stride_onboarded';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // === Credentials ===

  Future<String?> getSiteUrl() async {
    return (await _prefs).getString(_keySiteUrl);
  }

  Future<void> setSiteUrl(String url) async {
    (await _prefs).setString(_keySiteUrl, url);
  }

  Future<String?> getApiToken() async {
    return _secureStorage.read(key: _keyApiToken);
  }

  Future<void> setApiToken(String token) async {
    await _secureStorage.write(key: _keyApiToken, value: token);
  }

  // === Settings ===

  Future<bool> getAutoSync() async {
    return (await _prefs).getBool(_keyAutoSync) ?? true;
  }

  Future<void> setAutoSync(bool value) async {
    (await _prefs).setBool(_keyAutoSync, value);
  }

  Future<bool> getAutoReconcile() async {
    return (await _prefs).getBool(_keyAutoReconcile) ?? false;
  }

  Future<void> setAutoReconcile(bool value) async {
    (await _prefs).setBool(_keyAutoReconcile, value);
  }

  Future<bool> getNotifications() async {
    return (await _prefs).getBool(_keyNotifications) ?? true;
  }

  Future<void> setNotifications(bool value) async {
    (await _prefs).setBool(_keyNotifications, value);
  }

  // === Onboarding ===

  Future<bool> isOnboarded() async {
    return (await _prefs).getBool(_keyOnboarded) ?? false;
  }

  Future<void> setOnboarded(bool value) async {
    (await _prefs).setBool(_keyOnboarded, value);
  }

  // === Clear ===

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
    await _secureStorage.deleteAll();
  }
}
