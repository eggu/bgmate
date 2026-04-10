import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_response.dart';

abstract interface class LlmClient {
  Future<LlmResponse> complete(LlmRequest request);
  Stream<String> stream(LlmRequest request);
}