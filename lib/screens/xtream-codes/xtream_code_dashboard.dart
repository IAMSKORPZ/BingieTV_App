import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/models/playlist_model.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:another_iptv_player/controllers/xtream_code_home_controller.dart';
import 'package:another_iptv_player/widgets/tv_focusable.dart';

class XtreamCodeDashboard extends StatefulWidget {
  final Playlist playlist;
  final XtreamCodeHomeController controller;
  final VoidCallback? onSearchTap;

  const XtreamCodeDashboard({
    super.key,
    required this.playlist,
    required this.controller,
    this.onSearchTap,
  });

  @override
  State<XtreamCodeDashboard> createState() => _XtreamCodeDashboardState();
}

class _XtreamCodeDashboardState extends State<XtreamCodeDashboard> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E21), Color(0xFF1D1E33)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmallHeight = constraints.maxHeight < 500;
            
            return SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, isSmallHeight),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.05,
                        vertical: isSmallHeight ? 5 : 10,
                      ),
                      child: _buildMainGrid(context, isSmallHeight),
                    ),
                  ),
                  _buildFooter(context, isSmallHeight),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: isSmallHeight ? 10.0 : 20.0,
      ),
      child: Row(
        children: [
          // Logo Section
          Expanded(
            flex: 3,
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Image.asset('assets/logo.png', height: isSmallHeight ? 35 : 50, 
                    errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.tv, color: Colors.blue, size: isSmallHeight ? 30 : 40)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('BINGIETV',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallHeight ? 18 : 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text('PRO',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: isSmallHeight ? 10 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Time/Date Section
          if (!isSmallHeight)
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat('hh:mm a').format(_now),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
                  Text(DateFormat('MMM d, yyyy').format(_now),
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            )
          else
             Expanded(
               flex: 2,
               child: Center(
                 child: Text(DateFormat('hh:mm a').format(_now),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
               ),
             ),

          // Actions Section
          Expanded(
            flex: 4,
            child: FittedBox(
              alignment: Alignment.centerRight,
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildHeaderAction(Icons.search, context.loc.search, () => widget.onSearchTap?.call()),
                  _buildHeaderAction(Icons.refresh, 'Update', () => widget.controller.refreshAllData(context)),
                  _buildHeaderAction(Icons.settings_outlined, context.loc.settings, () => widget.controller.onNavigationTap(5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: TvFocusable(
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainGrid(BuildContext context, bool isSmallHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left: LIVE TV
        Expanded(
          flex: 2,
          child: _buildMainTile(
            title: 'LIVE TV',
            subtitle: 'Watch Live TV Channels',
            icon: Icons.live_tv_rounded,
            gradient: const [Color(0xFF6A11CB), Color(0xFF2575FC)],
            badge: 'LIVE',
            isSmallHeight: isSmallHeight,
            onTap: () => widget.controller.onNavigationTap(2),
          ),
        ),
        const SizedBox(width: 15),
        // Right Column: Movies, Series and Bottom Row
        Expanded(
          flex: 4,
          child: Column(
            children: [
              // Top Row: MOVIES & SERIES
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildMainTile(
                        title: 'MOVIES',
                        subtitle: 'Watch Movies',
                        icon: Icons.play_circle_fill_rounded,
                        gradient: const [Color(0xFFFF0844), Color(0xFFFFB199)],
                        isSmallHeight: isSmallHeight,
                        onTap: () => widget.controller.onNavigationTap(3),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildMainTile(
                        title: 'SERIES',
                        subtitle: 'Binge Series',
                        icon: Icons.movie_filter_rounded,
                        gradient: const [Color(0xFF0BA360), Color(0xFF3CBA92)],
                        isSmallHeight: isSmallHeight,
                        onTap: () => widget.controller.onNavigationTap(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Bottom Row: Small utilities
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSmallTile(
                        title: 'HISTORY',
                        icon: Icons.history,
                        isSmallHeight: isSmallHeight,
                        onTap: () => widget.controller.onNavigationTap(1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildSmallTile(
                        title: 'FAVORITES',
                        icon: Icons.favorite,
                        isSmallHeight: isSmallHeight,
                        onTap: () => widget.controller.onNavigationTap(1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildSmallTile(
                        title: 'SETTINGS',
                        icon: Icons.settings,
                        iconColor: Colors.orange,
                        isSmallHeight: isSmallHeight,
                        onTap: () => widget.controller.onNavigationTap(5),
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

  Widget _buildMainTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    String? badge,
    required bool isSmallHeight,
    required VoidCallback onTap,
  }) {
    return TvFocusable(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            if (badge != null && !isSmallHeight)
              Positioned(
                top: 10, left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.white, size: 6),
                      const SizedBox(width: 4),
                      Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: isSmallHeight ? 40 : 60),
                  SizedBox(height: isSmallHeight ? 5 : 10),
                  Text(title, style: TextStyle(color: Colors.white, fontSize: isSmallHeight ? 18 : 24, fontWeight: FontWeight.w900)),
                  if (!isSmallHeight)
                    Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallTile({
    required String title,
    required IconData icon,
    Color iconColor = Colors.blue,
    required bool isSmallHeight,
    required VoidCallback onTap,
  }) {
    return TvFocusable(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: isSmallHeight ? 20 : 30),
            const SizedBox(width: 10),
            Flexible(
              child: Text(title,
                style: TextStyle(color: Colors.white, fontSize: isSmallHeight ? 12 : 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isSmallHeight) {
    final userInfo = widget.controller.userInfo;
    String expiration = 'Lifetime';
    if (userInfo?.userInfo.expDate != null) {
      try {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(userInfo!.userInfo.expDate!) * 1000);
        expiration = DateFormat('MMM d, yyyy').format(date);
      } catch (_) {}
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: isSmallHeight ? 5 : 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            child: Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.purpleAccent, size: 14),
                const SizedBox(width: 5),
                Text('Exp: $expiration', style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          if (!isSmallHeight)
            const Text('By using this app, you agree to the Terms of Service.',
              style: TextStyle(color: Colors.grey, fontSize: 9)),
          Text('User: ${userInfo?.userInfo.username ?? "Guest"}',
            style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
