// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingStateHash() => r'4c217f7aa80301500d65262144400c5cd418bafa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SettingState extends BuildlessAutoDisposeNotifier<void> {
  late final String? fileId;

  void build(
    String? fileId,
  );
}

/// See also [SettingState].
@ProviderFor(SettingState)
const settingStateProvider = SettingStateFamily();

/// See also [SettingState].
class SettingStateFamily extends Family<void> {
  /// See also [SettingState].
  const SettingStateFamily();

  /// See also [SettingState].
  SettingStateProvider call(
    String? fileId,
  ) {
    return SettingStateProvider(
      fileId,
    );
  }

  @override
  SettingStateProvider getProviderOverride(
    covariant SettingStateProvider provider,
  ) {
    return call(
      provider.fileId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'settingStateProvider';
}

/// See also [SettingState].
class SettingStateProvider
    extends AutoDisposeNotifierProviderImpl<SettingState, void> {
  /// See also [SettingState].
  SettingStateProvider(
    String? fileId,
  ) : this._internal(
          () => SettingState()..fileId = fileId,
          from: settingStateProvider,
          name: r'settingStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$settingStateHash,
          dependencies: SettingStateFamily._dependencies,
          allTransitiveDependencies:
              SettingStateFamily._allTransitiveDependencies,
          fileId: fileId,
        );

  SettingStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.fileId,
  }) : super.internal();

  final String? fileId;

  @override
  void runNotifierBuild(
    covariant SettingState notifier,
  ) {
    return notifier.build(
      fileId,
    );
  }

  @override
  Override overrideWith(SettingState Function() create) {
    return ProviderOverride(
      origin: this,
      override: SettingStateProvider._internal(
        () => create()..fileId = fileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        fileId: fileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SettingState, void> createElement() {
    return _SettingStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SettingStateProvider && other.fileId == fileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, fileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SettingStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `fileId` of this provider.
  String? get fileId;
}

class _SettingStateProviderElement
    extends AutoDisposeNotifierProviderElement<SettingState, void>
    with SettingStateRef {
  _SettingStateProviderElement(super.provider);

  @override
  String? get fileId => (origin as SettingStateProvider).fileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
