// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetOverviewState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetOverviewState)
const getOverviewStateProvider = GetOverviewStateProvider._();

final class GetOverviewStateProvider
    extends $AsyncNotifierProvider<GetOverviewState, Map<dynamic, dynamic>> {
  const GetOverviewStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOverviewStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOverviewStateHash();

  @$internal
  @override
  GetOverviewState create() => GetOverviewState();
}

String _$getOverviewStateHash() => r'a86b63bec5c5b26f4c94f6dbc172f89e37911176';

abstract class _$GetOverviewState
    extends $AsyncNotifier<Map<dynamic, dynamic>> {
  FutureOr<Map<dynamic, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<dynamic, dynamic>>, Map<dynamic, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<dynamic, dynamic>>,
                Map<dynamic, dynamic>
              >,
              AsyncValue<Map<dynamic, dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
