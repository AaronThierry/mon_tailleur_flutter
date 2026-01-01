import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../models/dashboard_stats.dart';
import '../../models/commande.dart';
import '../../models/user.dart';
import '../../services/dashboard_service.dart';
import '../../services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardService _dashboardService;
  DashboardStats? _stats;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initService();
    _loadStats();
  }

  Future<void> _initService() async {
    final authService = AuthService();
    final token = await authService.getToken();
    _dashboardService = DashboardService(token);
  }

  Future<void> _loadStats() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final stats = await _dashboardService.getStats();
      setState(() {
        _stats = stats;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: RefreshIndicator(
        onRefresh: _loadStats,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadStats,
              icon: Icon(Icons.refresh),
              label: Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    if (_stats == null) {
      return Center(
        child: Text(
          'Aucune donnée disponible',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de bienvenue
          _buildWelcomeHeader(),
          SizedBox(height: 24),

          // Cartes de statistiques principales
          _buildStatsCards(),
          SizedBox(height: 24),

          // Graphique des commandes par statut
          _buildCommandesParStatut(),
          SizedBox(height: 24),

          // Commandes à livrer
          if (_stats!.commandesALivrer.isNotEmpty) ...[
            _buildSectionHeader('Commandes à livrer', Icons.local_shipping),
            SizedBox(height: 12),
            _buildCommandesALivrer(),
            SizedBox(height: 24),
          ],

          // Commandes récentes
          _buildSectionHeader('Commandes récentes', Icons.history),
          SizedBox(height: 12),
          _buildCommandesRecentes(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.dashboard,
              color: Colors.white,
              size: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue, ${widget.user.prenom}!',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tableau de bord',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Clients',
                _stats!.totalClients.toString(),
                Icons.people,
                LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Commandes',
                _stats!.totalCommandes.toString(),
                Icons.shopping_bag,
                LinearGradient(
                  colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Mesures',
                _stats!.totalMesures.toString(),
                Icons.straighten,
                LinearGradient(
                  colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Revenu Total',
                '${(_stats!.revenuTotal / 1000).toStringAsFixed(0)}K',
                Icons.attach_money,
                LinearGradient(
                  colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Gradient gradient,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandesParStatut() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Commandes par statut',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildStatutRow(
            StatutCommande.enAttente,
            _stats!.getCountByStatut(StatutCommande.enAttente),
            Colors.orange,
          ),
          _buildStatutRow(
            StatutCommande.enCours,
            _stats!.getCountByStatut(StatutCommande.enCours),
            Colors.blue,
          ),
          _buildStatutRow(
            StatutCommande.termine,
            _stats!.getCountByStatut(StatutCommande.termine),
            Colors.purple,
          ),
          _buildStatutRow(
            StatutCommande.livre,
            _stats!.getCountByStatut(StatutCommande.livre),
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatutRow(StatutCommande statut, int count, Color color) {
    final total = _stats!.totalCommandes;
    final percentage = total > 0 ? (count / total * 100).toInt() : 0;

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statut.label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '$count ($percentage%)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? count / total : 0,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 24),
        SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCommandesALivrer() {
    return Column(
      children: _stats!.commandesALivrer
          .map((commande) => _buildCommandeCard(commande, urgent: true))
          .toList(),
    );
  }

  Widget _buildCommandesRecentes() {
    if (_stats!.commandesRecentes.isEmpty) {
      return Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Aucune commande récente',
            style: GoogleFonts.poppins(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: _stats!.commandesRecentes
          .map((commande) => _buildCommandeCard(commande))
          .toList(),
    );
  }

  Widget _buildCommandeCard(Commande commande, {bool urgent = false}) {
    Color statutColor;
    switch (commande.statut) {
      case StatutCommande.enAttente:
        statutColor = Colors.orange;
        break;
      case StatutCommande.enCours:
        statutColor = Colors.blue;
        break;
      case StatutCommande.termine:
        statutColor = Colors.purple;
        break;
      case StatutCommande.livre:
        statutColor = Colors.green;
        break;
      case StatutCommande.annule:
        statutColor = Colors.red;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: urgent
            ? Border.all(color: Colors.orange, width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commande.numeroCommande,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (commande.client != null) ...[
                      SizedBox(height: 4),
                      Text(
                        commande.client!.nomComplet,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statutColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statutColor.withOpacity(0.5)),
                ),
                child: Text(
                  commande.statut.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statutColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.checkroom, size: 16, color: AppTheme.textSecondary),
              SizedBox(width: 6),
              Text(
                commande.typeVetement,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              Spacer(),
              Text(
                '${commande.prix.toStringAsFixed(0)} FCFA',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          if (urgent || commande.estEnRetard) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: Colors.orange,
                ),
                SizedBox(width: 6),
                Text(
                  commande.estEnRetard
                      ? 'En retard'
                      : 'Livraison dans ${commande.joursRestants} jour(s)',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}