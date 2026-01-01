import 'dart:ui';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../auth/login_screen_new.dart';
import '../profile/edit_profile_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../commandes/commandes_list_screen.dart';
import '../../widgets/curved_navigation_bar.dart';

class HomeScreenNew extends StatefulWidget {
  final User user;

  const HomeScreenNew({super.key, required this.user});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int _selectedIndex = 0;
  final _authService = AuthService();
  bool _isLoading = false;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _updateUser(User user) {
    setState(() {
      _currentUser = user;
    });
  }

  List<Widget> _getPages() {
    return [
      DashboardScreen(user: _currentUser),
      const CommandesListScreen(),
      _AddPage(), // Page centrale pour le bouton "Ajouter"
      _NotificationsPage(), // Page notifications
      _ProfilePage(
        user: _currentUser,
        onLogout: _handleLogout,
        onEditProfile: _handleEditProfile,
      ),
    ];
  }

  Future<void> _handleEditProfile() async {
    final result = await Navigator.of(context).push<User>(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          user: _currentUser,
          onProfileUpdated: (updatedUser) {
            _updateUser(updatedUser);
          },
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _buildLogoutDialog(),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _authService.logout();

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreenNew()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: _getPages()[_selectedIndex],
      ),
      bottomNavigationBar: _buildModernBottomNav(),
    );
  }

  Widget _buildModernBottomNav() {
    // Curved Navigation Bar avec design moderne
    return CurvedNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        NavBarItemData(
          icon: Icons.home_rounded,
          label: 'Accueil',
        ),
        NavBarItemData(
          icon: Icons.shopping_bag_rounded,
          label: 'Commandes',
        ),
        NavBarItemData(
          icon: Icons.add_rounded,
          label: 'Ajouter',
        ),
        NavBarItemData(
          icon: Icons.notifications_rounded,
          label: 'Notifications',
        ),
        NavBarItemData(
          icon: Icons.person_rounded,
          label: 'Profil',
        ),
      ],
      backgroundColor: const Color(0xFF1A1A2E),
      activeColor: AppTheme.primaryBlue,
      inactiveColor: AppTheme.textSecondary,
      centerButtonGradient: AppTheme.accentGradient,
      height: 75,
    );
  }

  Widget _buildLogoutDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.cardBackground.withOpacity(0.9),
                  AppTheme.cardBackground.withOpacity(0.7),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: AppTheme.accentPink,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Déconnexion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Voulez-vous vraiment vous déconnecter ?',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Déconnexion',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
}

// Dashboard Page
class _DashboardPage extends StatelessWidget {
  final User user;

  const _DashboardPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildStatsCards(),
            const SizedBox(height: 30),
            _buildQuickActions(context),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour,',
                style: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Clients',
            value: '0',
            icon: Icons.people_rounded,
            gradient: AppTheme.primaryGradient,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Commandes',
            value: '0',
            icon: Icons.shopping_bag_rounded,
            gradient: AppTheme.accentGradient,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _QuickActionCard(
          title: 'Nouveau Client',
          subtitle: 'Ajouter un nouveau client',
          icon: Icons.person_add_rounded,
          gradient: AppTheme.primaryGradient,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité à venir')),
            );
          },
        ),
        const SizedBox(height: 12),
        _QuickActionCard(
          title: 'Nouvelle Commande',
          subtitle: 'Créer une nouvelle commande',
          icon: Icons.add_shopping_cart_rounded,
          gradient: AppTheme.accentGradient,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité à venir')),
            );
          },
        ),
      ],
    );
  }
}

// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Action Card
class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: AppTheme.textSecondary.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder pages
class _ClientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_rounded,
            size: 80,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Page Clients',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonctionnalité à venir',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_rounded,
            size: 80,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Page Commandes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonctionnalité à venir',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Add Page (Centre de la navbar)
