// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfoState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserInfoState)
const userInfoStateProvider = UserInfoStateProvider._();

final class UserInfoStateProvider
    extends $NotifierProvider<UserInfoState, UserInfo?> {
  const UserInfoStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userInfoStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userInfoStateHash();

  @$internal
  @override
  UserInfoState create() => UserInfoState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserInfo? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserInfo?>(value),
    );
  }
}

String _$userInfoStateHash() => r'4635a6d15c550e3556c5711d1ff78cbd0c5a11ef';

abstract class _$UserInfoState extends $Notifier<UserInfo?> {
  UserInfo? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserInfo?, UserInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserInfo?, UserInfo?>,
              UserInfo?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
