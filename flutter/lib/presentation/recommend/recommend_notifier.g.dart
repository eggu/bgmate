// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecommendNotifier)
final recommendProvider = RecommendNotifierProvider._();

final class RecommendNotifierProvider
    extends $AsyncNotifierProvider<RecommendNotifier, List<RecommendResult>> {
  RecommendNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommendNotifierHash();

  @$internal
  @override
  RecommendNotifier create() => RecommendNotifier();
}

String _$recommendNotifierHash() => r'69bdb500e5a0da3b87839c20c4a901c423208cd9';

abstract class _$RecommendNotifier
    extends $AsyncNotifier<List<RecommendResult>> {
  FutureOr<List<RecommendResult>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<RecommendResult>>, List<RecommendResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RecommendResult>>,
                List<RecommendResult>
              >,
              AsyncValue<List<RecommendResult>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
