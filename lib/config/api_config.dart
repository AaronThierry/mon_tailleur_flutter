import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';

  // Endpoints de l'API - Authentification
  static String get authLoginEndpoint => '/auth/login';
  static String get authRegisterEndpoint => '/auth/register';
  static String get authLogoutEndpoint => '/auth/logout';
  static String get authMeEndpoint => '/auth/me';

  // Endpoints - Profil
  static String get profileUpdateEndpoint => '/profile/update';
  static String get profilePhotoEndpoint => '/profile/photo';

  // Endpoints - Dashboard
  static String get dashboardStatsEndpoint => '/dashboard/stats';

  // Endpoints - Clients
  static String get clientsEndpoint => '/clients';

  // Endpoints - Mesures
  static String get mesuresEndpoint => '/mesures';

  // Endpoints - Commandes
  static String get commandesEndpoint => '/commandes';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers par défaut
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}