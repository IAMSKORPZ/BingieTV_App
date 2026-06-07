import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onProfile;
  final VoidCallback onAbout;

  const HomeHeader({
    super.key,
    required this.onSearch,
    required this.onProfile,
    required this.onAbout,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 600;
        
        return Row(
          children: [
            // Left: Logo (Branding text removed)
            Image.asset(
              'assets/images/App_Logo.png',
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.play_arrow_rounded, color: Color(0xFF3B82F6), size: 48),
            ),
            const Spacer(),
            // Center: Time & Date (Fixed formatting)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('hh:mm a').format(now),
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: isSmall ? 14 : 16, 
                    fontWeight: FontWeight.w600
                  ),
                ),
                if (!isSmall) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('|', style: TextStyle(color: Colors.white24, fontSize: 16)),
                  ),
                  Text(
                    DateFormat('MMM d, yyyy').format(now),
                    style: const TextStyle(
                      color: Colors.white70, 
                      fontSize: 14, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ],
            ),
            const Spacer(),
            // Right: Actions
            HeaderButton(
              icon: Icons.search, 
              label: 'Search', 
              onTap: onSearch,
              hideLabel: isSmall,
            ),
            HeaderButton(
              icon: Icons.person_outline, 
              label: 'Profile', 
              onTap: onProfile,
              hideLabel: isSmall,
            ),
            HeaderButton(
              icon: Icons.info_outline, 
              label: 'About', 
              onTap: onAbout,
              hideLabel: isSmall,
            ),
          ],
        );
      }
    );
  }
}

class HeaderButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hideLabel;

  const HeaderButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.hideLabel = false,
  });

  @override
  State<HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<HeaderButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FocusableActionDetector(
        onFocusChange: (val) => setState(() => _isFocused = val),
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
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.hideLabel ? 10 : 14, 
              vertical: 8
            ),
            decoration: BoxDecoration(
              color: _isFocused ? Colors.white : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isFocused ? Colors.white : Colors.white.withValues(alpha: 0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon, 
                  color: _isFocused ? Colors.black : Colors.white, 
                  size: 18
                ),
                if (!widget.hideLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.label, 
                    style: TextStyle(
                      color: _isFocused ? Colors.black : Colors.white, 
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
