// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StatisticsReadLogState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatisticsReadLogState)
const statisticsReadLogStateProvider = StatisticsReadLogStateFamily._();

final class StatisticsReadLogStateProvider
    extends
        $AsyncNotifierProvider<
          StatisticsReadLogState,
          List<ReadLogStatisticsItem>
        > {
  const StatisticsReadLogStateProvider._({
    required StatisticsReadLogStateFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'statisticsReadLogStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$statisticsReadLogStateHash();

  @override
  String toString() {
    return r'statisticsReadLogStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  StatisticsReadLogState create() => StatisticsReadLogState();

  @override
  bool operator ==(Object other) {
    return other is StatisticsReadLogStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$statisticsReadLogStateHash() =>
    r'577c0dbe45c711bceabe6a1dfa3b7ddfbbdb12e2';

final class StatisticsReadLogStateFamily extends $Family
    with
        $ClassFamilyOverride<
          StatisticsReadLogState,
          AsyncValue<List<ReadLogStatisticsItem>>,
          List<ReadLogStatisticsItem>,
          FutureOr<List<ReadLogStatisticsItem>>,
          (String, String)
        > {
  const StatisticsReadLogStateFamily._()
    : super(
        retry: null,
        name: r'statisticsReadLogStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StatisticsReadLogStateProvider call(String stratDate, String endDate) =>
      StatisticsReadLogStateProvider._(
        argument: (stratDate, endDate),
        from: this,
      );

  @override
  String toString() => r'statisticsReadLogStateProvider';
}

abstract class _$StatisticsReadLogState
    extends $AsyncNotifier<List<ReadLogStatisticsItem>> {
  late final _$args = ref.$arg as (String, String);
  String get stratDate => _$args.$1;
  String get endDate => _$args.$2;

  FutureOr<List<ReadLogStatisticsItem>> build(String stratDate, String endDate);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ReadLogStatisticsItem>>,
              List<ReadLogStatisticsItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ReadLogStatisticsItem>>,
                List<ReadLogStatisticsItem>
              >,
              AsyncValue<List<ReadLogStatisticsItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
