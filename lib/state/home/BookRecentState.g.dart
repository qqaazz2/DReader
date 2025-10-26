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
    extends $NotifierProvider<BookRecentState, BookItem?> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookItem?>(value),
    );
  }
}

String _$bookRecentStateHash() => r'440b4d50355e22300e0090e4440bb9f2f11584e2';

abstract class _$BookRecentState extends $Notifier<BookItem?> {
  BookItem? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookItem?, BookItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookItem?, BookItem?>,
              BookItem?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
