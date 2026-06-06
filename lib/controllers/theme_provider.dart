import 'package:another_iptv_player/core/theme/app_theme.dart';
import 'package:another_iptv_player/core/theme/theme_storage.dart';
import 'package:flutter/material.dart';
import '../repositories/user_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  BingieThemePalette _palette = BingieThemes.builtIn.first;
  final ThemeStorage _themeStorage = ThemeStorage();

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  BingieThemePalette get palette => _palette;

  Future<void> _loadTheme() async {
    _themeMode = await UserPreferences.getThemeMode();
    final themeId = await _themeStorage.loadThemeId();
    _palette = themeId == BingieThemeId.custom
        ? await _themeStorage.loadCustomTheme() ?? BingieThemes.builtIn.first
        : BingieThemes.byId(themeId);
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await UserPreferences.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setBingieTheme(BingieThemePalette palette) async {
    _palette = palette;
    await _themeStorage.saveThemeId(palette.id);
    if (palette.id == BingieThemeId.custom) {
      await _themeStorage.saveCustomTheme(palette);
    }
    notifyListeners();
  }

  bool isDarkMode() => _themeMode == ThemeMode.dark;
  bool isLightMode() => _themeMode == ThemeMode.light;
  bool isSystemMode() => _themeMode == ThemeMode.system;
}
