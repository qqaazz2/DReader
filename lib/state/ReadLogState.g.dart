// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReadLogState.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReadLogState)
const readLogStateProvider = ReadLogStateProvider._();

final class ReadLogStateProvider
    extends $NotifierProvider<ReadLogState, ReadLog?> {
  const ReadLogStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readLogStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readLogStateHash();

  @$internal
  @override
  ReadLogState create() => ReadLogState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadLog? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadLog?>(value),
    );
  }
}

String _$readLogStateHash() => r'df2758315f97298c9449641d575597fbd00415d0';

abstract class _$ReadLogState extends $Notifier<ReadLog?> {
  ReadLog? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReadLog?, ReadLog?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReadLog?, ReadLog?>,
              ReadLog?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
