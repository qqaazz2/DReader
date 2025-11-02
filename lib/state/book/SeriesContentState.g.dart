// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesContentState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SeriesContentState)
const seriesContentStateProvider = SeriesContentStateFamily._();

final class SeriesContentStateProvider
    extends $NotifierProvider<SeriesContentState, SeriesContent> {
  const SeriesContentStateProvider._({
    required SeriesContentStateFamily super.from,
    required dynamic super.argument,
  }) : super(
         retry: null,
         name: r'seriesContentStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesContentStateHash();

  @override
  String toString() {
    return r'seriesContentStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SeriesContentState create() => SeriesContentState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeriesContent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeriesContent>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesContentStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesContentStateHash() =>
    r'8fa10c5238f04baee9077c1fed46813bc0142da4';

final class SeriesContentStateFamily extends $Family
    with
        $ClassFamilyOverride<
          SeriesContentState,
          SeriesContent,
          SeriesContent,
          SeriesContent,
          dynamic
        > {
  const SeriesContentStateFamily._()
    : super(
        retry: null,
        name: r'seriesContentStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeriesContentStateProvider call(dynamic id) =>
      SeriesContentStateProvider._(argument: id, from: this);

  @override
  String toString() => r'seriesContentStateProvider';
}

abstract class _$SeriesContentState extends $Notifier<SeriesContent> {
  late final _$args = ref.$arg as dynamic;
  dynamic get id => _$args;

  SeriesContent build(dynamic id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<SeriesContent, SeriesContent>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SeriesContent, SeriesContent>,
              SeriesContent,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