class _AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentPink.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 64,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Ajouter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Créer une nouvelle commande ou client',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Notifications Page
class _NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_rounded,
            size: 80,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucune notification pour le moment',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final User user;
  final VoidCallback onLogout;
  final VoidCallback onEditProfile;

  const _ProfilePage({
    required this.user,
    required this.onLogout,
    required this.onEditProfile,
  });

  Color _getRoleColor() {
    switch (user.role.value) {
      case 'admin':
        return const Color(0xFFFFD700); // Gold
      case 'employe':
        return const Color(0xFF00E5FF); // Cyan
      default:
        return AppTheme.accentPink; // Pink
    }
  }

  IconData _getRoleIcon() {
    switch (user.role.value) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'employe':
        return Icons.work_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Profile Header - Full Width
            _buildProfileHeader(),

            // Content avec padding
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Personal Info Section
                  _buildSectionTitle('Informations personnelles'),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.person_outline_rounded,
                    title: 'Modifier le profil',
                    subtitle: 'Nom, email, photo',
                    onTap: onEditProfile,
                    gradient: AppTheme.primaryGradient,
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.lock_outline_rounded,
                    title: 'Changer le mot de passe',
                    subtitle: 'Sécuriser votre compte',
                    onTap: () => _showComingSoon(context),
                    gradient: AppTheme.accentGradient,
                  ),
                  const SizedBox(height: 24),

                  // App Settings Section
                  _buildSectionTitle('Paramètres'),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Gérer vos notifications',
                    onTap: () => _showComingSoon(context),
                    gradient: LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.language_rounded,
                    title: 'Langue',
                    subtitle: 'Français',
                    onTap: () => _showComingSoon(context),
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.dark_mode_outlined,
                    title: 'Thème',
                    subtitle: 'Sombre',
                    onTap: () => _showComingSoon(context),
                    gradient: LinearGradient(
                      colors: [Color(0xFF424242), Color(0xFF212121)],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Section
                  _buildSectionTitle('Compte'),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.help_outline_rounded,
                    title: 'Aide et support',
                    subtitle: 'FAQ, Contacter le support',
                    onTap: () => _showComingSoon(context),
                    gradient: LinearGradient(
                      colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.info_outline_rounded,
                    title: 'À propos',
                    subtitle: 'Version 1.0.0',
                    onTap: () => _showComingSoon(context),
                    gradient: LinearGradient(
                      colors: [Color(0xFF64B5F6), Color(0xFF2196F3)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildProfileOption(
                    icon: Icons.logout_rounded,
                    title: 'Déconnexion',
                    subtitle: 'Se déconnecter du compte',
                    onTap: onLogout,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                    ),
                  ),
                  const SizedBox(height: 120), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final profileService = ProfileService();
    final photoUrl = profileService.getPhotoUrl(user.photoProfil);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        children: [
          // Avatar style iOS - Grand et minimaliste
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: photoUrl == null ? _getRoleColor() : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
              image: photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoUrl == null
                ? Center(
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : null,
          ),

          const SizedBox(height: 20),

          // Nom - Style iOS Large Title
          Text(
            user.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          // Email - Style iOS subtitle
          Text(
            user.email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Badge de rôle - Style iOS minimal
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getRoleColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getRoleIcon(),
                  color: _getRoleColor(),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  user.role.label,
                  style: TextStyle(
                    color: _getRoleColor(),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required LinearGradient gradient,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icône avec gradient subtil
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron iOS style
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.3),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
            Text('Fonctionnalité à venir'),
          ],
        ),
        backgroundColor: AppTheme.cardBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// Custom Painter pour la navbar avec courbe
class CurvedNavBarPainter extends CustomPainter {
  final int selectedIndex;
  final int itemCount;
  final Color color;
  final Color shadowColor;

  CurvedNavBarPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.color,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Shadow paint
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    final path = Path();
    final shadowPath = Path();

    // Calcul de la position de l'élément sélectionné
    final itemWidth = size.width / itemCount;
    final selectedCenter = itemWidth * selectedIndex + itemWidth / 2;

    // Paramètres de la courbe
    final curveWidth = 80.0;
    final curveHeight = 35.0;
    final curveStartX = selectedCenter - curveWidth / 2;
    final curveEndX = selectedCenter + curveWidth / 2;

    // Commencer le chemin
    path.moveTo(0, 20);
    shadowPath.moveTo(0, 20);

    // Coin supérieur gauche arrondi
    path.quadraticBezierTo(0, 0, 20, 0);
    shadowPath.quadraticBezierTo(0, 0, 20, 0);

    // Ligne jusqu'au début de la courbe
    path.lineTo(curveStartX - 20, 0);
    shadowPath.lineTo(curveStartX - 20, 0);

    // Courbe ascendante (notch pour l'élément actif)
    path.quadraticBezierTo(
      curveStartX - 10, 0,
      curveStartX, -5,
    );
    shadowPath.quadraticBezierTo(
      curveStartX - 10, 0,
      curveStartX, -5,
    );

    path.quadraticBezierTo(
      curveStartX + 10, -curveHeight,
      selectedCenter, -curveHeight,
    );
    shadowPath.quadraticBezierTo(
      curveStartX + 10, -curveHeight,
      selectedCenter, -curveHeight,
    );

    path.quadraticBezierTo(
      curveEndX - 10, -curveHeight,
      curveEndX, -5,
    );
    shadowPath.quadraticBezierTo(
      curveEndX - 10, -curveHeight,
      curveEndX, -5,
    );

    path.quadraticBezierTo(
      curveEndX + 10, 0,
      curveEndX + 20, 0,
    );
    shadowPath.quadraticBezierTo(
      curveEndX + 10, 0,
      curveEndX + 20, 0,
    );

    // Ligne jusqu'au coin supérieur droit
    path.lineTo(size.width - 20, 0);
    shadowPath.lineTo(size.width - 20, 0);

    // Coin supérieur droit arrondi
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    shadowPath.quadraticBezierTo(size.width, 0, size.width, 20);

    // Ligne droite vers le bas
    path.lineTo(size.width, size.height - 20);
    shadowPath.lineTo(size.width, size.height - 20);

    // Coin inférieur droit arrondi
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 20,
      size.height,
    );
    shadowPath.quadraticBezierTo(
      size.width,
      size.height,
      size.width - 20,
      size.height,
    );

    // Ligne du bas
    path.lineTo(20, size.height);
    shadowPath.lineTo(20, size.height);

    // Coin inférieur gauche arrondi
    path.quadraticBezierTo(0, size.height, 0, size.height - 20);
    shadowPath.quadraticBezierTo(0, size.height, 0, size.height - 20);

    // Fermer le chemin
    path.close();
    shadowPath.close();

    // Dessiner l'ombre
    canvas.drawPath(shadowPath, shadowPaint);

    // Dessiner le fond
    canvas.drawPath(path, paint);

    // Dessiner une bordure brillante
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CurvedNavBarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}

// Custom Painter pour le pattern géométrique de la bannière
class _BannerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Dessiner un motif géométrique élégant
    final double spacing = 40;

    // Lignes diagonales
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Cercles décoratifs
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      60,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.7),
      80,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(_BannerPatternPainter oldDelegate) => false;
}