// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthorListState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthorListState)
const authorListStateProvider = AuthorListStateProvider._();

final class AuthorListStateProvider
    extends $NotifierProvider<AuthorListState, ListData<AuthorItem>> {
  const AuthorListStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authorListStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authorListStateHash();

  @$internal
  @override
  AuthorListState create() => AuthorListState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListData<AuthorItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListData<AuthorItem>>(value),
    );
  }
}

String _$authorListStateHash() => r'7fb13b1c72fd706e7a594b4f2a50604554f92a5d';

abstract class _$AuthorListState extends $Notifier<ListData<AuthorItem>> {
  ListData<AuthorItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ListData<AuthorItem>, ListData<AuthorItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ListData<AuthorItem>, ListData<AuthorItem>>,
              ListData<AuthorItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
