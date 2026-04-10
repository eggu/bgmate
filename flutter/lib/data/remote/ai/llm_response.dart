import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_response.freezed.dart';

@freezed
sealed class LlmResponse with _$LlmResponse {
  const factory LlmResponse({required String text}) = _LlmResponse;
}
