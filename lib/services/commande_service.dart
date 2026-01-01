import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/commande.dart';
import '../config/api_config.dart';

class CommandeService {
  final String? token;

  CommandeService(this.token);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Récupère toutes les commandes (avec filtres optionnels)
  Future<List<Commande>> getCommandes({
    StatutCommande? statut,
    int? clientId,
  }) async {
    final queryParams = <String, String>{};
    if (statut != null) {
      queryParams['statut'] = statut.value;
    }
    if (clientId != null) {
      queryParams['client_id'] = clientId.toString();
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/commandes')
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((c) => Commande.fromJson(c)).toList();
    } else {
      throw Exception(
          'Erreur lors du chargement des commandes: ${response.statusCode}');
    }
  }

  /// Récupère une commande par son ID
  Future<Commande> getCommande(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/commandes/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Commande.fromJson(data['commande']);
    } else {
      throw Exception(
          'Erreur lors du chargement de la commande: ${response.statusCode}');
    }
  }

  /// Crée une nouvelle commande
  Future<Commande> createCommande({
    required int clientId,
    required String typeVetement,
    String? description,
    required double prix,
    required DateTime dateLivraisonPrevue,
    StatutCommande statut = StatutCommande.enAttente,
  }) async {
    final body = {
      'client_id': clientId,
      'type_vetement': typeVetement,
      if (description != null && description.isNotEmpty)
        'description': description,
      'prix': prix,
      'date_livraison_prevue':
          dateLivraisonPrevue.toIso8601String().split('T')[0],
      'statut': statut.value,
    };

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/commandes'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Commande.fromJson(data['commande']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la création de la commande');
    }
  }

  /// Met à jour une commande existante
  Future<Commande> updateCommande(int id, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/commandes/$id'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Commande.fromJson(data['commande']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la mise à jour de la commande');
    }
  }

  /// Change le statut d'une commande
  Future<Commande> updateStatut(int id, StatutCommande nouveauStatut) async {
    return updateCommande(id, {'statut': nouveauStatut.value});
  }

  /// Supprime une commande
  Future<void> deleteCommande(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/commandes/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la suppression de la commande');
    }
  }
}