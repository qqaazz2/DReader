// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesGlobalUpdateState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesGlobalUpdateState)
const filesGlobalUpdateStateProvider = FilesGlobalUpdateStateProvider._();

final class FilesGlobalUpdateStateProvider
    extends
        $NotifierProvider<FilesGlobalUpdateState, StreamController<FilesItem>> {
  const FilesGlobalUpdateStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filesGlobalUpdateStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filesGlobalUpdateStateHash();

  @$internal
  @override
  FilesGlobalUpdateState create() => FilesGlobalUpdateState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamController<FilesItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamController<FilesItem>>(value),
    );
  }
}

String _$filesGlobalUpdateStateHash() =>
    r'fe5ebb4c65a0388d0ffd8416ed8f4343b9592797';

abstract class _$FilesGlobalUpdateState
    extends $Notifier<StreamController<FilesItem>> {
  StreamController<FilesItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<StreamController<FilesItem>, StreamController<FilesItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                StreamController<FilesItem>,
                StreamController<FilesItem>
              >,
              StreamController<FilesItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
