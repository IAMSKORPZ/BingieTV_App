import 'package:flutter/material.dart';
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
        // Unified scaling logic
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        
        // Adjust spacing and padding proportionally
        final double outerPadding = width * 0.03;
        final double internalSpacing = width * 0.015;
        
        return Container(
          color: HomeTheme.background,
          padding: EdgeInsets.symmetric(
            horizontal: outerPadding,
            vertical: outerPadding * 0.5,
          ),
          child: Column(
            children: [
              HomeHeader(
                onSearch: onSearch,
                onProfile: onProfile,
                onAbout: onAbout,
              ),
              SizedBox(height: internalSpacing),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LEFT: Large Live TV Tile
                    Expanded(
                      flex: 4,
                      child: HomeTile(
                        title: 'LIVE TV',
                        subtitle: 'Watch Live Channels',
                        icon: Icons.live_tv_rounded,
                        colors: HomeTheme.liveTvColors,
                        onTap: onLiveTv,
                        large: true,
                        autofocus: true,
                      ),
                    ),
                    SizedBox(width: internalSpacing),
                    // RIGHT SIDE: Grid area
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          // TOP ROW: Movies & Series
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: HomeTile(
                                    title: 'MOVIES',
                                    subtitle: 'Browse VOD',
                                    icon: Icons.play_circle_outline_rounded,
                                    colors: HomeTheme.moviesColors,
                                    onTap: onMovies,
                                  ),
                                ),
                                SizedBox(width: internalSpacing),
                                Expanded(
                                  child: HomeTile(
                                    title: 'SERIES',
                                    subtitle: 'Watch TV Shows',
                                    icon: Icons.movie_creation_outlined,
                                    colors: HomeTheme.seriesColors,
                                    onTap: onSeries,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: internalSpacing),
                          // BOTTOM ROW: Announcements, Update, Settings
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: HomeTile(
                                    title: 'INFO',
                                    subtitle: 'Service News',
                                    icon: Icons.campaign_outlined,
                                    colors: HomeTheme.darkTileColors,
                                    iconColor: HomeTheme.iconAnnouncements,
                                    onTap: onAnnouncements,
                                  ),
                                ),
                                SizedBox(width: internalSpacing),
                                Expanded(
                                  child: HomeTile(
                                    title: 'UPDATE',
                                    subtitle: 'Refresh All',
                                    icon: Icons.sync_rounded,
                                    colors: HomeTheme.darkTileColors,
                                    iconColor: HomeTheme.iconUpdate,
                                    onTap: onUpdate,
                                  ),
                                ),
                                SizedBox(width: internalSpacing),
                                Expanded(
                                  child: HomeTile(
                                    title: 'SETTINGS',
                                    subtitle: 'App Options',
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
                ),
              ),
              SizedBox(height: internalSpacing * 0.8),
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
