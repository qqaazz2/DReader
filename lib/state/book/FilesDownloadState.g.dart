// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesDownloadState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesDownloadState)
const filesDownloadStateProvider = FilesDownloadStateProvider._();

final class FilesDownloadStateProvider
    extends $NotifierProvider<FilesDownloadState, List<FilesDownload>> {
  const FilesDownloadStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filesDownloadStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filesDownloadStateHash();

  @$internal
  @override
  FilesDownloadState create() => FilesDownloadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FilesDownload> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FilesDownload>>(value),
    );
  }
}

String _$filesDownloadStateHash() =>
    r'995240e88699654258b3d8dbba977a05ef07a3d2';

abstract class _$FilesDownloadState extends $Notifier<List<FilesDownload>> {
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
