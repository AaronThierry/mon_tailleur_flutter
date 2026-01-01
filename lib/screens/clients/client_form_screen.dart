import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../models/client.dart';
import '../../services/client_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/modern_text_field.dart';
import '../../widgets/gradient_button.dart';

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({Key? key, this.client}) : super(key: key);

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ClientService _clientService;
  bool _loading = false;

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _adresseController = TextEditingController();

  bool get _isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _initService();
    if (_isEditing) {
      _nomController.text = widget.client!.nom;
      _prenomController.text = widget.client!.prenom;
      _telephoneController.text = widget.client!.telephone;
      _adresseController.text = widget.client!.adresse ?? '';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _initService() async {
    final authService = AuthService();
    final token = await authService.getToken();
    _clientService = ClientService(token);
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      if (_isEditing) {
        await _clientService.updateClient(
          widget.client!.id,
          {
            'nom': _nomController.text.trim(),
            'prenom': _prenomController.text.trim(),
            'telephone': _telephoneController.text.trim(),
            if (_adresseController.text.trim().isNotEmpty)
              'adresse': _adresseController.text.trim(),
          },
        );
      } else {
        await _clientService.createClient(
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          telephone: _telephoneController.text.trim(),
          adresse: _adresseController.text.trim().isNotEmpty
              ? _adresseController.text.trim()
              : null,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Client modifié avec succès'
                : 'Client créé avec succès'),
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
          _isEditing ? 'Modifier le client' : 'Nouveau client',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icône du formulaire
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_add,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),

              // Prénom
              Text(
                'Prénom *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ModernTextField(
                controller: _prenomController,
                hintText: 'Ex: Amadou',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le prénom est requis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Nom
              Text(
                'Nom *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ModernTextField(
                controller: _nomController,
                hintText: 'Ex: Diop',
                prefixIcon: Icons.badge,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Téléphone
              Text(
                'Téléphone *',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ModernTextField(
                controller: _telephoneController,
                hintText: 'Ex: 221771234567',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le téléphone est requis';
                  }
                  if (value.trim().length < 9) {
                    return 'Numéro de téléphone invalide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Adresse
              Text(
                'Adresse',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              ModernTextField(
                controller: _adresseController,
                hintText: 'Ex: Dakar, Plateau',
                prefixIcon: Icons.location_on,
                maxLines: 2,
              ),
              SizedBox(height: 32),

              // Bouton de sauvegarde
              GradientButton(
                text: _isEditing ? 'Modifier' : 'Créer',
                onPressed: _saveClient,
                isLoading: _loading,
                icon: _isEditing ? Icons.check : Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}