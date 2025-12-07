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
    extends $AsyncNotifierProvider<OverviewState, FilesOverview> {
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
}

String _$overviewStateHash() => r'c117b6a404ce05035f431065e1326bc4960f5b6a';

abstract class _$OverviewState extends $AsyncNotifier<FilesOverview> {
  FutureOr<FilesOverview> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FilesOverview>, FilesOverview>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FilesOverview>, FilesOverview>,
              AsyncValue<FilesOverview>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
