import 'client.dart';

enum StatutCommande {
  enAttente('en_attente', 'En attente'),
  enCours('en_cours', 'En cours'),
  termine('termine', 'Terminé'),
  livre('livre', 'Livré'),
  annule('annule', 'Annulé');

  final String value;
  final String label;
  const StatutCommande(this.value, this.label);

  static StatutCommande fromString(String value) {
    return StatutCommande.values.firstWhere(
      (s) => s.value == value,
      orElse: () => StatutCommande.enAttente,
    );
  }
}

class Commande {
  final int id;
  final String numeroCommande;
  final int clientId;
  final int userId;
  final String typeVetement;
  final String? description;
  final double prix;
  final DateTime datePrise;
  final DateTime dateLivraisonPrevue;
  final DateTime? dateLivraisonEffective;
  final StatutCommande statut;
  final Client? client;

  Commande({
    required this.id,
    required this.numeroCommande,
    required this.clientId,
    required this.userId,
    required this.typeVetement,
    this.description,
    required this.prix,
    required this.datePrise,
    required this.dateLivraisonPrevue,
    this.dateLivraisonEffective,
    required this.statut,
    this.client,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      id: json['id'],
      numeroCommande: json['numero_commande'],
      clientId: json['client_id'],
      userId: json['user_id'],
      typeVetement: json['type_vetement'],
      description: json['description'],
      prix: (json['prix'] ?? 0).toDouble(),
      datePrise: DateTime.parse(json['date_prise']),
      dateLivraisonPrevue: DateTime.parse(json['date_livraison_prevue']),
      dateLivraisonEffective: json['date_livraison_effective'] != null
          ? DateTime.parse(json['date_livraison_effective'])
          : null,
      statut: StatutCommande.fromString(json['statut']),
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'type_vetement': typeVetement,
      if (description != null) 'description': description,
      'prix': prix,
      'date_livraison_prevue': dateLivraisonPrevue.toIso8601String().split('T')[0],
      'statut': statut.value,
    };
  }

  bool get estEnRetard =>
      dateLivraisonPrevue.isBefore(DateTime.now()) &&
      statut != StatutCommande.livre &&
      statut != StatutCommande.annule;

  int get joursRestants {
    final difference = dateLivraisonPrevue.difference(DateTime.now());
    return difference.inDays;
  }
}