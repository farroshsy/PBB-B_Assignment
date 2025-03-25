import 'package:flutter/material.dart';
import '../utils/theme.dart';

class IslamicLoader extends StatefulWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final bool showCrescentIcon;

  const IslamicLoader({
    Key? key,
    this.size = 40,
    this.color = AppTheme.primaryColor,
    this.strokeWidth = 3.0,
    this.showCrescentIcon = true,
  }) : super(key: key);

  @override
  _IslamicLoaderState createState() => _IslamicLoaderState();
}

class _IslamicLoaderState extends State<IslamicLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Rotating spinner
              RotationTransition(
                turns: _rotationAnimation,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CircularProgressIndicator(
                    strokeWidth: widget.strokeWidth,
                    valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                    backgroundColor: widget.color.withOpacity(0.2),
                  ),
                ),
              ),
              
              // Optional crescent icon
              if (widget.showCrescentIcon)
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Icon(
                    Icons.nightlight_round,
                    size: widget.size * 0.5,
                    color: widget.color,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
