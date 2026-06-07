import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  String _formatExpiry(String date) {
    if (date.isEmpty || date.toLowerCase() == 'n/a') return 'N/A';
    
    // Check if it's a Unix timestamp
    final timestamp = int.tryParse(date);
    if (timestamp != null) {
      // Unix timestamp is usually in seconds
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('dd MMM yyyy').format(dt);
    }
    
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 600;
        final String formattedExpiry = _formatExpiry(expiryDate);
        
        return Row(
          children: [
            _FooterPill(
              icon: Icons.workspace_premium_outlined,
              text: isSmall ? formattedExpiry : 'Expiration: $formattedExpiry',
              color: Colors.amber,
            ),
            const Spacer(),
            if (!isSmall)
              Text(
                'v$version',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 11, fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            _FooterPill(
              icon: Icons.person_outline,
              text: isSmall ? username : 'Logged in: $username',
              color: const Color(0xFF8B5CF6),
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
  final Color color;

  const _FooterPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
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
