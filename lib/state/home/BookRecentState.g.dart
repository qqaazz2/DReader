// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookRecentState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookRecentState)
const bookRecentStateProvider = BookRecentStateProvider._();

final class BookRecentStateProvider
    extends $AsyncNotifierProvider<BookRecentState, List<FilesItem>?> {
  const BookRecentStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookRecentStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookRecentStateHash();

  @$internal
  @override
  BookRecentState create() => BookRecentState();
}

String _$bookRecentStateHash() => r'c4d1c727afb7d3b119caebc03337478cab4042d2';

abstract class _$BookRecentState extends $AsyncNotifier<List<FilesItem>?> {
  FutureOr<List<FilesItem>?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<FilesItem>?>, List<FilesItem>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FilesItem>?>, List<FilesItem>?>,
              AsyncValue<List<FilesItem>?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
