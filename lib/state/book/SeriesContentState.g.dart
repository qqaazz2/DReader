// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SeriesContentState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$seriesContentStateHash() =>
    r'065590391094796becc7776dfebdb9339deffc4f';

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

abstract class _$SeriesContentState
    extends BuildlessAutoDisposeNotifier<SeriesContent> {
  late final dynamic id;

  SeriesContent build(
    dynamic id,
  );
}

/// See also [SeriesContentState].
@ProviderFor(SeriesContentState)
const seriesContentStateProvider = SeriesContentStateFamily();

/// See also [SeriesContentState].
class SeriesContentStateFamily extends Family<SeriesContent> {
  /// See also [SeriesContentState].
  const SeriesContentStateFamily();

  /// See also [SeriesContentState].
  SeriesContentStateProvider call(
    dynamic id,
  ) {
    return SeriesContentStateProvider(
      id,
    );
  }

  @override
  SeriesContentStateProvider getProviderOverride(
    covariant SeriesContentStateProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'seriesContentStateProvider';
}

/// See also [SeriesContentState].
class SeriesContentStateProvider
    extends AutoDisposeNotifierProviderImpl<SeriesContentState, SeriesContent> {
  /// See also [SeriesContentState].
  SeriesContentStateProvider(
    dynamic id,
  ) : this._internal(
          () => SeriesContentState()..id = id,
          from: seriesContentStateProvider,
          name: r'seriesContentStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$seriesContentStateHash,
          dependencies: SeriesContentStateFamily._dependencies,
          allTransitiveDependencies:
              SeriesContentStateFamily._allTransitiveDependencies,
          id: id,
        );

  SeriesContentStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final dynamic id;

  @override
  SeriesContent runNotifierBuild(
    covariant SeriesContentState notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(SeriesContentState Function() create) {
    return ProviderOverride(
      origin: this,
      override: SeriesContentStateProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SeriesContentState, SeriesContent>
      createElement() {
    return _SeriesContentStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesContentStateProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SeriesContentStateRef on AutoDisposeNotifierProviderRef<SeriesContent> {
  /// The parameter `id` of this provider.
  dynamic get id;
}

class _SeriesContentStateProviderElement
    extends AutoDisposeNotifierProviderElement<SeriesContentState,
        SeriesContent> with SeriesContentStateRef {
  _SeriesContentStateProviderElement(super.provider);

  @override
  dynamic get id => (origin as SeriesContentStateProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
