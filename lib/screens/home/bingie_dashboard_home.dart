import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/config_service.dart';
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
        final config = context.watch<ConfigService>().config;
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        
        // Unified scaling logic for a premium look
        final double horizontalPadding = width * 0.05; // Slightly increased for better aspect ratio
        final double verticalPadding = height * 0.01; // Reduced to give more height to tiles
        final double gap = width * 0.012; // Tighter gaps for a cleaner look

        final homeBg = config.backgrounds.home;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: HomeTheme.background,
            image: DecorationImage(
              image: (homeBg.isNotEmpty)
                  ? NetworkImage(homeBg)
                  : const AssetImage('assets/images/background.png') as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HomeTheme.background.withValues(alpha: 0.4),
                  HomeTheme.background.withValues(alpha: 0.8),
                  HomeTheme.background,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              children: [
                // 1. Header (Fixed height slot)
                HomeHeader(
                  onSearch: onSearch,
                  onProfile: onProfile,
                  onAbout: onAbout,
                ),
                
                const Spacer(flex: 1), // Top breathing room
                
                // 2. Main Dashboard (Fills 75-80% of available space)
                Expanded(
                  flex: 12, // Large flex to dominate height
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // LEFT SIDE: Large LIVE TV (30%)
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
                      
                      // RIGHT SIDE: (70%)
                      Expanded(
                        flex: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Upper Right: Movies & Series
                            Expanded(
                              flex: 70,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            
                            // Lower Right: Announcements, Update, Settings (Static buttons with no descriptions)
                            Expanded(
                              flex: 30,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: HomeTile(
                                      title: 'ANNOUNCEMENTS',
                                      subtitle: '',
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
                                      subtitle: '',
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
                                      subtitle: '',
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
                
                const Spacer(flex: 1), // Bottom breathing room (pushes footer to edge)
                
                // 3. Footer (Pinned to bottom)
                HomeFooter(
                  username: username,
                  expiryDate: expiryDate,
                  version: version,
                ),
              ],
            ),
          ),
          ),
        );
      },
    );
  }
}
