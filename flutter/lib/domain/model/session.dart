import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

@freezed
sealed class Session with _$Session {
  const factory Session({
    required int id,
    required int bggId,
    required DateTime createdAt,
  }) = _Session;
}
