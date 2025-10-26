// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ThemeState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemeState)
const themeStateProvider = ThemeStateProvider._();

final class ThemeStateProvider extends $NotifierProvider<ThemeState, Setting> {
  const ThemeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeStateHash();

  @$internal
  @override
  ThemeState create() => ThemeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Setting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Setting>(value),
    );
  }
}

String _$themeStateHash() => r'00ef8bbeffc9381cec903065189945ed06d79468';

abstract class _$ThemeState extends $Notifier<Setting> {
  Setting build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Setting, Setting>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Setting, Setting>,
              Setting,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
