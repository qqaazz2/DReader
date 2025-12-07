// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FilesDetailsItemState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FilesDetailsItemState)
const filesDetailsItemStateProvider = FilesDetailsItemStateFamily._();

final class FilesDetailsItemStateProvider
    extends $AsyncNotifierProvider<FilesDetailsItemState, FilesDetailsItem?> {
  const FilesDetailsItemStateProvider._({
    required FilesDetailsItemStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'filesDetailsItemStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filesDetailsItemStateHash();

  @override
  String toString() {
    return r'filesDetailsItemStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FilesDetailsItemState create() => FilesDetailsItemState();

  @override
  bool operator ==(Object other) {
    return other is FilesDetailsItemStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filesDetailsItemStateHash() =>
    r'acc93294aa2bf039d7d1b234156f9fe3d1d9f6c4';

final class FilesDetailsItemStateFamily extends $Family
    with
        $ClassFamilyOverride<
          FilesDetailsItemState,
          AsyncValue<FilesDetailsItem?>,
          FilesDetailsItem?,
          FutureOr<FilesDetailsItem?>,
          int
        > {
  const FilesDetailsItemStateFamily._()
    : super(
        retry: null,
        name: r'filesDetailsItemStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilesDetailsItemStateProvider call(int id) =>
      FilesDetailsItemStateProvider._(argument: id, from: this);

  @override
  String toString() => r'filesDetailsItemStateProvider';
}

abstract class _$FilesDetailsItemState
    extends $AsyncNotifier<FilesDetailsItem?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<FilesDetailsItem?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<FilesDetailsItem?>, FilesDetailsItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FilesDetailsItem?>, FilesDetailsItem?>,
              AsyncValue<FilesDetailsItem?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
