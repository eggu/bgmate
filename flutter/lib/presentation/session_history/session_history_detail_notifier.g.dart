// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(historyDetail)
final historyDetailProvider = HistoryDetailFamily._();

final class HistoryDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionHistory?>,
          SessionHistory?,
          FutureOr<SessionHistory?>
        >
    with $FutureModifier<SessionHistory?>, $FutureProvider<SessionHistory?> {
  HistoryDetailProvider._({
    required HistoryDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'historyDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$historyDetailHash();

  @override
  String toString() {
    return r'historyDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SessionHistory?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SessionHistory?> create(Ref ref) {
    final argument = this.argument as int;
    return historyDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoryDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$historyDetailHash() => r'525582c4539d84d41476c497d726ecc7ccb24a47';

final class HistoryDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SessionHistory?>, int> {
  HistoryDetailFamily._()
    : super(
        retry: null,
        name: r'historyDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HistoryDetailProvider call(int sessionId) =>
      HistoryDetailProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'historyDetailProvider';
}
