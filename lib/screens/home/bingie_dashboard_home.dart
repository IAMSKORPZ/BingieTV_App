import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/home_tile.dart';
import 'widgets/home_header.dart';
import 'widgets/home_footer.dart';
import 'home_theme.dart';

class BingieDashboardHome extends StatelessWidget {
  final VoidCallback onLiveTv;
  final VoidCallback onMovies;
  final VoidCallback onSeries;
  final VoidCallback onAnnouncements;
  final VoidCallback onUpdate;
  final VoidCallback onSettings;
  final VoidCallback onSearch;
  final VoidCallback onProfile;
  final VoidCallback onAbout;
  final String username;
  final String expiryDate;
  final String version;

  const BingieDashboardHome({
    super.key,
    required this.onLiveTv,
    required this.onMovies,
    required this.onSeries,
    required this.onAnnouncements,
    required this.onUpdate,
    required this.onSettings,
    required this.onSearch,
    required this.onProfile,
    required this.onAbout,
    required this.username,
    required this.expiryDate,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 850;

        return Container(
          color: HomeTheme.background,
          padding: EdgeInsets.all(isSmall ? 14 : 24),
          child: Column(
            children: [
              HomeHeader(
                onSearch: onSearch,
                onProfile: onProfile,
                onAbout: onAbout,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isSmall
                    ? _MobileHomeGrid(
                        onLiveTv: onLiveTv,
                        onMovies: onMovies,
                        onSeries: onSeries,
                        onAnnouncements: onAnnouncements,
                        onUpdate: onUpdate,
                        onSettings: onSettings,
                      )
                    : _TvHomeGrid(
                        onLiveTv: onLiveTv,
                        onMovies: onMovies,
                        onSeries: onSeries,
                        onAnnouncements: onAnnouncements,
                        onUpdate: onUpdate,
                        onSettings: onSettings,
                      ),
              ),
              const SizedBox(height: 16),
              HomeFooter(
                username: username,
                expiryDate: expiryDate,
                version: version,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TvHomeGrid extends StatelessWidget {
  final VoidCallback onLiveTv;
  final VoidCallback onMovies;
  final VoidCallback onSeries;
  final VoidCallback onAnnouncements;
  final VoidCallback onUpdate;
  final VoidCallback onSettings;

  const _TvHomeGrid({
    required this.onLiveTv,
    required this.onMovies,
    required this.onSeries,
    required this.onAnnouncements,
    required this.onUpdate,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    const double spacing = 18.0;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: HomeTile(
            title: 'LIVE TV',
            subtitle: 'Watch Live TV Channels',
            icon: Icons.live_tv_rounded,
            colors: HomeTheme.liveTvColors,
            onTap: onLiveTv,
            large: true,
            autofocus: true,
          ),
        ),
        const SizedBox(width: spacing),
        Expanded(
          flex: 8,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: HomeTile(
                        title: 'MOVIES',
                        subtitle: 'Browse and watch movies',
                        icon: Icons.play_circle_outline_rounded,
                        colors: HomeTheme.moviesColors,
                        onTap: onMovies,
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      child: HomeTile(
                        title: 'SERIES',
                        subtitle: 'Discover and binge series',
                        icon: Icons.movie_creation_outlined,
                        colors: HomeTheme.seriesColors,
                        onTap: onSeries,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: spacing),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: HomeTile(
                        title: 'ANNOUNCEMENTS',
                        subtitle: 'Stay updated with news',
                        icon: Icons.campaign_outlined,
                        colors: HomeTheme.darkTileColors,
                        iconColor: HomeTheme.iconAnnouncements,
                        onTap: onAnnouncements,
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      child: HomeTile(
                        title: 'UPDATE',
                        subtitle: 'Refresh all content',
                        icon: Icons.sync_rounded,
                        colors: HomeTheme.darkTileColors,
                        iconColor: HomeTheme.iconUpdate,
                        onTap: onUpdate,
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      child: HomeTile(
                        title: 'SETTINGS',
                        subtitle: 'Customize experience',
                        icon: Icons.settings_outlined,
                        colors: HomeTheme.darkTileColors,
                        iconColor: HomeTheme.iconSettings,
                        onTap: onSettings,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileHomeGrid extends StatelessWidget {
  final VoidCallback onLiveTv;
  final VoidCallback onMovies;
  final VoidCallback onSeries;
  final VoidCallback onAnnouncements;
  final VoidCallback onUpdate;
  final VoidCallback onSettings;

  const _MobileHomeGrid({
    required this.onLiveTv,
    required this.onMovies,
    required this.onSeries,
    required this.onAnnouncements,
    required this.onUpdate,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        HomeTile(title: 'LIVE TV', subtitle: 'Watch channels', icon: Icons.live_tv_rounded, colors: HomeTheme.liveTvColors, onTap: onLiveTv, autofocus: true),
        HomeTile(title: 'MOVIES', subtitle: 'Browse movies', icon: Icons.play_circle_outline_rounded, colors: HomeTheme.moviesColors, onTap: onMovies),
        HomeTile(title: 'SERIES', subtitle: 'Watch series', icon: Icons.movie_creation_outlined, colors: HomeTheme.seriesColors, onTap: onSeries),
        HomeTile(title: 'NEWS', subtitle: 'Announcements', icon: Icons.campaign_outlined, colors: HomeTheme.darkTileColors, iconColor: HomeTheme.iconAnnouncements, onTap: onAnnouncements),
        HomeTile(title: 'UPDATE', subtitle: 'Refresh all', icon: Icons.sync_rounded, colors: HomeTheme.darkTileColors, iconColor: HomeTheme.iconUpdate, onTap: onUpdate),
        HomeTile(title: 'SETTINGS', subtitle: 'App options', icon: Icons.settings_outlined, colors: HomeTheme.darkTileColors, iconColor: HomeTheme.iconSettings, onTap: onSettings),
      ],
    );
  }
}
