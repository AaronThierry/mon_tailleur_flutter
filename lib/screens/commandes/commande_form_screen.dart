import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../models/commande.dart';
import '../../models/client.dart';
import '../../services/commande_service.dart';
import '../../services/client_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/gradient_button.dart';

class CommandeFormScreen extends StatefulWidget {
  final Commande? commande;

  const CommandeFormScreen({Key? key, this.commande}) : super(key: key);

  @override
  State<CommandeFormScreen> createState() => _CommandeFormScreenState();
}

class _CommandeFormScreenState extends State<CommandeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late CommandeService _commandeService;
  late ClientService _clientService;
  bool _loading = false;
  bool _loadingClients = true;
  List<Client> _clients = [];

  final _typeVetementController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prixController = TextEditingController();

  Client? _selectedClient;
  DateTime? _dateLivraisonPrevue;
  StatutCommande _selectedStatut = StatutCommande.enAttente;

  bool get _isEditing => widget.commande != null;

  @override
  void initState() {
    super.initState();
    _initServices();
    if (_isEditing) {
      _typeVetementController.text = widget.commande!.typeVetement;
      _descriptionController.text = widget.commande!.description ?? '';
      _prixController.text = widget.commande!.prix.toString();
      _dateLivraisonPrevue = widget.commande!.dateLivraisonPrevue;
      _selectedStatut = widget.commande!.statut;
      _selectedClient = widget.commande!.client;
    }
  }

  @override
  void dispose() {
    _typeVetementController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  Future<void> _initServices() async {
    final authService = AuthService();
    final token = await authService.getToken();
    _commandeService = CommandeService(token);
    _clientService = ClientService(token);
    await _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final result = await _clientService.getClients(page: 1);
      setState(() {
        _clients = result.data;
        _loadingClients = false;
      });
    } catch (e) {
      setState(() => _loadingClients = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement clients: $e')),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateLivraisonPrevue ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryBlue,
              onPrimary: Colors.white,
              surface: AppTheme.cardBackground,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateLivraisonPrevue = picked;
      });
    }
  }

  Future<void> _saveCommande() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner un client')),
      );
      return;
    }

    if (_dateLivraisonPrevue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une date de livraison')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final prix = double.parse(_prixController.text.trim());

      if (_isEditing) {
        await _commandeService.updateCommande(
          widget.commande!.id,
          {
            'client_id': _selectedClient!.id,
            'type_vetement': _typeVetementController.text.trim(),
            if (_descriptionController.text.trim().isNotEmpty)
              'description': _descriptionController.text.trim(),
            'prix': prix,
            'date_livraison_prevue':
                _dateLivraisonPrevue!.toIso8601String().split('T')[0],
            'statut': _selectedStatut.value,
          },
        );
      } else {
        await _commandeService.createCommande(
          clientId: _selectedClient!.id,
          typeVetement: _typeVetementController.text.trim(),
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          prix: prix,
          dateLivraisonPrevue: _dateLivraisonPrevue!,
          statut: _selectedStatut,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Commande modifiée avec succès'
                : 'Commande créée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Modifier la commande' : 'Nouvelle commande',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _loadingClients
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icône
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4FACFE).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32),

                    // Sélection du client
                    Text(
                      'Client *',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Client>(
                          value: _selectedClient,
                          hint: Text(
                            'Sélectionner un client',
                            style: GoogleFonts.poppins(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          isExpanded: true,
                          dropdownColor: AppTheme.cardBackground,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: _clients.map((client) {
                            return DropdownMenuItem<Client>(
                              value: client,
                              child: Text(
                                client.nomComplet,
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (client) {
                            setState(() => _selectedClient = client);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Type de vêtement
                    Text(
                      'Type de vêtement *',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    ModernTextField(
                      controller: _typeVetementController,
                      hintText: 'Ex: Costume 3 pièces',
                      prefixIcon: Icons.checkroom,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le type de vêtement est requis';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Description
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    ModernTextField(
                      controller: _descriptionController,
                      hintText: 'Détails de la commande...',
                      prefixIcon: Icons.description,
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),

                    // Prix
                    Text(
                      'Prix (FCFA) *',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    ModernTextField(
                      controller: _prixController,
                      hintText: 'Ex: 75000',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le prix est requis';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Prix invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Date de livraison
                    Text(
                      'Date de livraison prévue *',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
                            SizedBox(width: 12),
                            Text(
                              _dateLivraisonPrevue != null
                                  ? '${_dateLivraisonPrevue!.day}/${_dateLivraisonPrevue!.month}/${_dateLivraisonPrevue!.year}'
                                  : 'Sélectionner une date',
                              style: GoogleFonts.poppins(
                                color: _dateLivraisonPrevue != null
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Statut
                    Text(
                      'Statut *',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<StatutCommande>(
                          value: _selectedStatut,
                          isExpanded: true,
                          dropdownColor: AppTheme.cardBackground,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: StatutCommande.values.map((statut) {
                            return DropdownMenuItem<StatutCommande>(
                              value: statut,
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: _getStatutColor(statut),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    statut.label,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (statut) {
                            if (statut != null) {
                              setState(() => _selectedStatut = statut);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Bouton de sauvegarde
                    GradientButton(
                      text: _isEditing ? 'Modifier' : 'Créer',
                      onPressed: _saveCommande,
                      isLoading: _loading,
                      icon: _isEditing ? Icons.check : Icons.add,
                      gradient: LinearGradient(
                        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                      ),
                    ),
                  ],
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
}