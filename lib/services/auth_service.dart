import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // Use secure storage for token
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _displayNameKey = 'display_name';
  static const _emailKey = 'user_email';

  // Base URL of your API (editable)
  static const String baseUrl = 'https://checklistapi-production.up.railway.app';

  // Returns stored token if any
  Future<String?> getToken() async => _storage.read(key: _tokenKey);

  Future<void> setToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _displayNameKey);
    await _storage.delete(key: _emailKey);
  }

  Future<bool> hasValidToken() async {
    // Minimal check: token presente en almacenamiento
    // (Sin refresco automático ni validación de red, como pediste).
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Si más adelante deseas validarlo con el backend, usa este helper.
  Future<bool> validateTokenWithServer() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    try {
      final resp = await http
          .get(
            Uri.parse('$baseUrl/auth/me.php'),
            headers: {'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 15));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Perform login and store token; returns display name and token
  Future<({String displayName, String? token})> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/login.php');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 50));

    if (response.statusCode != 200) {
      throw Exception('Credenciales inválidas');
    }

    try {
      final data = jsonDecode(response.body);
      final token = data is Map && data['token'] != null ? data['token'].toString() : null;
      if (token != null) await setToken(token);

      String displayName = email;
      if (data is Map && data['user'] is Map) {
        final user = data['user'] as Map;
        final nombre = (user['nombre'] ?? '').toString().trim();
        final apellido = (user['apellido'] ?? '').toString().trim();
        final combined = [nombre, apellido].where((s) => s.isNotEmpty).join(' ');
        if (combined.isNotEmpty) displayName = combined;
      } else {
        // fallback derive name from email local-part
        final at = email.indexOf('@');
        final local = at > 0 ? email.substring(0, at) : email;
        displayName = local
            .split(RegExp(r'[._\-]'))
            .where((s) => s.isNotEmpty)
            .map((s) => s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : ''))
            .join(' ');
      }
  // Persist friendly name and email para posteriores pantallas
  await _storage.write(key: _displayNameKey, value: displayName);
  await _storage.write(key: _emailKey, value: email);
  return (displayName: displayName, token: token);
    } catch (e) {
      if (kDebugMode) {
        print('Login parse error: $e');
      }
      throw Exception('Respuesta inesperada del servidor');
    }
  }

  // Example protected GET call
  Future<http.Response> getProtected(String path) async {
    final token = await getToken();
    final uri = Uri.parse('$baseUrl$path');
    return http.get(uri, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
    });
  }

  Future<String?> getDisplayName() => _storage.read(key: _displayNameKey);
  Future<String?> getEmail() => _storage.read(key: _emailKey);
}
