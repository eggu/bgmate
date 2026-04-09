// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateSessionNotifier)
final createSessionProvider = CreateSessionNotifierFamily._();

final class CreateSessionNotifierProvider
    extends $NotifierProvider<CreateSessionNotifier, CreateSessionState> {
  CreateSessionNotifierProvider._({
    required CreateSessionNotifierFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'createSessionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createSessionNotifierHash();

  @override
  String toString() {
    return r'createSessionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CreateSessionNotifier create() => CreateSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateSessionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateSessionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CreateSessionNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createSessionNotifierHash() =>
    r'827595cb2beb7a6e30b962d69e02db1620c7afb8';

final class CreateSessionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CreateSessionNotifier,
          CreateSessionState,
          CreateSessionState,
          CreateSessionState,
          int
        > {
  CreateSessionNotifierFamily._()
    : super(
        retry: null,
        name: r'createSessionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateSessionNotifierProvider call(int bggId) =>
      CreateSessionNotifierProvider._(argument: bggId, from: this);

  @override
  String toString() => r'createSessionProvider';
}

abstract class _$CreateSessionNotifier extends $Notifier<CreateSessionState> {
  late final _$args = ref.$arg as int;
  int get bggId => _$args;

  CreateSessionState build(int bggId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CreateSessionState, CreateSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateSessionState, CreateSessionState>,
              CreateSessionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
