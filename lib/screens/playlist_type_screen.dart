import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/playlist_controller.dart';
import '../services/config_service.dart';
import 'm3u/new_m3u_playlist_screen.dart';
import 'xtream-codes/new_xtream_code_playlist_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PlaylistTypeScreen extends StatefulWidget {
  const PlaylistTypeScreen({super.key});

  @override
  State<PlaylistTypeScreen> createState() => _PlaylistTypeScreenState();
}

class _PlaylistTypeScreenState extends State<PlaylistTypeScreen> {
  String _version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = info.version);
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigService>().config;
    final playlistController = context.watch<PlaylistController>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: config.backgrounds.home.isNotEmpty
                ? NetworkImage(config.backgrounds.home)
                : const AssetImage('assets/images/background.png') as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/App_Logo.png',
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.play_arrow_rounded, color: Color(0xFF00B7FF), size: 40),
                    ),
                    const Spacer(),
                    const _LiveClock(),
                  ],
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'CHOOSE PLAYLIST TYPE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              
              // Cards Area - Expanded to fill available space and prevent overflow
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 700;
                    
                    if (isMobile) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        children: [
                          _TypeCard(
                            title: 'M3U PLAYLIST',
                            icon: Icons.playlist_play_rounded,
                            height: 180,
                            onTap: () => _navToM3u(context),
                          ),
                          const SizedBox(height: 16),
                          _TypeCard(
                            title: 'XTREAM CODE',
                            icon: Icons.stream_rounded,
                            height: 180,
                            onTap: () => _navToXtream(context),
                          ),
                          const SizedBox(height: 16),
                          _TypeCard(
                            title: 'LOCAL DATA',
                            icon: Icons.folder_open_rounded,
                            height: 180,
                            onTap: () => _showLocalDataMsg(context),
                          ),
                        ],
                      );
                    }

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.1,
                                child: _TypeCard(
                                  title: 'M3U PLAYLIST',
                                  icon: Icons.playlist_play_rounded,
                                  onTap: () => _navToM3u(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.1,
                                child: _TypeCard(
                                  title: 'XTREAM CODE',
                                  icon: Icons.stream_rounded,
                                  onTap: () => _navToXtream(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.1,
                                child: _TypeCard(
                                  title: 'LOCAL DATA',
                                  icon: Icons.folder_open_rounded,
                                  onTap: () => _showLocalDataMsg(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Footer - Outside Expanded to always remain visible
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.grid_view_rounded, color: Colors.white38, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${playlistController.playlists.length} PLAYLISTS',
                          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'VERSION $_version',
                      style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Icon(Icons.person_outline_rounded, color: Colors.white38, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'NOT LOGGED IN',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navToM3u(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewM3uPlaylistScreen()));
  }

  void _navToXtream(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewXtreamCodePlaylistScreen()));
  }

  void _showLocalDataMsg(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Local Data coming soon')));
  }
}

class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          DateFormat('hh:mm a').format(_now),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          DateFormat('MMM d, yyyy').format(_now),
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _TypeCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final double? height;

  const _TypeCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.height,
  });

  @override
  State<_TypeCard> createState() => _TypeCardState();
}

class _TypeCardState extends State<_TypeCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (val) => setState(() => _isFocused = val),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => widget.onTap()),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1423).withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isFocused ? const Color(0xFF00B7FF) : Colors.white.withValues(alpha: 0.1),
                width: _isFocused ? 3 : 1.5,
              ),
              boxShadow: _isFocused ? [
                BoxShadow(
                  color: const Color(0xFFC12CFF).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFC12CFF), Color(0xFF00B7FF)],
                  ).createShader(bounds),
                  child: Icon(widget.icon, size: 64, color: Colors.white),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
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
