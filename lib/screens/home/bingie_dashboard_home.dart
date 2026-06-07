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
    // Reinforce fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        
        // Unified scaling logic for a premium look
        final double horizontalPadding = width * 0.04;
        // Reduced vertical padding to lower the footer slightly
        final double verticalPadding = height * 0.02; 
        final double gap = width * 0.015;

        return Container(
          width: width,
          height: height,
          color: HomeTheme.background,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              // 1. Unified Premium Header
              HomeHeader(
                onSearch: onSearch,
                onProfile: onProfile,
                onAbout: onAbout,
              ),
              
              SizedBox(height: gap),
              
              // 2. Main Dashboard (Fixed layout across all platforms)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LEFT SIDE: Large LIVE TV (30% as requested)
                    Expanded(
                      flex: 30,
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
                    
                    SizedBox(width: gap),
                    
                    // RIGHT SIDE: (70% as requested)
                    Expanded(
                      flex: 70,
                      child: Column(
                        children: [
                          // Upper Right: Movies & Series
                          Expanded(
                            flex: 70, // Increased top row flex to reduce bottom row height
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
                                SizedBox(width: gap),
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
                          
                          SizedBox(height: gap),
                          
                          // Lower Right: Announcements, Update, Settings (Height reduced)
                          Expanded(
                            flex: 30, // Reduced bottom row flex as requested
                            child: Row(
                              children: [
                                Expanded(
                                  child: HomeTile(
                                    title: 'NEWS',
                                    subtitle: 'Service alerts',
                                    icon: Icons.campaign_outlined,
                                    colors: HomeTheme.darkTileColors,
                                    iconColor: HomeTheme.iconAnnouncements,
                                    onTap: onAnnouncements,
                                  ),
                                ),
                                SizedBox(width: gap),
                                Expanded(
                                  child: HomeTile(
                                    title: 'UPDATE',
                                    subtitle: 'Refresh app',
                                    icon: Icons.sync_rounded,
                                    colors: HomeTheme.darkTileColors,
                                    iconColor: HomeTheme.iconUpdate,
                                    onTap: onUpdate,
                                  ),
                                ),
                                SizedBox(width: gap),
                                Expanded(
                                  child: HomeTile(
                                    title: 'SETTINGS',
                                    subtitle: 'App options',
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
              
              // Reduced gap before footer to lower its position
              SizedBox(height: gap * 0.3),
              
              // 3. Compact Footer
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
