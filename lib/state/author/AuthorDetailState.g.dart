// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthorDetailState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthorDetailState)
const authorDetailStateProvider = AuthorDetailStateFamily._();

final class AuthorDetailStateProvider
    extends $AsyncNotifierProvider<AuthorDetailState, AuthorDetail?> {
  const AuthorDetailStateProvider._({
    required AuthorDetailStateFamily super.from,
    required dynamic super.argument,
  }) : super(
         retry: null,
         name: r'authorDetailStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$authorDetailStateHash();

  @override
  String toString() {
    return r'authorDetailStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AuthorDetailState create() => AuthorDetailState();

  @override
  bool operator ==(Object other) {
    return other is AuthorDetailStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$authorDetailStateHash() => r'89473fd45e755380e6b632aae68b76044058eecb';

final class AuthorDetailStateFamily extends $Family
    with
        $ClassFamilyOverride<
          AuthorDetailState,
          AsyncValue<AuthorDetail?>,
          AuthorDetail?,
          FutureOr<AuthorDetail?>,
          dynamic
        > {
  const AuthorDetailStateFamily._()
    : super(
        retry: null,
        name: r'authorDetailStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AuthorDetailStateProvider call(dynamic id) =>
      AuthorDetailStateProvider._(argument: id, from: this);

  @override
  String toString() => r'authorDetailStateProvider';
}

abstract class _$AuthorDetailState extends $AsyncNotifier<AuthorDetail?> {
  late final _$args = ref.$arg as dynamic;
  dynamic get id => _$args;

  FutureOr<AuthorDetail?> build(dynamic id);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<AuthorDetail?>, AuthorDetail?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthorDetail?>, AuthorDetail?>,
              AsyncValue<AuthorDetail?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
