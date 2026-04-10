import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_request.freezed.dart';

@freezed
sealed class LlmRequest with _$LlmRequest {
  const factory LlmRequest({
    required List<LlmMessage> messages,
    @Default(null) String? systemPrompt,
    @Default(4096) int maxTokens,
  }) = _LlmRequest;
}

@freezed
sealed class LlmMessage with _$LlmMessage {
  const factory LlmMessage({required String role, required String content}) =
      _LlmMessage;
}
