// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GetReadLogListState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetReadLogListState)
const getReadLogListStateProvider = GetReadLogListStateFamily._();

final class GetReadLogListStateProvider
    extends $AsyncNotifierProvider<GetReadLogListState, List<ReadLogListItem>> {
  const GetReadLogListStateProvider._({
    required GetReadLogListStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getReadLogListStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getReadLogListStateHash();

  @override
  String toString() {
    return r'getReadLogListStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GetReadLogListState create() => GetReadLogListState();

  @override
  bool operator ==(Object other) {
    return other is GetReadLogListStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getReadLogListStateHash() =>
    r'a2f87f90d04ff886bc6298114e56fcbe8aec4270';

final class GetReadLogListStateFamily extends $Family
    with
        $ClassFamilyOverride<
          GetReadLogListState,
          AsyncValue<List<ReadLogListItem>>,
          List<ReadLogListItem>,
          FutureOr<List<ReadLogListItem>>,
          String
        > {
  const GetReadLogListStateFamily._()
    : super(
        retry: null,
        name: r'getReadLogListStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetReadLogListStateProvider call(String date) =>
      GetReadLogListStateProvider._(argument: date, from: this);

  @override
  String toString() => r'getReadLogListStateProvider';
}

abstract class _$GetReadLogListState
    extends $AsyncNotifier<List<ReadLogListItem>> {
  late final _$args = ref.$arg as String;
  String get date => _$args;

  FutureOr<List<ReadLogListItem>> build(String date);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ReadLogListItem>>, List<ReadLogListItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ReadLogListItem>>,
                List<ReadLogListItem>
              >,
              AsyncValue<List<ReadLogListItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
