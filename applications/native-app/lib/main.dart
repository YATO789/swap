import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';
import 'infrastructures/datasources/stores/diary_book_grid_store.dart';
import 'infrastructures/datasources/stores/post_diary_book_store.dart';
import 'infrastructures/datasources/stores/shared_preferences_store.dart';
import 'infrastructures/datasources/stores/theme_mode_store.dart';
import 'infrastructures/repositories/theme_mode_repository.dart';
import 'screens/pages/router/router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    publishableKey: const String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  );

  final preferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: {postDiaryBookIdsKey, diaryBookGridKey, themeModeKey},
    ),
  );

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      // 設定でテーマを変えたら、すぐ全体に反映する。
      themeMode: ref.watch(themeModeRepositoryProvider),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
