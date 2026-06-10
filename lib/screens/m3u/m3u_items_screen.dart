import 'dart:async';
import 'package:another_iptv_player/l10n/localization_extension.dart';
import 'package:another_iptv_player/models/m3u_item.dart';
import 'package:another_iptv_player/screens/m3u/m3u_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../controllers/m3u_home_controller.dart';
import '../../models/content_type.dart';
import '../../models/playlist_content_model.dart';
import '../../utils/navigate_by_content_type.dart';

class M3uItemsScreen extends StatefulWidget {
  final List<M3uItem> m3uItems;

  const M3uItemsScreen({super.key, required this.m3uItems});

  @override
  State<M3uItemsScreen> createState() => _M3uItemsScreenState();
}

class _M3uItemsScreenState extends State<M3uItemsScreen> {
  int _selectedCategoryIndex = 0;
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _channelScrollController = ScrollController();

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _channelScrollController.dispose();
    super.dispose();
  }

  List<String> _getUniqueGroups() {
    final groups = widget.m3uItems
        .where((item) => item.groupTitle != null)
        .map((item) => item.groupTitle!)
        .toSet()
        .toList();
    groups.sort();
    return ['ALL CHANNELS', ...groups];
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<M3UHomeController>();
    final groups = _getUniqueGroups();
    final selectedGroup = groups[_selectedCategoryIndex];
    
    final filteredItems = selectedGroup == 'ALL CHANNELS'
        ? widget.m3uItems
        : widget.m3uItems.where((item) => item.groupTitle == selectedGroup).toList();

    return Container(
      decoration: const BoxDecoration(color: Color(0xFF050816)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // 1. TOP BAR
                _BrowserTopBar(
                  onBack: () => controller.onNavigationTap(0),
                  onSearch: () {},
                  onProfile: () => controller.onNavigationTap(2),
                ),

                // 2. MAIN CONTENT
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT PANEL: Categories
                      Container(
                        width: 300,
                        padding: const EdgeInsets.fromLTRB(24, 0, 0, 24),
                        child: ListView.separated(
                          controller: _categoryScrollController,
                          itemCount: groups.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _CategoryCard(
                              title: groups[index].toUpperCase(),
                              isSelected: _selectedCategoryIndex == index,
                              onTap: () {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                  if (_channelScrollController.hasClients) _channelScrollController.jumpTo(0);
                                });
                              },
                            );
                          },
                        ),
                      ),

                      // RIGHT PANEL: Channel Grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: filteredItems.isEmpty
                              ? _EmptyChannelsState()
                              : GridView.builder(
                                  controller: _channelScrollController,
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 220,
                                    childAspectRatio: 1.1,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final m3uItem = filteredItems[index];
                                    final channel = ContentItem(
                                      m3uItem.url,
                                      m3uItem.name ?? '',
                                      m3uItem.tvgLogo ?? '',
                                      m3uItem.contentType,
                                      m3uItem: m3uItem,
                                    );
                                    return _ChannelGridCard(
                                      channel: channel,
                                      onTap: () => _onChannelTap(context, m3uItem),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. BOTTOM STATUS BAR
                _BottomStatusBar(
                  username: 'M3U USER',
                  expiryDate: 'LIFETIME',
                  version: '0.0.1',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onChannelTap(BuildContext context, M3uItem m3uItem) {
    if (m3uItem.groupTitle != null &&
        m3uItem.groupTitle!.isNotEmpty &&
        m3uItem.contentType != ContentType.series) {
      navigateByContentType(
        context,
        ContentItem(
          m3uItem.url,
          m3uItem.name ?? '',
          m3uItem.tvgLogo ?? '',
          m3uItem.contentType,
          m3uItem: m3uItem,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => M3uPlayerScreen(
            contentItem: ContentItem(
              m3uItem.id,
              m3uItem.name ?? '',
              m3uItem.tvgLogo ?? '',
              m3uItem.contentType,
              m3uItem: m3uItem,
            ),
          ),
        ),
      );
    }
  }
}

class _BottomStatusBar extends StatelessWidget {
  final String username;
  final String expiryDate;
  final String version;

  const _BottomStatusBar({
    required this.username,
    required this.expiryDate,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.black.withValues(alpha: 0.5),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium_rounded, color: Color(0xFF00B7FF), size: 16),
          const SizedBox(width: 8),
          Text(
            'EXPIRATION: $expiryDate',
            style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            'v$version',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.person_rounded, color: Color(0xFFC12CFF), size: 16),
          const SizedBox(width: 8),
          Text(
            'LOGGED IN: $username'.toUpperCase(),
            style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _BrowserTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onProfile;

  const _BrowserTopBar({
    required this.onBack,
    required this.onSearch,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _HeaderButton(icon: Icons.arrow_back_rounded, onTap: onBack),
          const SizedBox(width: 20),
          Image.asset('assets/images/App_Logo.png', height: 45),
          const Spacer(),
          _BrowserClock(),
          const Spacer(),
          _HeaderButton(icon: Icons.search_rounded, onTap: onSearch),
          const SizedBox(width: 12),
          _HeaderButton(icon: Icons.person_rounded, onTap: onProfile),
          const SizedBox(width: 12),
          _HeaderButton(icon: Icons.more_vert_rounded, onTap: () => _showMoreMenu(context)),
        ],
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    final controller = context.read<M3UHomeController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F1423).withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MenuButton(icon: Icons.movie_rounded, label: 'MOVIES', color: Colors.orange, onTap: () { Navigator.pop(context); controller.onNavigationTap(1); }),
                _MenuButton(icon: Icons.tv_rounded, label: 'SERIES', color: Colors.cyan, onTap: () { Navigator.pop(context); controller.onNavigationTap(1); }),
                _MenuButton(icon: Icons.campaign_rounded, label: 'ALERTS', color: Colors.purple, onTap: () { Navigator.pop(context); }),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MenuButton(icon: Icons.sync_rounded, label: 'REFRESH', color: Colors.blue, onTap: () { Navigator.pop(context); controller.onNavigationTap(0); }),
                _MenuButton(icon: Icons.settings_rounded, label: 'SETTINGS', color: Colors.grey, onTap: () { Navigator.pop(context); controller.onNavigationTap(2); }),
                _MenuButton(icon: Icons.info_rounded, label: 'ABOUT', color: Colors.white, onTap: () { Navigator.pop(context); }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (v) => setState(() => _isFocused = v),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: _isFocused ? 0.3 : 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color.withValues(alpha: 0.4), width: 2),
                ),
                child: Icon(widget.icon, color: widget.color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrowserClock extends StatefulWidget {
  @override
  State<_BrowserClock> createState() => _BrowserClockState();
}

class _BrowserClockState extends State<_BrowserClock> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('hh:mm a').format(_now),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        Text(
          DateFormat('MMM d, yyyy').format(_now).toUpperCase(),
          style: const TextStyle(color: Color(0xFF00B7FF), fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderButton({required this.icon, required this.onTap});

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (v) => setState(() => _isFocused = v),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isFocused ? Colors.white : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isFocused ? Colors.white : Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(widget.icon, color: _isFocused ? Colors.black : Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _isFocused;
    return FocusableActionDetector(
      onFocusChange: (v) => setState(() => _isFocused = v),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFC12CFF).withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: active ? const Color(0xFFC12CFF) : Colors.white.withValues(alpha: 0.05),
                width: active ? 2 : 1,
              ),
              boxShadow: active ? [
                BoxShadow(color: const Color(0xFFC12CFF).withValues(alpha: 0.2), blurRadius: 15),
              ] : [],
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                color: active ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChannelGridCard extends StatefulWidget {
  final ContentItem channel;
  final VoidCallback onTap;

  const _ChannelGridCard({
    required this.channel,
    required this.onTap,
  });

  @override
  State<_ChannelGridCard> createState() => _ChannelGridCardState();
}

class _ChannelGridCardState extends State<_ChannelGridCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (v) => setState(() => _isFocused = v),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1423).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isFocused ? const Color(0xFF00B7FF) : Colors.white.withValues(alpha: 0.05),
                width: _isFocused ? 2.5 : 1,
              ),
              boxShadow: _isFocused ? [
                BoxShadow(color: const Color(0xFF00B7FF).withValues(alpha: 0.3), blurRadius: 20),
              ] : [],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.channel.imagePath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.channel.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.live_tv_rounded, color: Colors.white10, size: 40),
                            ),
                          )
                        : const Icon(Icons.live_tv_rounded, color: Colors.white10, size: 40),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                  child: Text(
                    widget.channel.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyChannelsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tv_off_rounded, size: 80, color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 24),
          const Text(
            'NO CHANNELS FOUND',
            style: TextStyle(color: Colors.white38, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}
