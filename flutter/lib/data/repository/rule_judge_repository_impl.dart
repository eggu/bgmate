import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/domain/repository/rule_judge_repository.dart';
import 'package:flutter/services.dart';

class RuleJudgeRepositoryImpl implements RuleJudgeRepository {
  final LlmClient _llmClient;
  String? _systemPrompt;

  RuleJudgeRepositoryImpl(this._llmClient) {
    _loadPrompt();
  }

  Future<void> _loadPrompt() async {
    _systemPrompt = await rootBundle.loadString(
      'assets/prompts/rule_judge_prompt.txt',
    );
  }

  @override
  Stream<String> judge(String gameName, String question) {
    final userMessage = '게임 이름: $gameName\n\n[분쟁상황]\n$question';

    return _llmClient.stream(
      LlmRequest(
        systemPrompt: _systemPrompt,
        messages: [LlmMessage(role: 'user', content: userMessage)],
      ),
    );
  }
}
