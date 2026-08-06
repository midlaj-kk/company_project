import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around shared_preferences so the rest of the app
/// never touches the storage package directly.
///
/// NOTE: shared_preferences stores data in plain text on device,
/// unlike flutter_secure_storage. This is fine for development.
/// Before shipping to production, consider re-introducing
/// flutter_secure_storage (or an equivalent) once its native
/// build issue is resolved on your machine.
class SecureStorage {
  SecureStorage._internal();
  static final SecureStorage instance = SecureStorage._internal();
  factory SecureStorage() => instance;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userRoleKey = 'user_role';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userRoleKey);
  }
}