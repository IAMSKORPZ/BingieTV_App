import 'package:flutter/material.dart';

class BingieThemeExtension extends ThemeExtension<BingieThemeExtension> {
  final LinearGradient brandGradient;
  final Color focusGlow;
  final Color glassBorder;

  const BingieThemeExtension({
    required this.brandGradient,
    required this.focusGlow,
    required this.glassBorder,
  });

  @override
  BingieThemeExtension copyWith({
    LinearGradient? brandGradient,
    Color? focusGlow,
    Color? glassBorder,
  }) {
    return BingieThemeExtension(
      brandGradient: brandGradient ?? this.brandGradient,
      focusGlow: focusGlow ?? this.focusGlow,
      glassBorder: glassBorder ?? this.glassBorder,
    );
  }

  @override
  BingieThemeExtension lerp(
    ThemeExtension<BingieThemeExtension>? other,
    double t,
  ) {
    if (other is! BingieThemeExtension) return this;
    return BingieThemeExtension(
      brandGradient: LinearGradient.lerp(brandGradient, other.brandGradient, t)!,
      focusGlow: Color.lerp(focusGlow, other.focusGlow, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
    );
  }
}
