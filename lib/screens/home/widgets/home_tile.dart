import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_theme.dart';

class HomeTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
  final Color? iconColor;
  final VoidCallback onTap;
  final bool large;
  final bool autofocus;

  const HomeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
    required this.onTap,
    this.iconColor,
    this.large = false,
    this.autofocus = false,
  });

  @override
  State<HomeTile> createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  bool _isFocused = false;
  bool _isHovered = false;

  bool get _isActive => _isFocused || _isHovered;

  @override
  Widget build(BuildContext context) {
    final Color mainColor = widget.iconColor ?? Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileHeight = constraints.maxHeight;
        
        // Optimized scaling to prevent overflows while maintaining large TV visuals
        final double iconSize = widget.large ? (tileHeight * 0.28) : (tileHeight * 0.42);
        final double titleSize = widget.large ? (tileHeight * 0.11) : (tileHeight * 0.18);
        final double subtitleSize = titleSize * 0.45;
        final double spacing = widget.large ? (tileHeight * 0.04) : (tileHeight * 0.02);
        final double padding = tileHeight * 0.05;

        return FocusableActionDetector(
          autofocus: widget.autofocus,
          onFocusChange: (value) => setState(() => _isFocused = value),
          onShowHoverHighlight: (value) => setState(() => _isHovered = value),
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap();
                return null;
              },
            ),
          },
          child: AnimatedScale(
            scale: _isActive ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(HomeTheme.borderRadius),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(HomeTheme.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _isActive 
                          ? widget.colors.first.withValues(alpha: 0.8) 
                          : Colors.black.withValues(alpha: 0.3),
                      blurRadius: _isActive ? 45 : 15,
                      spreadRadius: _isActive ? 4 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(HomeTheme.borderRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(HomeTheme.borderRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: widget.colors.map((c) => c.withValues(alpha: 0.65)).toList(),
                        ),
                        border: Border.all(
                          color: _isActive ? Colors.white : Colors.white.withValues(alpha: 0.15),
                          width: _isActive ? 3.5 : 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Only one icon per tile, no faded background icon
                          Icon(widget.icon, color: mainColor, size: iconSize),
                          SizedBox(height: spacing),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          if (widget.subtitle.isNotEmpty && tileHeight > 100) ...[
                            const SizedBox(height: 2),
                            Text(
                              widget.subtitle,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: subtitleSize,
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
