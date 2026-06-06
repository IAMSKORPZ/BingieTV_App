import 'dart:async';

import 'package:another_iptv_player/controllers/branding_controller.dart';
import 'package:another_iptv_player/controllers/playlist_controller.dart';
import 'package:another_iptv_player/controllers/update_controller.dart';
import 'package:another_iptv_player/screens/app_initializer_screen.dart';
import 'package:another_iptv_player/services/cache_policy_service.dart';
import 'package:another_iptv_player/services/performance_service.dart';
import 'package:another_iptv_player/widgets/maintenance_banner.dart';
import 'package:another_iptv_player/widgets/update_startup_check.dart';
import 'package:flutter/material.dart';
import 'package:another_iptv_player/services/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'controllers/locale_provider.dart';
import 'controllers/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'package:media_kit/media_kit.dart';
import 'l10n/supported_languages.dart';
import 'utils/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await PerformanceService.track('startup_setup', setupServiceLocator);
  unawaited(CachePolicyService().cleanupTemporaryCache());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BrandingController()..load()),
        ChangeNotifierProvider(create: (_) => UpdateController()..loadState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final brandingController = Provider.of<BrandingController>(context);

    return MaterialApp(
      locale: localeProvider.locale,
      supportedLocales:
      supportedLanguages.map((lang) => Locale(lang['code'])).toList(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: brandingController.branding.appName,
      theme: brandingController.applyRemoteTheme(AppThemes.lightTheme),
      darkTheme: brandingController.applyRemoteTheme(AppThemes.darkTheme),
      themeMode: themeProvider.themeMode,
      builder: (context, child) => FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: child ?? const SizedBox.shrink(),
      ),
      home: UpdateStartupCheck(
        child: MaintenanceBanner(child: AppInitializerScreen()),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
