import 'package:flutter/material.dart';

enum BingieThemeId {
  bingieNeon,
  emerald,
  crimson,
  ocean,
  gold,
  midnight,
  amoled,
  custom,
}

class BingieThemePalette {
  final BingieThemeId id;
  final String name;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color text;

  const BingieThemePalette({
    required this.id,
    required this.name,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id.name,
      'name': name,
      'primary': primary.toARGB32(),
      'secondary': secondary.toARGB32(),
      'accent': accent.toARGB32(),
      'background': background.toARGB32(),
      'surface': surface.toARGB32(),
      'text': text.toARGB32(),
    };
  }

  factory BingieThemePalette.fromJson(Map<String, dynamic> json) {
    return BingieThemePalette(
      id: BingieThemeId.values.firstWhere(
        (id) => id.name == json['id'],
        orElse: () => BingieThemeId.custom,
      ),
      name: json['name'] as String? ?? 'Custom',
      primary: Color(json['primary'] as int? ?? 0xff7c3aed),
      secondary: Color(json['secondary'] as int? ?? 0xff2563eb),
      accent: Color(json['accent'] as int? ?? 0xff06b6d4),
      background: Color(json['background'] as int? ?? 0xff030712),
      surface: Color(json['surface'] as int? ?? 0xff111827),
      text: Color(json['text'] as int? ?? 0xffffffff),
    );
  }
}

class BingieThemes {
  static const builtIn = <BingieThemePalette>[
    BingieThemePalette(
      id: BingieThemeId.bingieNeon,
      name: 'Bingie Neon',
      primary: Color(0xff7c3aed),
      secondary: Color(0xff2563eb),
      accent: Color(0xff06b6d4),
      background: Color(0xff030712),
      surface: Color(0xff111827),
      text: Color(0xffffffff),
    ),
    BingieThemePalette(
      id: BingieThemeId.emerald,
      name: 'Emerald',
      primary: Color(0xff10b981),
      secondary: Color(0xff047857),
      accent: Color(0xff5eead4),
      background: Color(0xff02120c),
      surface: Color(0xff082018),
      text: Color(0xffffffff),
    ),
    BingieThemePalette(
      id: BingieThemeId.crimson,
      name: 'Crimson',
      primary: Color(0xffef4444),
      secondary: Color(0xff991b1b),
      accent: Color(0xfff472b6),
      background: Color(0xff160405),
      surface: Color(0xff251011),
      text: Color(0xffffffff),
    ),
    BingieThemePalette(
      id: BingieThemeId.ocean,
      name: 'Ocean',
      primary: Color(0xff2563eb),
      secondary: Color(0xff0e7490),
      accent: Color(0xff38bdf8),
      background: Color(0xff020817),
      surface: Color(0xff0b172a),
      text: Color(0xffffffff),
    ),
    BingieThemePalette(
      id: BingieThemeId.gold,
      name: 'Gold',
      primary: Color(0xffd97706),
      secondary: Color(0xffa16207),
      accent: Color(0xfffacc15),
      background: Color(0xff11100a),
      surface: Color(0xff1c1910),
      text: Color(0xffffffff),
    ),
    BingieThemePalette(
      id: BingieThemeId.midnight,
      name: 'Midnight',
      primary: Color(0xff94a3b8),
      secondary: Color(0xff475569),
      accent: Color(0xffcbd5e1),
      background: Color(0xff020617),
      surface: Color(0xff0f172a),
      text: Color(0xffffffff),
    ),
    BingieThemePalette(
      id: BingieThemeId.amoled,
      name: 'AMOLED',
      primary: Color(0xffa855f7),
      secondary: Color(0xff27272a),
      accent: Color(0xffffffff),
      background: Color(0xff000000),
      surface: Color(0xff09090b),
      text: Color(0xffffffff),
    ),
  ];

  static BingieThemePalette byId(BingieThemeId id) {
    return builtIn.firstWhere(
      (theme) => theme.id == id,
      orElse: () => builtIn.first,
    );
  }
}
