import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../models/commande.dart';
import '../../services/commande_service.dart';
import '../../services/auth_service.dart';
import 'commande_form_screen.dart';

class CommandesListScreen extends StatefulWidget {
  const CommandesListScreen({Key? key}) : super(key: key);

  @override
  State<CommandesListScreen> createState() => _CommandesListScreenState();
}

class _CommandesListScreenState extends State<CommandesListScreen> {
  late CommandeService _commandeService;
  List<Commande> _commandes = [];
  bool _loading = true;
  String? _error;
  StatutCommande? _selectedStatut;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final authService = AuthService();
    final token = await authService.getToken();
    _commandeService = CommandeService(token);
    _loadCommandes();
  }

  Future<void> _loadCommandes({bool refresh = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final commandes = await _commandeService.getCommandes(
        statut: _selectedStatut,
      );

      setState(() {
        _commandes = commandes;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _updateStatut(Commande commande, StatutCommande newStatut) async {
    try {
      await _commandeService.updateStatut(commande.id, newStatut);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut mis à jour')),
      );
      _loadCommandes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _deleteCommande(Commande commande) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: Text(
          'Confirmer la suppression',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer la commande ${commande.numeroCommande} ?',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _commandeService.deleteCommande(commande.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Commande supprimée')),
        );
        _loadCommandes();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _navigateToForm({Commande? commande}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommandeFormScreen(commande: commande),
      ),
    );

    if (result == true) {
      _loadCommandes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        title: Text(
          'Commandes',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _loadCommandes(refresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres par statut
          _buildStatutFilters(),

          // Liste des commandes
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        backgroundColor: AppTheme.primaryBlue,
        icon: Icon(Icons.add),
        label: Text('Nouvelle commande'),
      ),
    );
  }

  Widget _buildStatutFilters() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Tous', null, Colors.grey),
          SizedBox(width: 8),
          _buildFilterChip(
            StatutCommande.enAttente.label,
            StatutCommande.enAttente,
            Colors.orange,
          ),
          SizedBox(width: 8),
          _buildFilterChip(
            StatutCommande.enCours.label,
            StatutCommande.enCours,
            Colors.blue,
          ),
          SizedBox(width: 8),
          _buildFilterChip(
            StatutCommande.termine.label,
            StatutCommande.termine,
            Colors.purple,
          ),
          SizedBox(width: 8),
          _buildFilterChip(
            StatutCommande.livre.label,
            StatutCommande.livre,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, StatutCommande? statut, Color color) {
    final isSelected = _selectedStatut == statut;

    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatut = selected ? statut : null;
        });
        _loadCommandes();
      },
      backgroundColor: color.withOpacity(0.2),
      selectedColor: color,
      checkmarkColor: Colors.white,
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
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCommandes,
              child: Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_commandes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Aucune commande',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCommandes,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _commandes.length,
        itemBuilder: (context, index) {
          final commande = _commandes[index];
          return _buildCommandeCard(commande);
        },
      ),
    );
  }

  Widget _buildCommandeCard(Commande commande) {
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
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: commande.estEnRetard
            ? Border.all(color: Colors.orange, width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToForm(commande: commande),
          child: Padding(
            padding: EdgeInsets.all(16),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: AppTheme.textSecondary),
                      color: AppTheme.cardDark,
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigateToForm(commande: commande);
                        } else if (value == 'delete') {
                          _deleteCommande(commande);
                        } else if (value.startsWith('statut_')) {
                          final newStatut = StatutCommande.fromString(
                              value.replaceFirst('statut_', ''));
                          _updateStatut(commande, newStatut);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: AppTheme.primaryBlue),
                              SizedBox(width: 8),
                              Text(
                                'Modifier',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          enabled: false,
                          child: Text(
                            'Changer le statut',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ...StatutCommande.values.map((s) => PopupMenuItem(
                              value: 'statut_${s.value}',
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getStatutColor(s),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    s.label,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Supprimer',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.checkroom, size: 18, color: AppTheme.primaryBlue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        commande.typeVetement,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                if (commande.description != null) ...[
                  SizedBox(height: 8),
                  Text(
                    commande.description!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: AppTheme.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Livraison: ${_formatDate(commande.dateLivraisonPrevue)}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (commande.estEnRetard) ...[
                      SizedBox(width: 8),
                      Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        'En retard',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ] else if (commande.joursRestants >= 0) ...[
                      SizedBox(width: 8),
                      Text(
                        '(${commande.joursRestants} jour${commande.joursRestants > 1 ? 's' : ''})',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                    Spacer(),
                    Text(
                      '${commande.prix.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatutColor(StatutCommande statut) {
    switch (statut) {
      case StatutCommande.enAttente:
        return Colors.orange;
      case StatutCommande.enCours:
        return Colors.blue;
      case StatutCommande.termine:
        return Colors.purple;
      case StatutCommande.livre:
        return Colors.green;
      case StatutCommande.annule:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}