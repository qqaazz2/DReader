// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookProgressState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookProgressState)
const bookProgressStateProvider = BookProgressStateProvider._();

final class BookProgressStateProvider
    extends $NotifierProvider<BookProgressState, void> {
  const BookProgressStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookProgressStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookProgressStateHash();

  @$internal
  @override
  BookProgressState create() => BookProgressState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$bookProgressStateHash() => r'c94163579c4626ea3770506a7935c7d02681c37d';

abstract class _$BookProgressState extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
