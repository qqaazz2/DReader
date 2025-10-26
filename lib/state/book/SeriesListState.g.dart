// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesListState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SeriesListState)
const seriesListStateProvider = SeriesListStateProvider._();

final class SeriesListStateProvider
    extends $NotifierProvider<SeriesListState, SeriesList> {
  const SeriesListStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seriesListStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seriesListStateHash();

  @$internal
  @override
  SeriesListState create() => SeriesListState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeriesList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeriesList>(value),
    );
  }
}

String _$seriesListStateHash() => r'ca11e0cfe1453a7ce80a76d404f3522a7ab60a50';

abstract class _$SeriesListState extends $Notifier<SeriesList> {
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
