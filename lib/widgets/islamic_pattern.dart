import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ramadan_planner/utils/constants.dart';

/// A widget that displays an Islamic geometric pattern as a decorative background
/// This creates a custom painted design with Islamic motifs
class IslamicPattern extends StatelessWidget {
  final double height;
  final Color? backgroundColor;
  final Color? patternColor;

  const IslamicPattern({
    super.key,
    required this.height,
    this.backgroundColor,
    this.patternColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: backgroundColor ?? AppConstants.primaryColor,
      child: CustomPaint(
        painter: IslamicPatternPainter(
          patternColor: patternColor ?? Colors.white.withOpacity(0.15),
        ),
        child: Container(),
      ),
    );
  }
}

/// Custom painter that draws an Islamic geometric pattern
class IslamicPatternPainter extends CustomPainter {
  final Color patternColor;

  IslamicPatternPainter({required this.patternColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Paint paint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw a grid of star patterns
    final double cellSize = height / 2;
    final double spacing = cellSize;
    
    for (double y = -spacing; y < height + spacing; y += spacing) {
      for (double x = -spacing; x < width + spacing; x += spacing) {
        _drawStarPattern(canvas, paint, Offset(x, y), cellSize * 0.6);
      }
    }
    
    // Add arches along the bottom
    final double archWidth = width / 10;
    final double archHeight = height * 0.3;
    
    for (double x = 0; x < width; x += archWidth) {
      final Rect rect = Rect.fromLTWH(
        x,
        height - archHeight,
        archWidth,
        archHeight * 2,
      );
      
      canvas.drawArc(
        rect,
        math.pi,
        -math.pi,
        false,
        paint,
      );
    }
  }
  
  void _drawStarPattern(Canvas canvas, Paint paint, Offset center, double radius) {
    final int points = 8; // 8-pointed star common in Islamic art
    
    final List<Offset> innerPoints = [];
    final List<Offset> outerPoints = [];
    
    for (int i = 0; i < points; i++) {
      final double angle = i * (2 * math.pi / points);
      final double innerRadius = radius * 0.4;
      
      outerPoints.add(Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      ));
      
      innerPoints.add(Offset(
        center.dx + innerRadius * math.cos(angle + math.pi / points),
        center.dy + innerRadius * math.sin(angle + math.pi / points),
      ));
    }
    
    final Path path = Path();
    
    // Combine points to form star
    for (int i = 0; i < points; i++) {
      final Offset outerPoint = outerPoints[i];
      final Offset innerPoint = innerPoints[i];
      final Offset nextOuterPoint = outerPoints[(i + 1) % points];
      
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      }
      
      path.lineTo(innerPoint.dx, innerPoint.dy);
      path.lineTo(nextOuterPoint.dx, nextOuterPoint.dy);
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // Draw inner circle
    canvas.drawCircle(center, radius * 0.2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}