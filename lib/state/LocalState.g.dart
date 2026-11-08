// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocalState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalState)
const localStateProvider = LocalStateProvider._();

final class LocalStateProvider
    extends $NotifierProvider<LocalState, List<FilesDownload>> {
  const LocalStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStateHash();

  @$internal
  @override
  LocalState create() => LocalState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FilesDownload> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FilesDownload>>(value),
    );
  }
}

String _$localStateHash() => r'867a33350f60e65eff27114df3c5993559ed5980';

abstract class _$LocalState extends $Notifier<List<FilesDownload>> {
  List<FilesDownload> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<FilesDownload>, List<FilesDownload>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<FilesDownload>, List<FilesDownload>>,
              List<FilesDownload>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
