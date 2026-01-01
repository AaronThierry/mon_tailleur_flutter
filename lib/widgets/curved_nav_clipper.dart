import 'package:flutter/material.dart';

/// CustomClipper pour créer la forme courbe de la navigation bar
/// avec une découpe concave au centre pour le bouton surélevé
class CurvedNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double curveDepth = 30.0; // Profondeur de la courbe
    final double curveWidth = 100.0; // Largeur de la courbe

    // Point de départ (coin supérieur gauche)
    path.lineTo(0, 0);

    // Ligne jusqu'au début de la courbe
    path.lineTo((size.width / 2) - curveWidth / 2, 0);

    // Courbe de Bézier pour créer la découpe concave au centre
    // Premier point de contrôle (légèrement à gauche du centre)
    var firstControlPoint = Offset(
      (size.width / 2) - curveWidth / 4,
      0,
    );

    // Second point de contrôle (au-dessus du centre)
    var firstEndPoint = Offset(
      size.width / 2,
      curveDepth,
    );

    // Première courbe (montée)
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Troisième point de contrôle (légèrement à droite du centre)
    var secondControlPoint = Offset(
      (size.width / 2) + curveWidth / 4,
      0,
    );

    // Point de fin de la courbe
    var secondEndPoint = Offset(
      (size.width / 2) + curveWidth / 2,
      0,
    );

    // Deuxième courbe (descente)
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Ligne jusqu'au coin supérieur droit
    path.lineTo(size.width, 0);

    // Contour du reste de la barre
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Painter personnalisé pour dessiner la forme courbe avec CustomPaint
/// Offre plus de contrôle sur le rendu visuel
class CurvedNavPainter extends CustomPainter {
  final Color backgroundColor;
  final double curveDepth;
  final double curveWidth;

  CurvedNavPainter({
    required this.backgroundColor,
    this.curveDepth = 30.0,
    this.curveWidth = 100.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();

    // Point de départ
    path.lineTo(0, 0);

    // Ligne jusqu'au début de la courbe
    path.lineTo((size.width / 2) - curveWidth / 2, 0);

    // Courbe concave au centre
    path.quadraticBezierTo(
      (size.width / 2) - curveWidth / 4,
      0,
      size.width / 2,
      curveDepth,
    );

    path.quadraticBezierTo(
      (size.width / 2) + curveWidth / 4,
      0,
      (size.width / 2) + curveWidth / 2,
      0,
    );

    // Ligne jusqu'au coin droit
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    // Dessiner l'ombre
    canvas.drawShadow(path, Colors.black.withOpacity(0.2), 8.0, false);

    // Dessiner la forme
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}