import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';
import '../config/api_config.dart';

class PaginatedClients {
  final List<Client> data;
  final int currentPage;
  final int total;
  final int perPage;
  final int lastPage;

  PaginatedClients({
    required this.data,
    required this.currentPage,
    required this.total,
    required this.perPage,
    required this.lastPage,
  });

  factory PaginatedClients.fromJson(Map<String, dynamic> json) {
    return PaginatedClients(
      data: (json['data'] as List).map((c) => Client.fromJson(c)).toList(),
      currentPage: json['current_page'] ?? 1,
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 20,
      lastPage: json['last_page'] ?? 1,
    );
  }

  bool get hasMorePages => currentPage < lastPage;
}

class ClientService {
  final String? token;

  ClientService(this.token);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Récupère la liste paginée des clients
  Future<PaginatedClients> getClients({String? search, int page = 1}) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}/clients')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PaginatedClients.fromJson(data);
    } else {
      throw Exception(
          'Erreur lors du chargement des clients: ${response.statusCode}');
    }
  }

  /// Récupère un client par son ID
  Future<Client> getClient(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/clients/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Client.fromJson(data['client']);
    } else {
      throw Exception(
          'Erreur lors du chargement du client: ${response.statusCode}');
    }
  }

  /// Crée un nouveau client
  Future<Client> createClient({
    required String nom,
    required String prenom,
    required String telephone,
    String? adresse,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/clients'),
      headers: _headers,
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        if (adresse != null && adresse.isNotEmpty) 'adresse': adresse,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Client.fromJson(data['client']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Erreur lors de la création du client');
    }
  }

  /// Met à jour un client existant
  Future<Client> updateClient(int id, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/clients/$id'),
      headers: _headers,
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Client.fromJson(data['client']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la mise à jour du client');
    }
  }

  /// Supprime un client
  Future<void> deleteClient(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/clients/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(
          error['message'] ?? 'Erreur lors de la suppression du client');
    }
  }
}