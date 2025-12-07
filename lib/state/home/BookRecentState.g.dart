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
    extends $AsyncNotifierProvider<BookRecentState, FilesItem?> {
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

String _$bookRecentStateHash() => r'29c89bea5e96b432cb2552349610380273e58efa';

abstract class _$BookRecentState extends $AsyncNotifier<FilesItem?> {
  FutureOr<FilesItem?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<FilesItem?>, FilesItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FilesItem?>, FilesItem?>,
              AsyncValue<FilesItem?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
