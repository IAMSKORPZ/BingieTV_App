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
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.5),
                BlendMode.darken,
              ),
            ),
          ),
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
              
              const SizedBox(height: 8), // Minimal gap to move dashboard as high as possible
              
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
                          // Upper Right: Movies & Series (Increased height significantly)
                          Expanded(
                            flex: 72, // Target 35-45% height increase for top row
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
                          
                          // Lower Right: Announcements, Update, Settings (Proportional height)
                          Expanded(
                            flex: 28, // Balanced row height for utility tiles
                            child: Row(
                              children: [
                                Expanded(
                                  child: HomeTile(
                                    title: config.announcement.enabled && config.announcement.title.isNotEmpty 
                                        ? config.announcement.title.toUpperCase() 
                                        : 'NEWS',
                                    subtitle: config.announcement.enabled && config.announcement.message.isNotEmpty 
                                        ? config.announcement.message 
                                        : 'Service alerts',
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
              
              // Increased gap before footer to move dashboard up and clear space
              const SizedBox(height: 50),
              
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
