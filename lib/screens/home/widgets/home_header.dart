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

    return Row(
      children: [
        const Icon(Icons.play_arrow_rounded, color: Color(0xFF3B82F6), size: 24),
        const SizedBox(width: 6),
        const Text(
          'BINGIE',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        const Text(
          'TV',
          style: TextStyle(color: Color(0xFF60A5FA), fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        Text(
          DateFormat('hh:mm a').format(now),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        HeaderButton(icon: Icons.search, label: 'Search', onTap: onSearch),
        HeaderButton(icon: Icons.person_outline, label: 'Profile', onTap: onProfile),
        HeaderButton(icon: Icons.info_outline, label: 'About', onTap: onAbout),
      ],
    );
  }
}

class HeaderButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HeaderButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<HeaderButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _isFocused ? Colors.white : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isFocused ? Colors.white : Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon, 
                  color: _isFocused ? Colors.black : Colors.white, 
                  size: 18
                ),
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
            ),
          ),
        ),
      ),
    );
  }
}
