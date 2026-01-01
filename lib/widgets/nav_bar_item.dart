import 'package:flutter/material.dart';

/// Styles d'affichage pour les labels de navigation
enum NavBarLabelStyle {
  /// Affiche uniquement le label de l'item actif
  onlyActive,

  /// Affiche tous les labels avec effet fade
  alwaysVisible,

  /// Affiche le label dans un chip/badge au-dessus de l'icône
  chip,

  /// Affiche le label avec effet glassmorphism
  glassmorphism,

  /// N'affiche aucun label
  none,
}

/// Widget réutilisable pour chaque item de la navigation bar
/// Comprend les animations de scale, couleur et indicateur de sélection
class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String? label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool showBadge;
  final int? badgeCount;
  final NavBarLabelStyle labelStyle;

  const NavBarItem({
    Key? key,
    required this.icon,
    this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor = const Color(0xFF6366F1),
    this.inactiveColor = const Color(0xFF9CA3AF),
    this.showBadge = false,
    this.badgeCount,
    this.labelStyle = NavBarLabelStyle.onlyActive,
  }) : super(key: key);

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _breathingController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Animation de tap
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animation de "breathing" pour le label actif
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    // Animation shimmer pour effet brillant
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive) {
      _controller.forward();
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
        _shimmerController.repeat();
      } else {
        _controller.reverse();
        _shimmerController.stop();
        _shimmerController.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _breathingController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Animation de tap
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: Container(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isActive ? 1.0 : _scaleAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Badge de notification
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Icône avec animation de couleur
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          widget.icon,
                          color: widget.isActive
                              ? widget.activeColor
                              : widget.inactiveColor,
                          size: 26,
                        ),
                      ),
                      // Badge
                      if (widget.showBadge && widget.badgeCount != null)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                widget.badgeCount! > 99
                                    ? '99+'
                                    : widget.badgeCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Indicateur de sélection (point ou barre)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.isActive ? 6 : 0,
                    height: 6,
                    decoration: BoxDecoration(
                      color: widget.activeColor,
                      shape: BoxShape.circle,
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: widget.activeColor.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                  ),
                  // Label stylisé
                  if (widget.label != null && widget.labelStyle != NavBarLabelStyle.none)
                    _buildLabel(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Construit le widget de label selon le style choisi
  Widget _buildLabel() {
    final shouldShow = widget.labelStyle == NavBarLabelStyle.alwaysVisible || widget.isActive;

    switch (widget.labelStyle) {
      case NavBarLabelStyle.onlyActive:
        return _buildSimpleLabel(shouldShow);

      case NavBarLabelStyle.alwaysVisible:
        return _buildFadedLabel();

      case NavBarLabelStyle.chip:
        return _buildChipLabel(shouldShow);

      case NavBarLabelStyle.glassmorphism:
        return _buildGlassmorphismLabel(shouldShow);

      case NavBarLabelStyle.none:
        return const SizedBox.shrink();
    }
  }

  /// Label simple qui apparaît uniquement quand actif avec animations slide + fade + scale
  Widget _buildSimpleLabel(bool shouldShow) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _shimmerController]),
      builder: (context, child) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          offset: shouldShow ? Offset.zero : const Offset(0, 0.5),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            opacity: shouldShow ? 1.0 : 0.0,
            child: Transform.scale(
              scale: widget.isActive ? _breathingAnimation.value : 1.0,
              child: Container(
                margin: EdgeInsets.only(top: shouldShow ? 6 : 0),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    if (!widget.isActive) {
                      return LinearGradient(
                        colors: [widget.inactiveColor, widget.inactiveColor],
                      ).createShader(bounds);
                    }
                    return LinearGradient(
                      begin: Alignment(_shimmerAnimation.value - 1, 0),
                      end: Alignment(_shimmerAnimation.value + 1, 0),
                      colors: [
                        widget.activeColor,
                        widget.activeColor.withOpacity(0.6),
                        Colors.white.withOpacity(0.9),
                        widget.activeColor.withOpacity(0.6),
                        widget.activeColor,
                      ],
                      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.5,
                      shadows: widget.isActive
                          ? [
                              Shadow(
                                color: widget.activeColor.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : [],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Label avec effet fade qui est toujours visible + breathing + shimmer
  Widget _buildFadedLabel() {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _shimmerController]),
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.only(top: 6),
          child: Transform.scale(
            scale: widget.isActive ? _breathingAnimation.value : 1.0,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                if (!widget.isActive) {
                  return LinearGradient(
                    colors: [
                      widget.inactiveColor.withOpacity(0.6),
                      widget.inactiveColor.withOpacity(0.6),
                    ],
                  ).createShader(bounds);
                }
                return LinearGradient(
                  begin: Alignment(_shimmerAnimation.value - 1, 0),
                  end: Alignment(_shimmerAnimation.value + 1, 0),
                  colors: [
                    widget.activeColor,
                    widget.activeColor.withOpacity(0.7),
                    Colors.white.withOpacity(0.95),
                    widget.activeColor.withOpacity(0.7),
                    widget.activeColor,
                  ],
                  stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                widget.label!,
                style: TextStyle(
                  fontSize: widget.isActive ? 12 : 10,
                  fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w500,
                  letterSpacing: widget.isActive ? 0.6 : 0.3,
                  shadows: widget.isActive
                      ? [
                          Shadow(
                            color: widget.activeColor.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Label dans un chip/badge moderne avec bounce + shimmer
  Widget _buildChipLabel(bool shouldShow) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _shimmerController]),
      builder: (context, child) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 450),
          curve: Curves.elasticOut,
          offset: shouldShow ? Offset.zero : const Offset(0, 0.8),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: shouldShow ? 1.0 : 0.0,
            child: Transform.scale(
              scale: widget.isActive ? _breathingAnimation.value : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                margin: EdgeInsets.only(top: shouldShow ? 6 : 0),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.activeColor.withOpacity(0.2),
                      widget.activeColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.activeColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.activeColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    if (!widget.isActive) {
                      return LinearGradient(
                        colors: [widget.activeColor, widget.activeColor],
                      ).createShader(bounds);
                    }
                    return LinearGradient(
                      begin: Alignment(_shimmerAnimation.value - 1, 0),
                      end: Alignment(_shimmerAnimation.value + 1, 0),
                      colors: [
                        widget.activeColor,
                        widget.activeColor.withOpacity(0.7),
                        Colors.white,
                        widget.activeColor.withOpacity(0.7),
                        widget.activeColor,
                      ],
                      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Label avec effet glassmorphism + breathing + shimmer ultra élégant
  Widget _buildGlassmorphismLabel(bool shouldShow) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathingController, _shimmerController]),
      builder: (context, child) {
        return AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          offset: shouldShow ? Offset.zero : const Offset(0, 1.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            opacity: shouldShow ? 1.0 : 0.0,
            child: Transform.scale(
              scale: widget.isActive ? _breathingAnimation.value : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                margin: EdgeInsets.only(top: shouldShow ? 6 : 0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.15),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.activeColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: -2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    if (!widget.isActive) {
                      return const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ).createShader(bounds);
                    }
                    return LinearGradient(
                      begin: Alignment(_shimmerAnimation.value - 1, 0),
                      end: Alignment(_shimmerAnimation.value + 1, 0),
                      colors: const [
                        Colors.white,
                        Color(0xFFE0E7FF),
                        Color(0xFFFFFFFF),
                        Color(0xFFE0E7FF),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                        Shadow(
                          color: Colors.white24,
                          blurRadius: 2,
                          offset: Offset(0, -1),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget pour le bouton central surélevé avec effet de gradient
class CenterFloatingButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Gradient gradient;
  final bool isActive;

  const CenterFloatingButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.isActive = false,
  }) : super(key: key);

  @override
  State<CenterFloatingButton> createState() => _CenterFloatingButtonState();
}

class _CenterFloatingButtonState extends State<CenterFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.colors.first.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: widget.gradient.colors.last.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}