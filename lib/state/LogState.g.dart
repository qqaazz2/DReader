// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LogState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogState)
const logStateProvider = LogStateProvider._();

final class LogStateProvider
    extends $NotifierProvider<LogState, ListData<LogData>> {
  const LogStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logStateHash();

  @$internal
  @override
  LogState create() => LogState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListData<LogData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListData<LogData>>(value),
    );
  }
}

String _$logStateHash() => r'0adebc3f5bfccac3a895f7656c4b0b7fd3006732';

abstract class _$LogState extends $Notifier<ListData<LogData>> {
  ListData<LogData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ListData<LogData>, ListData<LogData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ListData<LogData>, ListData<LogData>>,
              ListData<LogData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
