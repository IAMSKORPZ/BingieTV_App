import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool focused = false;
  bool hovered = false;

  bool get active => focused || hovered;

  @override
  Widget build(BuildContext context) {
    final Color mainColor = widget.iconColor ?? Colors.white;

    return FocusableActionDetector(
      autofocus: widget.autofocus,
      onFocusChange: (value) => setState(() => focused = value),
      onShowHoverHighlight: (value) => setState(() => hovered = value),
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
        scale: active ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: EdgeInsets.all(widget.large ? 24 : 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.colors,
              ),
              border: Border.all(
                color: active ? Colors.white : Colors.white.withOpacity(0.12),
                width: active ? 3 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: active ? widget.colors.first.withOpacity(0.5) : Colors.black.withOpacity(0.2),
                  blurRadius: active ? 24 : 12,
                  spreadRadius: active ? 1 : 0,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon, 
                  color: mainColor, 
                  size: widget.large ? 72 : 44
                ),
                SizedBox(height: widget.large ? 16 : 12),
                FittedBox(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.large ? 32 : 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: widget.large ? 15 : 13,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
