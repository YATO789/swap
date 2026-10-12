// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeRoute,
  $welcomeRoute,
  $splashRoute,
  $onboardingRoute,
  $createDiaryBookRoute,
  $diaryBookRoute,
  $diaryBookInfoRoute,
  $diaryDetailRoute,
  $diaryEditorRoute,
  $myPageRoute,
  $profileEditRoute,
];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $HomeRoute._fromState,
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $welcomeRoute => GoRouteData.$route(
  path: '/welcome',
  hasOverriddenOnExit: false,
  factory: $WelcomeRoute._fromState,
);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $splashRoute => GoRouteData.$route(
  path: '/splash',
  hasOverriddenOnExit: false,
  factory: $SplashRoute._fromState,
);

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  @override
  String get location => GoRouteData.$location('/splash');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  hasOverriddenOnExit: false,
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $createDiaryBookRoute => GoRouteData.$route(
  path: '/diary-books/new',
  hasOverriddenOnExit: false,
  factory: $CreateDiaryBookRoute._fromState,
);

mixin $CreateDiaryBookRoute on GoRouteData {
  static CreateDiaryBookRoute _fromState(GoRouterState state) =>
      const CreateDiaryBookRoute();

  @override
  String get location => GoRouteData.$location('/diary-books/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $diaryBookRoute => GoRouteData.$route(
  path: '/diary-books/:id',
  hasOverriddenOnExit: false,
  factory: $DiaryBookRoute._fromState,
);

mixin $DiaryBookRoute on GoRouteData {
  static DiaryBookRoute _fromState(GoRouterState state) =>
      DiaryBookRoute(id: state.pathParameters['id']!);

  DiaryBookRoute get _self => this as DiaryBookRoute;

  @override
  String get location =>
      GoRouteData.$location('/diary-books/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $diaryBookInfoRoute => GoRouteData.$route(
  path: '/diary-books/:id/info',
  hasOverriddenOnExit: false,
  factory: $DiaryBookInfoRoute._fromState,
);

mixin $DiaryBookInfoRoute on GoRouteData {
  static DiaryBookInfoRoute _fromState(GoRouterState state) =>
      DiaryBookInfoRoute(id: state.pathParameters['id']!);

  DiaryBookInfoRoute get _self => this as DiaryBookInfoRoute;

  @override
  String get location => GoRouteData.$location(
    '/diary-books/${Uri.encodeComponent(_self.id)}/info',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $diaryDetailRoute => GoRouteData.$route(
  path: '/diary-books/:id/diaries/:date',
  hasOverriddenOnExit: false,
  factory: $DiaryDetailRoute._fromState,
);

mixin $DiaryDetailRoute on GoRouteData {
  static DiaryDetailRoute _fromState(GoRouterState state) => DiaryDetailRoute(
    id: state.pathParameters['id']!,
    date: _decodeDate(state.pathParameters['date']!),
    author: state.uri.queryParameters['author'],
  );

  DiaryDetailRoute get _self => this as DiaryDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/diary-books/${Uri.encodeComponent(_self.id)}/diaries/${Uri.encodeComponent(_encodeDate(_self.date))}',
    queryParams: {if (_self.author != null) 'author': _self.author},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $diaryEditorRoute => GoRouteData.$route(
  path: '/diaries/write',
  hasOverriddenOnExit: false,
  factory: $DiaryEditorRoute._fromState,
);

mixin $DiaryEditorRoute on GoRouteData {
  static DiaryEditorRoute _fromState(GoRouterState state) => DiaryEditorRoute(
    date: _decodeDate(state.uri.queryParameters['date']!),
    diaryBook: state.uri.queryParameters['diary-book'],
  );

  DiaryEditorRoute get _self => this as DiaryEditorRoute;

  @override
  String get location => GoRouteData.$location(
    '/diaries/write',
    queryParams: {
      'date': _encodeDate(_self.date),
      if (_self.diaryBook != null) 'diary-book': _self.diaryBook,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $myPageRoute => GoRouteData.$route(
  path: '/me',
  hasOverriddenOnExit: false,
  factory: $MyPageRoute._fromState,
);

mixin $MyPageRoute on GoRouteData {
  static MyPageRoute _fromState(GoRouterState state) => const MyPageRoute();

  @override
  String get location => GoRouteData.$location('/me');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileEditRoute => GoRouteData.$route(
  path: '/me/profile',
  hasOverriddenOnExit: false,
  factory: $ProfileEditRoute._fromState,
);

mixin $ProfileEditRoute on GoRouteData {
  static ProfileEditRoute _fromState(GoRouterState state) =>
      const ProfileEditRoute();

  @override
  String get location => GoRouteData.$location('/me/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アプリの画面遷移。サインイン状態とプロフィールの有無で出す画面を決める。
///
/// - サインインしていない: ウェルカム画面
/// - プロフィールを読んでいる: スプラッシュ画面
/// - プロフィールがまだない: オンボーディング画面
/// - それ以外: ホーム
///
/// 状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// アプリの画面遷移。サインイン状態とプロフィールの有無で出す画面を決める。
///
/// - サインインしていない: ウェルカム画面
/// - プロフィールを読んでいる: スプラッシュ画面
/// - プロフィールがまだない: オンボーディング画面
/// - それ以外: ホーム
///
/// 状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// アプリの画面遷移。サインイン状態とプロフィールの有無で出す画面を決める。
  ///
  /// - サインインしていない: ウェルカム画面
  /// - プロフィールを読んでいる: スプラッシュ画面
  /// - プロフィールがまだない: オンボーディング画面
  /// - それ以外: ホーム
  ///
  /// 状態が変わるたびに redirect をやり直すので、画面側で遷移しなくてよい。
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'df9468d1795bc5e352fca88637023f5817b9577f';
