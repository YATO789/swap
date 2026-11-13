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
  $updateRoute,
  $createDiaryBookRoute,
  $diaryBookRoute,
  $diaryBookInfoRoute,
  $coverDecorationRoute,
  $diaryDetailRoute,
  $diaryEditorRoute,
  $myPageRoute,
  $feedbackRoute,
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

RouteBase get $updateRoute => GoRouteData.$route(
  path: '/update',
  hasOverriddenOnExit: false,
  factory: $UpdateRoute._fromState,
);

mixin $UpdateRoute on GoRouteData {
  static UpdateRoute _fromState(GoRouterState state) => const UpdateRoute();

  @override
  String get location => GoRouteData.$location('/update');

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
  static DiaryBookRoute _fromState(GoRouterState state) => DiaryBookRoute(
    id: state.pathParameters['id']!,
    $extra: state.extra as DiaryBookOrigin?,
  );

  DiaryBookRoute get _self => this as DiaryBookRoute;

  @override
  String get location =>
      GoRouteData.$location('/diary-books/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
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

RouteBase get $coverDecorationRoute => GoRouteData.$route(
  path: '/diary-books/:id/cover',
  hasOverriddenOnExit: false,
  factory: $CoverDecorationRoute._fromState,
);

mixin $CoverDecorationRoute on GoRouteData {
  static CoverDecorationRoute _fromState(GoRouterState state) =>
      CoverDecorationRoute(id: state.pathParameters['id']!);

  CoverDecorationRoute get _self => this as CoverDecorationRoute;

  @override
  String get location => GoRouteData.$location(
    '/diary-books/${Uri.encodeComponent(_self.id)}/cover',
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
    blank:
        _$convertMapValue(
          'blank',
          state.uri.queryParameters,
          _$boolConverter,
        ) ??
        false,
  );

  DiaryEditorRoute get _self => this as DiaryEditorRoute;

  @override
  String get location => GoRouteData.$location(
    '/diaries/write',
    queryParams: {
      'date': _encodeDate(_self.date),
      if (_self.diaryBook != null) 'diary-book': _self.diaryBook,
      if (_self.blank != false) 'blank': _self.blank.toString(),
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

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
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

RouteBase get $feedbackRoute => GoRouteData.$route(
  path: '/me/feedback',
  hasOverriddenOnExit: false,
  factory: $FeedbackRoute._fromState,
);

mixin $FeedbackRoute on GoRouteData {
  static FeedbackRoute _fromState(GoRouterState state) => const FeedbackRoute();

  @override
  String get location => GoRouteData.$location('/me/feedback');

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

@ProviderFor(router)
final routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
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

String _$routerHash() => r'e81a6c0472f4111cb4cba9f271e32cf13df389fd';

/// 起動直後の画面を消して、最初の画面を見せてよいか。

@ProviderFor(firstScreenReady)
final firstScreenReadyProvider = FirstScreenReadyProvider._();

/// 起動直後の画面を消して、最初の画面を見せてよいか。

final class FirstScreenReadyProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 起動直後の画面を消して、最初の画面を見せてよいか。
  FirstScreenReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstScreenReadyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstScreenReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return firstScreenReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$firstScreenReadyHash() => r'158fe71ee3aa00f32aa01d09f307213bf2343ab4';
