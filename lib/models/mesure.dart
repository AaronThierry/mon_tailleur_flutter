import 'client.dart';

class Mesure {
  final int id;
  final int clientId;
  final String typeVetement;
  final double? longueur;
  final double? largeurEpaule;
  final double? tourPoitrine;
  final double? tourTaille;
  final double? tourHanche;
  final double? longueurManche;
  final double? tourCou;
  final Map<String, dynamic>? autresMesures;
  final Client? client;
  final DateTime? createdAt;

  Mesure({
    required this.id,
    required this.clientId,
    required this.typeVetement,
    this.longueur,
    this.largeurEpaule,
    this.tourPoitrine,
    this.tourTaille,
    this.tourHanche,
    this.longueurManche,
    this.tourCou,
    this.autresMesures,
    this.client,
    this.createdAt,
  });

  factory Mesure.fromJson(Map<String, dynamic> json) {
    return Mesure(
      id: json['id'],
      clientId: json['client_id'],
      typeVetement: json['type_vetement'],
      longueur: json['longueur']?.toDouble(),
      largeurEpaule: json['largeur_epaule']?.toDouble(),
      tourPoitrine: json['tour_poitrine']?.toDouble(),
      tourTaille: json['tour_taille']?.toDouble(),
      tourHanche: json['tour_hanche']?.toDouble(),
      longueurManche: json['longueur_manche']?.toDouble(),
      tourCou: json['tour_cou']?.toDouble(),
      autresMesures: json['autres_mesures'],
      client: json['client'] != null ? Client.fromJson(json['client']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'type_vetement': typeVetement,
      if (longueur != null) 'longueur': longueur,
      if (largeurEpaule != null) 'largeur_epaule': largeurEpaule,
      if (tourPoitrine != null) 'tour_poitrine': tourPoitrine,
      if (tourTaille != null) 'tour_taille': tourTaille,
      if (tourHanche != null) 'tour_hanche': tourHanche,
      if (longueurManche != null) 'longueur_manche': longueurManche,
      if (tourCou != null) 'tour_cou': tourCou,
      if (autresMesures != null) 'autres_mesures': autresMesures,
    };
  }
}