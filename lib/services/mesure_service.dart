import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mesure.dart';
import '../config/api_config.dart';

class MesureService {
  final String? token;

  MesureService(this.token);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Récupère toutes les mesures (optionnellement filtrées par client)
  Future<List<Mesure>> getMesures({int? clientId}) async {
    final queryParams = <String, String>{};
    if (clientId != null) {
      queryParams['client_id'] = clientId.toString();
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/mesures')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((m) => Mesure.fromJson(m)).toList();
    } else {
      throw Exception(
          'Erreur lors du chargement des mesures: ${response.statusCode}');
    }
  }

  /// Récupère une mesure par son ID
  Future<Mesure> getMesure(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/mesures/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Mesure.fromJson(data['mesure']);
    } else {
      throw Exception(
          'Erreur lors du chargement de la mesure: ${response.statusCode}');
    }
  }

  /// Crée une nouvelle mesure
  Future<Mesure> createMesure({
    required int clientId,
    required String typeVetement,
    double? longueur,
    double? largeurEpaule,
    double? tourPoitrine,
    double? tourTaille,
    double? tourHanche,
    double? longueurManche,
    double? tourCou,
    Map<String, dynamic>? autresMesures,
  }) async {
    final body = {
      'client_id': clientId,
      'type_vetement': typeVetement,
      if (longueur != null) 'longueur': longueur,
      if (largeurEpaule != null) 'largeur_epaule': largeurEpaule,
      if (tourPoitrine != null) 'tour_poitrine': tourPoitrine,
      if (tourTaille != null) 'tour_taille': tourTaille,
      if (tourHanche != null) 'tour_hanche': tourHanche,
      if (longueurManche != null) 'longueur_manche': longueurManche,
      if (tourCou != null) 'tour_cou': tourCou,
      if (autresMesures != null && autresMesures.isNotEmpty)
        'autres_mesures': autresMesures,
    };

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/mesures'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Mesure.fromJson(data['mesure']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la création de la mesure');
    }
  }

  /// Met à jour une mesure existante
  Future<Mesure> updateMesure(int id, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/mesures/$id'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Mesure.fromJson(data['mesure']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la mise à jour de la mesure');
    }
  }

  /// Supprime une mesure
  Future<void> deleteMesure(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/mesures/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la suppression de la mesure');
    }
  }
}