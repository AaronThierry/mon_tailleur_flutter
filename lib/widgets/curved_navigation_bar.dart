import 'package:flutter/material.dart';
import 'curved_nav_clipper.dart';
import 'nav_bar_item.dart';

/// Bottom Navigation Bar moderne avec design curvilinéaire
/// Comprend un bouton central surélevé et des animations fluides
class CurvedNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavBarItemData> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Gradient? centerButtonGradient;
  final double height;
  final bool enableGlassmorphism;
  final NavBarLabelStyle labelStyle;

  const CurvedNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.activeColor = const Color(0xFF6366F1),
    this.inactiveColor = const Color(0xFF9CA3AF),
    this.centerButtonGradient,
    this.height = 75,
    this.enableGlassmorphism = false,
    this.labelStyle = NavBarLabelStyle.alwaysVisible,
  })  : assert(items.length == 5, 'La navbar doit avoir exactement 5 items'),
        super(key: key);

  @override
  State<CurvedNavigationBar> createState() => _CurvedNavigationBarState();
}

class _CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _waveController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Effet Glassmorphism (optionnel)
          if (widget.enableGlassmorphism)
            Positioned.fill(
              child: ClipPath(
                clipper: CurvedNavClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ColorFilter.mode(
                      Colors.white.withOpacity(0.1),
                      BlendMode.overlay,
                    ),
                    child: Container(),
                  ),
                ),
              ),
            ),

          // Forme courbe principale
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, widget.height),
            painter: CurvedNavPainter(
              backgroundColor: widget.backgroundColor,
              curveDepth: 30,
              curveWidth: 100,
            ),
          ),

          // Items de navigation
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Premier item
                Expanded(
                  child: NavBarItem(
                    icon: widget.items[0].icon,
                    label: widget.items[0].label,
                    isActive: widget.currentIndex == 0,
                    onTap: () => widget.onTap(0),
                    activeColor: widget.activeColor,
                    inactiveColor: widget.inactiveColor,
                    labelStyle: widget.labelStyle,
                  ),
                ),

                // Deuxième item
                Expanded(
                  child: NavBarItem(
                    icon: widget.items[1].icon,
                    label: widget.items[1].label,
                    isActive: widget.currentIndex == 1,
                    onTap: () => widget.onTap(1),
                    activeColor: widget.activeColor,
                    inactiveColor: widget.inactiveColor,
                    labelStyle: widget.labelStyle,
                  ),
                ),

                // Espace pour le bouton central
                const Expanded(child: SizedBox()),

                // Quatrième item (notifications avec badge)
                Expanded(
                  child: NavBarItem(
                    icon: widget.items[3].icon,
                    label: widget.items[3].label,
                    isActive: widget.currentIndex == 3,
                    onTap: () => widget.onTap(3),
                    activeColor: widget.activeColor,
                    inactiveColor: widget.inactiveColor,
                    showBadge: widget.items[3].badgeCount != null,
                    badgeCount: widget.items[3].badgeCount,
                    labelStyle: widget.labelStyle,
                  ),
                ),

                // Cinquième item
                Expanded(
                  child: NavBarItem(
                    icon: widget.items[4].icon,
                    label: widget.items[4].label,
                    isActive: widget.currentIndex == 4,
                    onTap: () => widget.onTap(4),
                    activeColor: widget.activeColor,
                    inactiveColor: widget.inactiveColor,
                    labelStyle: widget.labelStyle,
                  ),
                ),
              ],
            ),
          ),

          // Bouton central surélevé
          Positioned(
            top: -25,
            child: CenterFloatingButton(
              icon: widget.items[2].icon,
              onTap: () => widget.onTap(2),
              gradient: widget.centerButtonGradient ??
                  const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
              isActive: widget.currentIndex == 2,
            ),
          ),

          // Animation de vague (wave effect)
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: _getWavePosition(),
                child: Opacity(
                  opacity: 1.0 - _waveAnimation.value,
                  child: Container(
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: widget.activeColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: widget.activeColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Calcule la position de l'animation de vague en fonction de l'index actif
  double _getWavePosition() {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 5;

    // Positionner la vague sous l'item actif
    switch (widget.currentIndex) {
      case 0:
        return itemWidth * 0.5 - 30;
      case 1:
        return itemWidth * 1.5 - 30;
      case 2:
        return itemWidth * 2.5 - 30; // Centre
      case 3:
        return itemWidth * 3.5 - 30;
      case 4:
        return itemWidth * 4.5 - 30;
      default:
        return 0;
    }
  }
}

/// Classe de données pour chaque item de la navigation
class NavBarItemData {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const NavBarItemData({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}

/// Gradient presets pour le bouton central
class NavBarGradients {
  // Gradient violet/rose
  static const purplePink = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient bleu/cyan
  static const blueCyan = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient orange/rouge
  static const orangeRed = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient vert émeraude
  static const emerald = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient doré
  static const golden = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradient indigo
  static const indigo = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}