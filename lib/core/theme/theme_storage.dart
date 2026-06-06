import 'dart:convert';

import 'package:another_iptv_player/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const _themeIdKey = 'bingietv.theme.id.v1';
  static const _customThemeKey = 'bingietv.theme.custom.v1';

  Future<BingieThemeId> loadThemeId() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeIdKey);
    return BingieThemeId.values.firstWhere(
      (id) => id.name == value,
      orElse: () => BingieThemeId.bingieNeon,
    );
  }

  Future<void> saveThemeId(BingieThemeId id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeIdKey, id.name);
  }

  Future<BingieThemePalette?> loadCustomTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_customThemeKey);
    if (encoded == null || encoded.isEmpty) return null;
    return BingieThemePalette.fromJson(
      jsonDecode(encoded) as Map<String, dynamic>,
    );
  }

  Future<void> saveCustomTheme(BingieThemePalette palette) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customThemeKey, jsonEncode(palette.toJson()));
  }
}
