import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/models/stalker_provider_config.dart';
import 'package:another_iptv_player/repositories/stalker_repository.dart';
import 'package:flutter/material.dart';

class StalkerHomeScreen extends StatefulWidget {
  final Playlist playlist;
  final StalkerProviderConfig config;

  const StalkerHomeScreen({
    super.key,
    required this.playlist,
    required this.config,
  });

  @override
  State<StalkerHomeScreen> createState() => _StalkerHomeScreenState();
}

class _StalkerHomeScreenState extends State<StalkerHomeScreen> {
  late final StalkerRepository repository;
  bool isLoading = false;
  String? status;
  String? error;

  @override
  void initState() {
    super.initState();
    repository = StalkerRepository(
      providerId: widget.playlist.id,
      config: widget.config,
    );
  }

  Future<void> _checkSession() async {
    setState(() {
      isLoading = true;
      error = null;
      status = null;
    });
    try {
      final token = await repository.readToken();
      setState(() {
        status = token == null
            ? 'No active Stalker session. Edit provider and authenticate.'
            : 'Stalker session token is available. Lazy loading is ready.';
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.playlist.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.router_outlined),
              title: const Text('Stalker Portal'),
              subtitle: Text(widget.config.portalUrl),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: isLoading ? null : _checkSession,
            icon: const Icon(Icons.verified_user_outlined),
            label: Text(isLoading ? 'Checking...' : 'Check Session'),
          ),
          if (status != null) ...[
            const SizedBox(height: 12),
            Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(status!))),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(error!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
