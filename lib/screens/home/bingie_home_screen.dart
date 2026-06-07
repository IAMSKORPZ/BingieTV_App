import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../controllers/xtream_code_home_controller.dart';
import '../../controllers/branding_controller.dart';
import '../../l10n/localization_extension.dart';
import 'home_theme.dart';
import 'widgets/home_tile.dart';
import 'widgets/home_header.dart';
import 'widgets/home_footer.dart';

class BingieHomeScreen extends StatefulWidget {
  final Function(int) onCategoryTap;
  final VoidCallback onSearchTap;

  const BingieHomeScreen({
    super.key,
    required this.onCategoryTap,
    required this.onSearchTap,
  });

  @override
  State<BingieHomeScreen> createState() => _BingieHomeScreenState();
}

class _BingieHomeScreenState extends State<BingieHomeScreen> {
  String _version = '1.3.0';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _version = info.version);
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF101827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About BingieTV', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('BingieTV is a premium IPTV player designed for the best streaming experience.', 
              style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Text('Version: $_version', style: const TextStyle(color: Colors.white54)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAnnouncements(BuildContext context) {
    final branding = context.read<BrandingController>();
    final active = branding.activeAnnouncements;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.locMaybe?.announcements ?? 'Announcements',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: active.isEmpty
                ? const Center(child: Text('No active announcements', style: TextStyle(color: Colors.white54)))
                : ListView.separated(
                    itemCount: active.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final item = active[index];
                      return ListTile(
                        title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Text(item.body, style: const TextStyle(color: Colors.white70)),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshAllContent(BuildContext context, XtreamCodeHomeController controller) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing all content...'), duration: Duration(seconds: 2)),
    );
    controller.refreshAllData(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<XtreamCodeHomeController>();
    final userInfo = controller.userInfo?.userInfo;

    return Scaffold(
      backgroundColor: HomeTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmall = constraints.maxWidth < 900;
            final double padding = isSmall ? 16 : 24;

            return Padding(
              padding: EdgeInsets.fromLTRB(padding, 12, padding, 12),
              child: Column(
                children: [
                  HomeHeader(
                    onSearch: widget.onSearchTap,
                    onProfile: () => widget.onCategoryTap(5),
                    onAbout: () => _showAboutDialog(context),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: isSmall
                        ? _MobileHomeGrid(
                            openLiveTV: () => widget.onCategoryTap(2),
                            openMovies: () => widget.onCategoryTap(3),
                            openSeries: () => widget.onCategoryTap(4),
                            openAnnouncements: () => _showAnnouncements(context),
                            refreshAllContent: () => _refreshAllContent(context, controller),
                            openSettings: () => widget.onCategoryTap(5),
                          )
                        : _TvHomeGrid(
                            openLiveTV: () => widget.onCategoryTap(2),
                            openMovies: () => widget.onCategoryTap(3),
                            openSeries: () => widget.onCategoryTap(4),
                            openAnnouncements: () => _showAnnouncements(context),
                            refreshAllContent: () => _refreshAllContent(context, controller),
                            openSettings: () => widget.onCategoryTap(5),
                          ),
                  ),
                  const SizedBox(height: 12),
                  HomeFooter(
                    username: userInfo?.username ?? 'Guest',
                    expiryDate: userInfo?.expDate ?? 'N/A',
                    version: _version,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TvHomeGrid extends StatelessWidget {
  final VoidCallback openLiveTV;
  final VoidCallback openMovies;
  final VoidCallback openSeries;
  final VoidCallback openAnnouncements;
  final VoidCallback refreshAllContent;
  final VoidCallback openSettings;

  const _TvHomeGrid({
    required this.openLiveTV,
    required this.openMovies,
    required this.openSeries,
    required this.openAnnouncements,
    required this.refreshAllContent,
    required this.openSettings,
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
            subtitle: 'Watch Live Channels',
            icon: Icons.live_tv_rounded,
            colors: HomeTheme.liveTvColors,
            onTap: openLiveTV,
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
                        subtitle: 'Browse VOD',
                        icon: Icons.play_circle_outline_rounded,
                        colors: HomeTheme.moviesColors,
                        onTap: openMovies,
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      child: HomeTile(
                        title: 'SERIES',
                        subtitle: 'Watch TV Shows',
                        icon: Icons.movie_creation_outlined,
                        colors: HomeTheme.seriesColors,
                        onTap: openSeries,
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
                        subtitle: 'Service News',
                        icon: Icons.campaign_outlined,
                        colors: HomeTheme.darkTileColors,
                        iconColor: HomeTheme.iconAnnouncements,
                        onTap: openAnnouncements,
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      child: HomeTile(
                        title: 'UPDATE',
                        subtitle: 'Refresh Content',
                        icon: Icons.sync_rounded,
                        colors: HomeTheme.darkTileColors,
                        iconColor: HomeTheme.iconUpdate,
                        onTap: refreshAllContent,
                      ),
                    ),
                    const SizedBox(width: spacing),
                    Expanded(
                      child: HomeTile(
                        title: 'SETTINGS',
                        subtitle: 'App Options',
                        icon: Icons.settings_outlined,
                        colors: HomeTheme.darkTileColors,
                        iconColor: HomeTheme.iconSettings,
                        onTap: openSettings,
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
  final VoidCallback openLiveTV;
  final VoidCallback openMovies;
  final VoidCallback openSeries;
  final VoidCallback openAnnouncements;
  final VoidCallback refreshAllContent;
  final VoidCallback openSettings;

  const _MobileHomeGrid({
    required this.openLiveTV,
    required this.openMovies,
    required this.openSeries,
    required this.openAnnouncements,
    required this.refreshAllContent,
    required this.openSettings,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: [
        HomeTile(title: 'LIVE TV', subtitle: 'Live Channels', icon: Icons.live_tv_rounded, colors: HomeTheme.liveTvColors, onTap: openLiveTV, autofocus: true),
        HomeTile(title: 'MOVIES', subtitle: 'Browse VOD', icon: Icons.play_circle_outline_rounded, colors: HomeTheme.moviesColors, onTap: openMovies),
        HomeTile(title: 'SERIES', subtitle: 'TV Shows', icon: Icons.movie_creation_outlined, colors: HomeTheme.seriesColors, onTap: openSeries),
        HomeTile(title: 'NEWS', subtitle: 'Announcements', icon: Icons.campaign_outlined, colors: HomeTheme.darkTileColors, iconColor: HomeTheme.iconAnnouncements, onTap: openAnnouncements),
        HomeTile(title: 'UPDATE', subtitle: 'Refresh all', icon: Icons.sync_rounded, colors: HomeTheme.darkTileColors, iconColor: HomeTheme.iconUpdate, onTap: refreshAllContent),
        HomeTile(title: 'SETTINGS', subtitle: 'App options', icon: Icons.settings_outlined, colors: HomeTheme.darkTileColors, iconColor: HomeTheme.iconSettings, onTap: openSettings),
      ],
    );
  }
}
