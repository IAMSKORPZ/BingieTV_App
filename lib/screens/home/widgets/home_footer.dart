import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  final String username;
  final String expiryDate;
  final String version;

  const HomeFooter({
    super.key,
    required this.username,
    required this.expiryDate,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 600;
        
        return Row(
          children: [
            _FooterPill(
              icon: Icons.workspace_premium_outlined,
              text: isSmall ? expiryDate : 'Expiration: $expiryDate',
            ),
            const Spacer(),
            if (!isSmall)
              Text(
                'v$version',
                style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            _FooterPill(
              icon: Icons.person_outline,
              text: isSmall ? username : 'Logged in: $username',
            ),
          ],
        );
      }
    );
  }
}

class _FooterPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FooterPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF8B5CF6), size: 14),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500)
            ),
          ),
        ],
      ),
    );
  }
}
