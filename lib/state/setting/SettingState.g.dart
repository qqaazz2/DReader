// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingState)
const settingStateProvider = SettingStateFamily._();

final class SettingStateProvider extends $NotifierProvider<SettingState, void> {
  const SettingStateProvider._({
    required SettingStateFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'settingStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$settingStateHash();

  @override
  String toString() {
    return r'settingStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SettingState create() => SettingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SettingStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$settingStateHash() => r'4c217f7aa80301500d65262144400c5cd418bafa';

final class SettingStateFamily extends $Family
    with $ClassFamilyOverride<SettingState, void, void, void, String?> {
  const SettingStateFamily._()
    : super(
        retry: null,
        name: r'settingStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SettingStateProvider call(String? fileId) =>
      SettingStateProvider._(argument: fileId, from: this);

  @override
  String toString() => r'settingStateProvider';
}

abstract class _$SettingState extends $Notifier<void> {
  late final _$args = ref.$arg as String?;
  String? get fileId => _$args;

  void build(String? fileId);
  @$mustCallSuper
  @override
  void runBuild() {
    build(_$args);
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
