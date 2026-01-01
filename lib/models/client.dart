import 'mesure.dart';
import 'commande.dart';

class Client {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String? adresse;
  final List<Mesure>? mesures;
  final List<Commande>? commandes;
  final DateTime createdAt;

  Client({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.adresse,
    this.mesures,
    this.commandes,
    required this.createdAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      adresse: json['adresse'],
      mesures: json['mesures'] != null
          ? (json['mesures'] as List).map((m) => Mesure.fromJson(m)).toList()
          : null,
      commandes: json['commandes'] != null
          ? (json['commandes'] as List).map((c) => Commande.fromJson(c)).toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      if (adresse != null) 'adresse': adresse,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get nomComplet => '$prenom $nom';
}