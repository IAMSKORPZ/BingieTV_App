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
    return Row(
      children: [
        _FooterPill(
          icon: Icons.workspace_premium_outlined,
          text: 'Expiration: $expiryDate',
        ),
        const Spacer(),
        Text(
          'v$version',
          style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        _FooterPill(
          icon: Icons.person_outline,
          text: 'Logged in: $username',
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF8B5CF6), size: 16),
          const SizedBox(width: 8),
          Text(
            text, 
            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }
}
