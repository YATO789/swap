import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;
import 'infrastructures/datasources/stores/preferences_store.dart';
import 'presentations/providers/theme_mode_notifier.dart';
import 'l10n/l10n.dart';
import 'presentations/pages/router/router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // 最初の画面が中身を出せるまで、起動直後の画面を出したままにする。消すのは MyApp。
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  // 同梱したフォントのライセンスを、ライセンスの一覧に載せる。
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/Yomogi-OFL.txt');
    yield LicenseEntryWithLineBreaks(['Yomogi'], license);
  });

  await Firebase.initializeApp(options: _firebaseOptions());

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    publishableKey: const String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  );

  final preferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: PreferencesStore.keys,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const MyApp(),
    ),
  );
}

/// `--flavor` に合わせて、つなぐ Firebase プロジェクトを選ぶ。
FirebaseOptions _firebaseOptions() {
  return switch (appFlavor) {
    'dev' => dev.DefaultFirebaseOptions.currentPlatform,
    'prod' => prod.DefaultFirebaseOptions.currentPlatform,
    _ => throw StateError('--flavor dev か --flavor prod を付けて起動してください。'),
  };
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final subscription = ref.listenManual(firstScreenReadyProvider, (
        _,
        ready,
      ) {
        if (ready) FlutterNativeSplash.remove();
      }, fireImmediately: true);
      return subscription.close;
    }, const []);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ref.watch(themeModeProvider),
      // 色を少しずつ変えると、途中で文字の色だけ先に切り替わってちらつくので、一度に切り替える。
      themeAnimationDuration: Duration.zero,
      // 端末の言語に合わせる。英語と日本語以外は、先頭の英語になる。
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
