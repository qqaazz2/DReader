// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesListState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesListState)
const filesListStateProvider = FilesListStateFamily._();

final class FilesListStateProvider
    extends $NotifierProvider<FilesListState, FilesList> {
  const FilesListStateProvider._({
    required FilesListStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'filesListStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filesListStateHash();

  @override
  String toString() {
    return r'filesListStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FilesListState create() => FilesListState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FilesList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FilesList>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilesListStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filesListStateHash() => r'6c47a08aaeaff5b02648170f1cbee097d4601093';

final class FilesListStateFamily extends $Family
    with
        $ClassFamilyOverride<
          FilesListState,
          FilesList,
          FilesList,
          FilesList,
          int
        > {
  const FilesListStateFamily._()
    : super(
        retry: null,
        name: r'filesListStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilesListStateProvider call(int id) =>
      FilesListStateProvider._(argument: id, from: this);

  @override
  String toString() => r'filesListStateProvider';
}

abstract class _$FilesListState extends $Notifier<FilesList> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FilesList build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
