import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool animate;

  const AppLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoIcon(),
        if (showText) ...[
          SizedBox(height: size * 0.15),
          _buildLogoText(),
        ],
      ],
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle décoratif en arrière-plan
          Positioned(
            top: size * 0.15,
            right: size * 0.15,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Icône principale - Ciseaux stylisés
          _buildScissorsIcon(),

          // Petit cercle accent
          Positioned(
            bottom: size * 0.2,
            left: size * 0.2,
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScissorsIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Fil de couture décoratif en arrière-plan
        Positioned(
          top: size * 0.35,
          child: Container(
            width: size * 0.6,
            height: size * 0.025,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(size * 0.01),
            ),
          ),
        ),

        // Aiguille de couture stylisée
        Positioned(
          top: size * 0.25,
          right: size * 0.2,
          child: Transform.rotate(
            angle: 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tête de l'aiguille
                Container(
                  width: size * 0.04,
                  height: size * 0.04,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: size * 0.008,
                    ),
                  ),
                ),
                // Corps de l'aiguille
                Container(
                  width: size * 0.015,
                  height: size * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(size * 0.01),
                  ),
                ),
                // Pointe de l'aiguille
                ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    width: size * 0.025,
                    height: size * 0.04,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Ciseaux améliorés avec effet premium
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lame gauche avec effet métallique
            Transform.rotate(
              angle: -0.35,
              child: Container(
                width: size * 0.28,
                height: size * 0.07,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(size * 0.035),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: size * 0.02,
                      offset: Offset(0, size * 0.01),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: size * 0.15,
                    height: size * 0.05,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(size * 0.025),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: size * 0.04),

            // Centre - pivot des ciseaux avec détails
            Container(
              width: size * 0.14,
              height: size * 0.14,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: size * 0.03,
                    offset: Offset(0, size * 0.015),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: size * 0.09,
                  height: size * 0.09,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.accentPink,
                        AppTheme.accentPink.withOpacity(0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: size * 0.03,
                      height: size * 0.03,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: size * 0.04),

            // Lame droite avec effet métallique
            Transform.rotate(
              angle: 0.35,
              child: Container(
                width: size * 0.28,
                height: size * 0.07,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(size * 0.035),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: size * 0.02,
                      offset: Offset(0, size * 0.01),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: size * 0.15,
                    height: size * 0.05,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(size * 0.025),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Bouton décoratif
        Positioned(
          bottom: size * 0.22,
          left: size * 0.28,
          child: Container(
            width: size * 0.08,
            height: size * 0.08,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4FACFE),
                  const Color(0xFF00F2FE),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: size * 0.008,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4FACFE).withOpacity(0.3),
                  blurRadius: size * 0.02,
                  spreadRadius: size * 0.005,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: size * 0.015,
                height: size * 0.015,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            'MON TAILLEUR',
            style: GoogleFonts.playfairDisplay(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: size * 0.03),
        Text(
          'Élégance & Précision',
          style: GoogleFonts.poppins(
            fontSize: size * 0.11,
            color: AppTheme.textSecondary.withOpacity(0.8),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

// Version simplifiée pour la navbar
class AppLogoSimple extends StatelessWidget {
  final double size;

  const AppLogoSimple({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ciseaux minimalistes
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: -0.3,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size * 0.025),
                  ),
                ),
              ),
              Container(
                width: size * 0.1,
                height: size * 0.1,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size * 0.025),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom clipper pour la pointe de l'aiguille (triangle)
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height); // Point bas (pointe)
    path.lineTo(0, 0); // Point haut gauche
    path.lineTo(size.width, 0); // Point haut droit
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}