// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RecentlyAddsState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecentlyAddsState)
const recentlyAddsStateProvider = RecentlyAddsStateProvider._();

final class RecentlyAddsStateProvider
    extends $NotifierProvider<RecentlyAddsState, SeriesList> {
  const RecentlyAddsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlyAddsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlyAddsStateHash();

  @$internal
  @override
  RecentlyAddsState create() => RecentlyAddsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeriesList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeriesList>(value),
    );
  }
}

String _$recentlyAddsStateHash() => r'174b4080dc63bff30992703bf992aabcfed25579';

abstract class _$RecentlyAddsState extends $Notifier<SeriesList> {
  SeriesList build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SeriesList, SeriesList>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SeriesList, SeriesList>,
              SeriesList,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
