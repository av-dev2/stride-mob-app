import 'package:flutter/foundation.dart';
import '../services/frappe_api.dart';
import '../services/storage_service.dart';

/// Manages Frappe connection state and credentials.
class AuthProvider extends ChangeNotifier {
  final FrappeApi _api;
  final StorageService _storage;

  String _siteUrl = '';
  String _apiToken = '';
  bool _isConnected = false;
  bool _isLoading = false;
  bool _isOnboarded = false;
  String? _error;
  String? _connectedUser;

  AuthProvider({FrappeApi? api, StorageService? storage})
      : _api = api ?? FrappeApi(),
        _storage = storage ?? StorageService();

  String get siteUrl => _siteUrl;
  String get apiToken => _apiToken;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  bool get isOnboarded => _isOnboarded;
  String? get error => _error;
  String? get connectedUser => _connectedUser;
  FrappeApi get api => _api;

  /// Load saved credentials from storage.
  Future<void> loadCredentials() async {
    _siteUrl = (await _storage.getSiteUrl()) ?? '';
    _apiToken = (await _storage.getApiToken()) ?? '';
    _isOnboarded = await _storage.isOnboarded();
    if (_siteUrl.isNotEmpty && _apiToken.isNotEmpty) {
      _api.configure(siteUrl: _siteUrl, apiToken: _apiToken);
      try {
        _connectedUser = await _api.testConnection();
        _isConnected = true;
      } catch (_) {
        _isConnected = false;
      }
    }
    notifyListeners();
  }

  /// Save credentials and test connection.
  Future<bool> saveAndTest(String siteUrl, String apiToken) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _siteUrl = siteUrl;
      _apiToken = apiToken;
      _api.configure(siteUrl: siteUrl, apiToken: apiToken);
      _connectedUser = await _api.testConnection();
      _isConnected = true;
      await _storage.setSiteUrl(siteUrl);
      await _storage.setApiToken(apiToken);
      await _storage.setOnboarded(true);
      _isOnboarded = true;
    } catch (e) {
      _isConnected = false;
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return _isConnected;
  }

  /// Test connection without saving.
  Future<bool> testConnection() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_siteUrl.isEmpty || _apiToken.isEmpty) {
        throw Exception('Site URL and API Token are required');
      }
      _api.configure(siteUrl: _siteUrl, apiToken: _apiToken);
      _connectedUser = await _api.testConnection();
      _isConnected = true;
    } catch (e) {
      _isConnected = false;
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return _isConnected;
  }

  void updateSiteUrl(String url) {
    _siteUrl = url;
  }

  void updateApiToken(String token) {
    _apiToken = token;
  }
}
