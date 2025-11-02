// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingCountState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingCountState)
const settingCountStateProvider = SettingCountStateProvider._();

final class SettingCountStateProvider
    extends $AsyncNotifierProvider<SettingCountState, Map<dynamic, dynamic>> {
  const SettingCountStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingCountStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingCountStateHash();

  @$internal
  @override
  SettingCountState create() => SettingCountState();
}

String _$settingCountStateHash() => r'c5c9bc2d8406000c8e4609f359a4e78efbc48dc9';

abstract class _$SettingCountState
    extends $AsyncNotifier<Map<dynamic, dynamic>> {
  FutureOr<Map<dynamic, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<dynamic, dynamic>>, Map<dynamic, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<dynamic, dynamic>>,
                Map<dynamic, dynamic>
              >,
              AsyncValue<Map<dynamic, dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
