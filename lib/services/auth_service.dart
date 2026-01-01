import 'dart:convert';
import '../config/api_config.dart';
import '../models/user.dart';
import 'http_service.dart';

class AuthService {
  final HttpService _httpService = HttpService();

  // Connexion
  Future<User> login(String email, String password) async {
    try {
      final response = await _httpService.post(
        ApiConfig.authLoginEndpoint,
        {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      // Sauvegarder le token
      if (data['token'] != null) {
        await _httpService.saveToken(data['token']);
      }

      // Retourner l'utilisateur
      return User.fromJson(data['user']);
    } catch (e) {
      throw Exception('Échec de la connexion: ${e.toString()}');
    }
  }

  // Inscription
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? role,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      // Ajouter le rôle seulement s'il est fourni
      if (role != null) {
        body['role'] = role;
      }

      final response = await _httpService.post(
        ApiConfig.authRegisterEndpoint,
        body,
      );

      final data = jsonDecode(response.body);

      // Sauvegarder le token
      if (data['token'] != null) {
        await _httpService.saveToken(data['token']);
      }

      // Retourner l'utilisateur
      return User.fromJson(data['user']);
    } catch (e) {
      throw Exception('Échec de l\'inscription: ${e.toString()}');
    }
  }

  // Récupérer l'utilisateur connecté
  Future<User> getCurrentUser() async {
    try {
      final response = await _httpService.get(ApiConfig.authMeEndpoint);
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } catch (e) {
      throw Exception('Impossible de récupérer l\'utilisateur: ${e.toString()}');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      await _httpService.post(ApiConfig.authLogoutEndpoint, {});
      await _httpService.deleteToken();
    } catch (e) {
      // Même en cas d'erreur, on supprime le token local
      await _httpService.deleteToken();
      throw Exception('Échec de la déconnexion: ${e.toString()}');
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await _httpService.getToken();
    return token != null;
  }
}