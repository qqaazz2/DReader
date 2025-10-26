// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OverviewState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OverviewState)
const overviewStateProvider = OverviewStateProvider._();

final class OverviewStateProvider
    extends $NotifierProvider<OverviewState, BookOverview> {
  const OverviewStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewStateHash();

  @$internal
  @override
  OverviewState create() => OverviewState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookOverview value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookOverview>(value),
    );
  }
}

String _$overviewStateHash() => r'bc3f9eec38d71c7d898c03aa1141093ec1f44c47';

abstract class _$OverviewState extends $Notifier<BookOverview> {
  BookOverview build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookOverview, BookOverview>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookOverview, BookOverview>,
              BookOverview,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
