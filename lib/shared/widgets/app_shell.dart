import 'dart:async';

import 'package:another_iptv_player/core/theme/theme_extensions.dart';
import 'package:another_iptv_player/models/content_type.dart';
import 'package:another_iptv_player/screens/search_screen.dart';
import 'package:another_iptv_player/screens/settings/provider_list_screen.dart';
import 'package:another_iptv_player/shared/widgets/focus_wrapper.dart';
import 'package:another_iptv_player/shared/widgets/profile_avatar.dart';
import 'package:another_iptv_player/services/app_state.dart';
import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;
  final bool showBack;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.onRefresh,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          child: Column(
            children: [
              AppTopBar(
                title: title,
                showBack: showBack,
                onRefresh: onRefresh,
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

class AppTopBar extends StatefulWidget {
  final String title;
  final Future<void> Function()? onRefresh;
  final bool showBack;

  const AppTopBar({
    super.key,
    required this.title,
    this.onRefresh,
    this.showBack = false,
  });

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  late final Timer _timer;
  DateTime _now = DateTime.now();
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extension = Theme.of(context).extension<BingieThemeExtension>();
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(
            color: extension?.glassBorder ?? Colors.white12,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showBack)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
            ),
          FocusWrapper(
            child: Row(
              children: [
                const Icon(Icons.live_tv, size: 22),
                const SizedBox(width: 8),
                Text(
                  'BingieTV',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const Spacer(),
          Text(
            _formatTime(_now),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 12),
          Text(
            _formatDate(_now),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () {
              if (AppState.currentPlaylist == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(
                    contentType: ContentType.liveStream,
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: widget.onRefresh == null || _refreshing
                ? null
                : () async {
                    setState(() => _refreshing = true);
                    try {
                      await widget.onRefresh?.call();
                    } finally {
                      if (mounted) setState(() => _refreshing = false);
                    }
                  },
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProviderListScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          const ProfileAvatar(label: 'B'),
        ],
      ),
    );
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }
}
