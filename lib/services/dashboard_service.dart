import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboard_stats.dart';
import '../config/api_config.dart';

class DashboardService {
  final String? token;

  DashboardService(this.token);

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Récupère toutes les statistiques du dashboard
  Future<DashboardStats> getStats() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/dashboard/stats'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DashboardStats.fromJson(data);
    } else {
      throw Exception(
          'Erreur lors du chargement des statistiques: ${response.statusCode}');
    }
  }
}