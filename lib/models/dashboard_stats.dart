import 'commande.dart';

class DashboardStats {
  final int totalClients;
  final int totalCommandes;
  final int totalMesures;
  final double revenuTotal;
  final double revenuMois;
  final List<CommandeParStatut> commandesParStatut;
  final List<Commande> commandesRecentes;
  final List<Commande> commandesALivrer;

  DashboardStats({
    required this.totalClients,
    required this.totalCommandes,
    required this.totalMesures,
    required this.revenuTotal,
    required this.revenuMois,
    required this.commandesParStatut,
    required this.commandesRecentes,
    required this.commandesALivrer,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalClients: json['statistiques']['total_clients'] ?? 0,
      totalCommandes: json['statistiques']['total_commandes'] ?? 0,
      totalMesures: json['statistiques']['total_mesures'] ?? 0,
      revenuTotal: (json['statistiques']['revenu_total'] ?? 0).toDouble(),
      revenuMois: (json['statistiques']['revenu_mois'] ?? 0).toDouble(),
      commandesParStatut: (json['commandes_par_statut'] as List? ?? [])
          .map((s) => CommandeParStatut.fromJson(s))
          .toList(),
      commandesRecentes: (json['commandes_recentes'] as List? ?? [])
          .map((c) => Commande.fromJson(c))
          .toList(),
      commandesALivrer: (json['commandes_a_livrer'] as List? ?? [])
          .map((c) => Commande.fromJson(c))
          .toList(),
    );
  }

  int getCountByStatut(StatutCommande statut) {
    try {
      return commandesParStatut
          .firstWhere((cps) => cps.statut == statut)
          .total;
    } catch (e) {
      return 0;
    }
  }
}

class CommandeParStatut {
  final StatutCommande statut;
  final int total;

  CommandeParStatut({
    required this.statut,
    required this.total,
  });

  factory CommandeParStatut.fromJson(Map<String, dynamic> json) {
    return CommandeParStatut(
      statut: StatutCommande.fromString(json['statut']),
      total: json['total'] ?? 0,
    );
  }
}