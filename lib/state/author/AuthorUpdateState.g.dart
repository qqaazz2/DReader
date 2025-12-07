// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthorUpdateState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthorUpdateState)
const authorUpdateStateProvider = AuthorUpdateStateProvider._();

final class AuthorUpdateStateProvider
    extends
        $NotifierProvider<AuthorUpdateState, StreamController<AuthorDetail>> {
  const AuthorUpdateStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authorUpdateStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authorUpdateStateHash();

  @$internal
  @override
  AuthorUpdateState create() => AuthorUpdateState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StreamController<AuthorDetail> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StreamController<AuthorDetail>>(
        value,
      ),
    );
  }
}

String _$authorUpdateStateHash() => r'b4814f6ecbf783d4f4481384b664ea3c69a5df8c';

abstract class _$AuthorUpdateState
    extends $Notifier<StreamController<AuthorDetail>> {
  StreamController<AuthorDetail> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              StreamController<AuthorDetail>,
              StreamController<AuthorDetail>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                StreamController<AuthorDetail>,
                StreamController<AuthorDetail>
              >,
              StreamController<AuthorDetail>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
