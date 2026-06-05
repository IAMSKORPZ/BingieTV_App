import 'package:another_iptv_player/controllers/branding_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaintenanceBanner extends StatelessWidget {
  final Widget child;

  const MaintenanceBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final maintenance = context.watch<BrandingController>().maintenance;
    if (!maintenance.enabled) return child;

    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.errorContainer,
          child: SafeArea(
            bottom: false,
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.warning_amber_outlined),
              title: Text(maintenance.title),
              subtitle: Text(maintenance.message),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
