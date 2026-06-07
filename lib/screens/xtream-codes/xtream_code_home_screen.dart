import 'package:another_iptv_player/models/api_configuration_model.dart';
import 'package:another_iptv_player/repositories/iptv_repository.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/xtream_code_home_controller.dart';
import '../../models/playlist_model.dart';
import '../../models/content_type.dart';
import '../../shared/widgets/app_shell.dart';
import '../home/bingie_home_screen.dart';
import '../watch_history_screen.dart';
import 'xtream_code_playlist_settings_screen.dart';
import '../../l10n/localization_extension.dart';
import '../search_screen.dart';

import '../movies/xtream_movies_screen.dart';
import '../series/xtream_series_screen.dart';
import '../live_stream/xtream_live_screen.dart';

class XtreamCodeHomeScreen extends StatefulWidget {
  final Playlist playlist;

  const XtreamCodeHomeScreen({super.key, required this.playlist});

  @override
  State<XtreamCodeHomeScreen> createState() => _XtreamCodeHomeScreenState();
}

class _XtreamCodeHomeScreenState extends State<XtreamCodeHomeScreen> {
  late XtreamCodeHomeController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    final repository = IptvRepository(
      ApiConfig(
        baseUrl: widget.playlist.url ?? '',
        username: widget.playlist.username ?? '',
        password: widget.playlist.password ?? '',
      ),
      widget.playlist.id,
    );
    AppState.xtreamCodeRepository = repository;
    AppState.currentPlaylist = widget.playlist;
    _controller = XtreamCodeHomeController(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<XtreamCodeHomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final navItems = [
            (icon: Icons.home_rounded, label: context.loc.home),
            (icon: Icons.history_rounded, label: context.loc.history),
            (icon: Icons.live_tv_rounded, label: context.loc.live_streams),
            (icon: Icons.movie_rounded, label: context.loc.movies),
            (icon: Icons.tv_rounded, label: context.loc.series_plural),
            (icon: Icons.settings_rounded, label: context.loc.settings),
          ];

          return AppShell(
            currentIndex: controller.currentIndex,
            onIndexChanged: controller.onNavigationTap,
            navItems: navItems,
            onSearchTap: () => _navigateToSearch(context, ContentType.liveStream),
            onRefreshTap: () => controller.refreshAllData(context),
            onSettingsTap: () => controller.onNavigationTap(5),
            pages: [
              BingieHomeScreen(
                onCategoryTap: controller.onNavigationTap,
                onSearchTap: () => _navigateToSearch(context, ContentType.liveStream),
              ),
              WatchHistoryScreen(playlistId: widget.playlist.id),
              const XtreamLiveScreen(),
              const XtreamMoviesScreen(),
              const XtreamSeriesScreen(),
              XtreamCodePlaylistSettingsScreen(playlist: widget.playlist),
            ],
          );
        },
      ),
    );
  }

  void _navigateToSearch(BuildContext context, ContentType contentType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(contentType: contentType),
      ),
    );
  }
}
