import 'package:freezed_annotation/freezed_annotation.dart';

part 'bgg_account.freezed.dart';

@freezed
sealed class BggAccount with _$BggAccount {
  const factory BggAccount({
    required String username,
    required DateTime linkedAt,
    DateTime? lastSyncedAt,
  }) = _BggAccount;
}
