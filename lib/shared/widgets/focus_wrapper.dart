import 'package:another_iptv_player/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class FocusWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const FocusWrapper({super.key, required this.child, this.onPressed});

  @override
  State<FocusWrapper> createState() => _FocusWrapperState();
}

class _FocusWrapperState extends State<FocusWrapper> {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    final extension = Theme.of(context).extension<BingieThemeExtension>();
    return FocusableActionDetector(
      onShowFocusHighlight: (value) => setState(() => focused = value),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
      },
      child: AnimatedScale(
        scale: focused ? 1.04 : 1,
        duration: const Duration(milliseconds: 120),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: extension?.focusGlow.withValues(alpha: 0.38) ??
                          Colors.white24,
                      blurRadius: 18,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
