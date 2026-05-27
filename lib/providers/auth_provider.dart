import 'package:flutter/foundation.dart';
import '../services/frappe_api.dart';
import '../services/storage_service.dart';

/// Manages Frappe connection state and credentials.
///
/// When connecting from Android emulators, the site hostname (e.g., 'rental')
/// isn't resolvable. The user enters the IP-based URL (e.g., http://192.168.0.90:8001)
/// and sets the site hostname separately. The hostname is sent as a Host header
/// so Frappe's nginx routes the request correctly.
class AuthProvider extends ChangeNotifier {
  final FrappeApi _api;
  final StorageService _storage;

  String _siteUrl = '';
  String _apiToken = '';
  String _siteHostname = '';
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
  String get siteHostname => _siteHostname;
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
    _siteHostname = (await _storage.getSiteHostname()) ?? '';
    _isOnboarded = await _storage.isOnboarded();
    if (_siteUrl.isNotEmpty && _apiToken.isNotEmpty) {
      _api.configure(
        siteUrl: _siteUrl,
        apiToken: _apiToken,
        hostHeader: _siteHostname.isNotEmpty ? _siteHostname : null,
      );
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
      _api.configure(
        siteUrl: siteUrl,
        apiToken: apiToken,
        hostHeader: _siteHostname.isNotEmpty ? _siteHostname : null,
      );
      _connectedUser = await _api.testConnection();
      _isConnected = true;
      await _storage.setSiteUrl(siteUrl);
      await _storage.setApiToken(apiToken);
      await _storage.setSiteHostname(_siteHostname);
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
      _api.configure(
        siteUrl: _siteUrl,
        apiToken: _apiToken,
        hostHeader: _siteHostname.isNotEmpty ? _siteHostname : null,
      );
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

  void updateSiteHostname(String hostname) {
    _siteHostname = hostname;
  }
}
