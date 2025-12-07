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
    extends $NotifierProvider<RecentlyAddsState, FilesList> {
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
  Override overrideWithValue(FilesList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilesList>(value),
    );
  }
}

String _$recentlyAddsStateHash() => r'eec0bcab53e2fd90e0581a35f73f3472a7df6e9b';

abstract class _$RecentlyAddsState extends $Notifier<FilesList> {
  FilesList build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FilesList, FilesList>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FilesList, FilesList>,
              FilesList,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
