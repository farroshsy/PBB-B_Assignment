import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ramadan_planner/utils/constants.dart';

/// A widget that displays a Dua (Islamic supplication) with Arabic text,
/// translation, and interactive features
class DuaCard extends StatefulWidget {
  final String arabicText;
  final String translation;
  final String transliteration;
  final String? reference;
  final String? benefit;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DuaCard({
    super.key,
    required this.arabicText,
    required this.translation,
    required this.transliteration,
    this.reference,
    this.benefit,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<DuaCard> createState() => _DuaCardState();
}

class _DuaCardState extends State<DuaCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  
  // Feedback message when copying text
  bool _showCopyFeedback = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _copyDuaToClipboard() {
    final String textToCopy = 
        '${widget.arabicText}\n\n${widget.transliteration}\n\n${widget.translation}';
    
    Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      setState(() {
        _showCopyFeedback = true;
      });
      
      // Hide feedback after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCopyFeedback = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: _toggleExpand,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main content (always visible)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic text
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            widget.arabicText,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.8,
                              fontFamily: 'Amiri', // Make sure this font supports Arabic
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isFavorite
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: widget.onFavoriteToggle,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Translation (visible always)
                  Text(
                    widget.translation,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            
            // Interactive buttons
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Expand button
                  TextButton.icon(
                    onPressed: _toggleExpand,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: _expandAnimation,
                      color: AppConstants.primaryColor,
                    ),
                    label: Text(
                      _isExpanded ? 'Less' : 'More',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  
                  // Copy button with feedback
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _copyDuaToClipboard,
                        icon: const Icon(
                          Icons.content_copy,
                          color: AppConstants.primaryColor,
                        ),
                        label: const Text(
                          'Copy',
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ),
                      if (_showCopyFeedback)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Copied!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Expandable content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Transliteration
                          const Text(
                            'Transliteration:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.transliteration,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          
                          if (widget.reference != null) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Reference:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.reference!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                          
                          if (widget.benefit != null) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Benefit:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.benefit!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}