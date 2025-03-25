import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme.dart';

class IslamicPatterns {
  // Generic geometric pattern background
  static Widget geometricPattern({
    Color color = AppTheme.primaryColor,
    double opacity = 1.0,
  }) {
    return Container(
      color: Colors.transparent,
      child: SvgPicture.asset(
        'lib/assets/patterns/geometric_pattern.svg',
        color: color,
        opacity: AlwaysStoppedAnimation(opacity),
        fit: BoxFit.cover,
      ),
    );
  }

  // Crescent moon
  static Widget crescentMoon({
    Color color = AppTheme.primaryColor,
    double size = 24,
    double opacity = 1.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        'lib/assets/patterns/crescent_moon.svg',
        color: color,
        opacity: AlwaysStoppedAnimation(opacity),
      ),
    );
  }

  // Star pattern
  static Widget starPattern({
    Color color = AppTheme.primaryColor,
    double opacity = 1.0,
  }) {
    // Programmatically create an Islamic star pattern
    return CustomPaint(
      painter: StarPatternPainter(
        color: color,
        opacity: opacity,
      ),
    );
  }

  // Mosque silhouette
  static Widget mosqueSilhouette({
    Color color = AppTheme.primaryColor,
    double size = 100,
    double opacity = 1.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MosqueSilhouettePainter(
          color: color,
          opacity: opacity,
        ),
      ),
    );
  }
}

// Star pattern painter
class StarPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  StarPatternPainter({
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 2 * 0.9 : size.height / 2 * 0.9;

    // Draw 8-point star
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final outerAngle = i * 2 * 3.14159 / 8;
      final innerAngle = outerAngle + 3.14159 / 8;

      final outerX = center.dx + radius * cos(outerAngle);
      final outerY = center.dy + radius * sin(outerAngle);
      final innerX = center.dx + radius * 0.4 * cos(innerAngle);
      final innerY = center.dy + radius * 0.4 * sin(innerAngle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Mosque silhouette painter
class MosqueSilhouettePainter extends CustomPainter {
  final Color color;
  final double opacity;

  MosqueSilhouettePainter({
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Base of the mosque
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(0, size.height * 0.7);
    path.close();
    
    // Main dome
    final dome = Path();
    dome.addOval(Rect.fromCircle(
      center: Offset(size.width * 0.5, size.height * 0.5),
      radius: size.width * 0.2,
    ));
    path.addPath(dome, Offset.zero);
    
    // Minarets
    final minaret1 = Path();
    minaret1.moveTo(size.width * 0.15, size.height * 0.7);
    minaret1.lineTo(size.width * 0.15, size.height * 0.3);
    minaret1.lineTo(size.width * 0.2, size.height * 0.25);
    minaret1.lineTo(size.width * 0.25, size.height * 0.3);
    minaret1.lineTo(size.width * 0.25, size.height * 0.7);
    path.addPath(minaret1, Offset.zero);
    
    final minaret2 = Path();
    minaret2.moveTo(size.width * 0.75, size.height * 0.7);
    minaret2.lineTo(size.width * 0.75, size.height * 0.3);
    minaret2.lineTo(size.width * 0.8, size.height * 0.25);
    minaret2.lineTo(size.width * 0.85, size.height * 0.3);
    minaret2.lineTo(size.width * 0.85, size.height * 0.7);
    path.addPath(minaret2, Offset.zero);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Helper function to convert degrees to radians
double radians(double degrees) => degrees * 3.14159 / 180;
