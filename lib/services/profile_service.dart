import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user.dart';
import 'http_service.dart';

class ProfileService {
  final HttpService _httpService = HttpService();

  // Mettre à jour le profil
  Future<User> updateProfile({
    String? name,
    String? telephone,
    String? adresse,
    String? bio,
  }) async {
    try {
      final Map<String, dynamic> body = {};

      if (name != null) body['name'] = name;
      if (telephone != null) body['telephone'] = telephone;
      if (adresse != null) body['adresse'] = adresse;
      if (bio != null) body['bio'] = bio;

      final response = await _httpService.put(
        '/profile/update',
        body,
      );

      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } catch (e) {
      throw Exception('Échec de la mise à jour du profil: ${e.toString()}');
    }
  }

  // Upload photo de profil
  Future<User> uploadProfilePhoto(File imageFile) async {
    try {
      final token = await _httpService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/profile/photo'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Ajouter le fichier
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de l\'upload');
      }
    } catch (e) {
      throw Exception('Échec de l\'upload de la photo: ${e.toString()}');
    }
  }

  // Supprimer photo de profil
  Future<User> deleteProfilePhoto() async {
    try {
      final response = await _httpService.delete('/profile/photo');

      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } catch (e) {
      throw Exception('Échec de la suppression de la photo: ${e.toString()}');
    }
  }

  // Obtenir l'URL complète de la photo
  String? getPhotoUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) return null;

    // Si c'est déjà une URL complète
    if (photoPath.startsWith('http')) {
      return photoPath;
    }

    // Sinon construire l'URL
    final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
    return '$baseUrl/storage/$photoPath';
  }
}