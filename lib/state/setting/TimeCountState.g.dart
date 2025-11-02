// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimeCountState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimeCountState)
const timeCountStateProvider = TimeCountStateProvider._();

final class TimeCountStateProvider
    extends $AsyncNotifierProvider<TimeCountState, List<TimeCount>> {
  const TimeCountStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeCountStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timeCountStateHash();

  @$internal
  @override
  TimeCountState create() => TimeCountState();
}

String _$timeCountStateHash() => r'469001eba0b49844a5f4ccbc362e89b94f6f940e';

abstract class _$TimeCountState extends $AsyncNotifier<List<TimeCount>> {
  FutureOr<List<TimeCount>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<TimeCount>>, List<TimeCount>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TimeCount>>, List<TimeCount>>,
              AsyncValue<List<TimeCount>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
