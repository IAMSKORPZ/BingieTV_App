import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/screens/m3u/m3u_home_screen.dart';
import 'package:another_iptv_player/screens/playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/config_service.dart';
import '../../repositories/user_preferences.dart';
import '../../services/app_state.dart';
import '../../services/playlist_service.dart';
import 'xtream-codes/xtream_code_home_screen.dart';

class AppInitializerScreen extends StatefulWidget {
  const AppInitializerScreen({super.key});

  @override
  State<AppInitializerScreen> createState() => _AppInitializerScreenState();
}

class _AppInitializerScreenState extends State<AppInitializerScreen> {
  bool _isLoading = true;
  Playlist? _lastPlaylist;

  @override
  void initState() {
    super.initState();
    _lockOrientation();
    _loadLastPlaylist();
  }

  Future<void> _lockOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _loadLastPlaylist() async {
    final lastPlaylistId = await UserPreferences.getLastPlaylist();

    if (lastPlaylistId != null) {
      final playlist = await PlaylistService.getPlaylistById(lastPlaylistId);
      if (playlist != null) {
        AppState.currentPlaylist = playlist;
        _lastPlaylist = playlist;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final configService = context.watch<ConfigService>();
    
    if (_isLoading || configService.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_lastPlaylist == null) {
      return const PlaylistScreen();
    } else {
      switch (_lastPlaylist!.type) {
        case PlaylistType.xtream:
          return XtreamCodeHomeScreen(playlist: _lastPlaylist!);
        case PlaylistType.m3u:
          return M3UHomeScreen(playlist: _lastPlaylist!);
      }
    }
  }
}
