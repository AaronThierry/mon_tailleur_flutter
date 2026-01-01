import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class HttpService {
  static const String _tokenKey = 'auth_token';

  // Sauvegarder le token d'authentification
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Récupérer le token d'authentification
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Supprimer le token d'authentification
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Obtenir les headers avec le token d'authentification
  Future<Map<String, String>> _getHeaders() async {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    final token = await getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Requête GET
  Future<http.Response> get(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders();

      final response = await http.get(url, headers: headers)
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Requête POST
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders();

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Requête PUT
  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders();

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Requête DELETE
  Future<http.Response> delete(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      final headers = await _getHeaders();

      final response = await http.delete(url, headers: headers)
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Gérer la réponse HTTP
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      // Token expiré ou invalide
      deleteToken();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else if (response.statusCode == 403) {
      throw Exception('Accès refusé.');
    } else if (response.statusCode == 404) {
      throw Exception('Ressource non trouvée.');
    } else if (response.statusCode >= 500) {
      throw Exception('Erreur serveur. Veuillez réessayer plus tard.');
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Une erreur est survenue.');
    }
  }

  // Gérer les erreurs
  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('Erreur de connexion. Vérifiez votre connexion internet.');
  }
}