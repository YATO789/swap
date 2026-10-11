// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileDatasource)
final profileDatasourceProvider = ProfileDatasourceProvider._();

final class ProfileDatasourceProvider
    extends
        $FunctionalProvider<
          ProfileDatasource,
          ProfileDatasource,
          ProfileDatasource
        >
    with $Provider<ProfileDatasource> {
  ProfileDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDatasourceHash();

  @$internal
  @override
  $ProviderElement<ProfileDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileDatasource create(Ref ref) {
    return profileDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileDatasource>(value),
    );
  }
}

String _$profileDatasourceHash() => r'933c416c2046f3472c43774c2541f7eeb09de845';
