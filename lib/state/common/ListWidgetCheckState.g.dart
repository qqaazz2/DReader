// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListWidgetCheckState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ListWidgetCheckState)
const listWidgetCheckStateProvider = ListWidgetCheckStateFamily._();

final class ListWidgetCheckStateProvider
    extends $NotifierProvider<ListWidgetCheckState, Set<int>> {
  const ListWidgetCheckStateProvider._({
    required ListWidgetCheckStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'listWidgetCheckStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listWidgetCheckStateHash();

  @override
  String toString() {
    return r'listWidgetCheckStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ListWidgetCheckState create() => ListWidgetCheckState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListWidgetCheckStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listWidgetCheckStateHash() =>
    r'0be14e632d4805a39fa8a06eaee6fbf5cb11f7bf';

final class ListWidgetCheckStateFamily extends $Family
    with
        $ClassFamilyOverride<
          ListWidgetCheckState,
          Set<int>,
          Set<int>,
          Set<int>,
          String
        > {
  const ListWidgetCheckStateFamily._()
    : super(
        retry: null,
        name: r'listWidgetCheckStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListWidgetCheckStateProvider call(String key) =>
      ListWidgetCheckStateProvider._(argument: key, from: this);

  @override
  String toString() => r'listWidgetCheckStateProvider';
}

abstract class _$ListWidgetCheckState extends $Notifier<Set<int>> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  Set<int> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<int>, Set<int>>,
              Set<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
