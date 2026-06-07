import 'package:another_iptv_player/screens/xtream-codes/xtream_code_data_loader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../services/config_service.dart';
import '../../../../controllers/playlist_controller.dart';
import '../../../../models/api_configuration_model.dart';
import '../../../../models/playlist_model.dart';
import '../../../../repositories/iptv_repository.dart';

class NewXtreamCodePlaylistScreen extends StatefulWidget {
  const NewXtreamCodePlaylistScreen({super.key});

  @override
  NewXtreamCodePlaylistScreenState createState() =>
      NewXtreamCodePlaylistScreenState();
}

class NewXtreamCodePlaylistScreenState
    extends State<NewXtreamCodePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Playlist-1');
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _urlController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _nameController.text.trim().isNotEmpty &&
          _urlController.text.trim().isNotEmpty &&
          _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigService>().config;
    final loginBg = config.backgrounds.login;

    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final bool isMobile = width < 700;
          final bool isTablet = width >= 700 && width < 1100;
          final bool isDesktop = width >= 1100 && width < 1600;
          
          double logoHeight;
          if (isMobile) logoHeight = 80;
          else if (isTablet) logoHeight = 110;
          else if (isDesktop) logoHeight = 110;
          else logoHeight = 140;

          double titleFontSize = isMobile ? 22 : (isTablet ? 26 : 30);
          
          double fieldHeight;
          if (isMobile) fieldHeight = 55;
          else if (isTablet) fieldHeight = 65;
          else if (isDesktop) fieldHeight = 65;
          else fieldHeight = 70;

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: loginBg.isNotEmpty
                    ? NetworkImage(loginBg)
                    : const AssetImage('assets/images/background.png') as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.5),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Row(
              children: [
                // Left Panel
                if (!isMobile)
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(48),
                    color: Colors.black.withValues(alpha: 0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/App_Logo.png',
                          height: logoHeight,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.play_arrow_rounded, color: const Color(0xFF00B7FF), size: logoHeight * 0.7),
                        ),
                        const SizedBox(height: 24),
                        _SideButton(
                          icon: Icons.vpn_lock_rounded,
                          label: 'CONNECT VPN',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('VPN Service coming soon')),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _SideButton(
                          icon: Icons.view_list_rounded,
                          label: 'LIST PLAYLISTS',
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Panel (Form)
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 60),
                    child: Center(
                      child: SingleChildScrollView(
                        physics: isMobile ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                        child: Consumer<PlaylistController>(
                          builder: (context, controller, child) {
                            return Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                                children: [
                                  if (isMobile) ...[
                                    Image.asset(
                                      'assets/images/App_Logo.png',
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                  Text(
                                    'ENTER YOUR PLAYLIST DETAILS',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _XTextField(
                                    controller: _nameController,
                                    label: 'Playlist Name',
                                    icon: Icons.list_rounded,
                                    height: fieldHeight,
                                  ),
                                  const SizedBox(height: 12),
                                  _XTextField(
                                    controller: _usernameController,
                                    label: 'Username',
                                    icon: Icons.person_outline_rounded,
                                    height: fieldHeight,
                                  ),
                                  const SizedBox(height: 12),
                                  _XTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                    obscure: _obscurePassword,
                                    height: fieldHeight,
                                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  const SizedBox(height: 12),
                                  _XTextField(
                                    controller: _urlController,
                                    label: 'http://url_here.com:port',
                                    icon: Icons.link_rounded,
                                    height: fieldHeight,
                                    hint: 'http://example.com:8080',
                                  ),
                                  const SizedBox(height: 20),
                                  _AddPlaylistButton(
                                    isLoading: controller.isLoading,
                                    height: fieldHeight,
                                    onTap: controller.isLoading ? null : (_isFormValid ? _savePlaylist : null),
                                  ),
                                  if (isMobile) ...[
                                     const SizedBox(height: 16),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         IconButton(
                                           icon: const Icon(Icons.vpn_lock_rounded, color: Colors.white70),
                                           onPressed: () {},
                                         ),
                                         const SizedBox(width: 20),
                                         IconButton(
                                           icon: const Icon(Icons.view_list_rounded, color: Colors.white70),
                                           onPressed: () => Navigator.pop(context),
                                         ),
                                       ],
                                     ),
                                  ],
                                  if (controller.error != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      controller.error!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _savePlaylist() async {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<PlaylistController>(
        context,
        listen: false,
      );

      controller.clearError();

      final repository = IptvRepository(
        ApiConfig(
          baseUrl: _urlController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        ),
        _nameController.text.trim(),
      );

      var playerInfo = await repository.getPlayerInfo(forceRefresh: true);

      if (playerInfo == null) {
        controller.setError('Invalid credentials or server unavailable');
        return;
      }

      final playlist = await controller.createPlaylist(
        name: _nameController.text.trim(),
        type: PlaylistType.xtream,
        url: _urlController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (playlist != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                XtreamCodeDataLoaderScreen(playlist: playlist),
          ),
        );
      }
    }
  }
}

class _SideButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SideButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SideButton> createState() => _SideButtonState();
}

class _SideButtonState extends State<_SideButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (val) => setState(() => _isFocused = val),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: _isFocused ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused ? const Color(0xFF00B7FF) : Colors.white.withValues(alpha: 0.1),
                width: _isFocused ? 2.5 : 1,
              ),
              boxShadow: _isFocused ? [
                BoxShadow(
                  color: const Color(0xFF00B7FF).withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ] : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(widget.icon, color: _isFocused ? const Color(0xFF00B7FF) : Colors.white70, size: 28),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _isFocused ? Colors.white : Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
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

class _XTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final bool isPassword;
  final bool obscure;
  final double height;
  final VoidCallback? onToggleObscure;

  const _XTextField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.height,
    this.hint,
    this.isPassword = false,
    this.obscure = false,
    this.onToggleObscure,
  });

  @override
  State<_XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<_XTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (val) => setState(() => _isFocused = val),
      child: AnimatedScale(
        scale: _isFocused ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFF0F1423).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isFocused ? const Color(0xFF00B7FF) : const Color(0xFF00B7FF).withValues(alpha: 0.3),
              width: _isFocused ? 2.5 : 1,
            ),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: const Color(0xFF00B7FF).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ] : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: TextFormField(
              controller: widget.controller,
              obscureText: widget.obscure,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                icon: Icon(widget.icon, color: const Color(0xFFC12CFF), size: 22),
                hintText: widget.label,
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 15),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(widget.obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20),
                        onPressed: widget.onToggleObscure,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AddPlaylistButton extends StatefulWidget {
  final bool isLoading;
  final double height;
  final VoidCallback? onTap;

  const _AddPlaylistButton({required this.isLoading, required this.height, this.onTap});

  @override
  State<_AddPlaylistButton> createState() => _AddPlaylistButtonState();
}

class _AddPlaylistButtonState extends State<_AddPlaylistButton> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (val) => setState(() => _isFocused = val),
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
        const SingleActivator(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) => widget.onTap?.call()),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isFocused ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isFocused 
                  ? [const Color(0xFFD14CFF), const Color(0xFF20C7FF)]
                  : [const Color(0xFFC12CFF), const Color(0xFF00B7FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: _isFocused ? Border.all(color: Colors.white, width: 2.5) : null,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00B7FF).withValues(alpha: _isFocused ? 0.6 : 0.4),
                  blurRadius: _isFocused ? 30 : 15,
                  offset: Offset(0, _isFocused ? 8 : 4),
                ),
              ],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Text(
                      'ADD PLAYLIST',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}