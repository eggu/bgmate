import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/judge_histories.dart';
import 'package:bgmate_flutter/data/local/judge_history_dao.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_client.dart';
import 'package:bgmate_flutter/data/remote/ai/llm_request.dart';
import 'package:bgmate_flutter/domain/model/judge_history.dart';
import 'package:bgmate_flutter/domain/repository/rule_judge_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

class RuleJudgeRepositoryImpl implements RuleJudgeRepository {
  final LlmClient _llmClient;
  final JudgeHistoryDao _dao;
  String? _systemPrompt;

  RuleJudgeRepositoryImpl(this._llmClient, this._dao) {
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

  @override
  Future<void> saveHistory(
    String gameName,
    String question,
    String answer,
  ) => _dao.insertHistory(
    JudgeHistoriesCompanion(
      gameName: Value(gameName),
      question: Value(question),
      answer: Value(answer),
      askedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ),
  );

  @override
  Stream<List<JudgeHistory>> watchHistory(int limit) =>
      _dao.watchRecent(limit).map(
        (records) => records
            .map(
              (r) => JudgeHistory(
                id: r.id,
                gameName: r.gameName,
                question: r.question,
                answer: r.answer,
                askedAt: DateTime.fromMillisecondsSinceEpoch(r.askedAt),
              ),
            )
            .toList(),
      );
}
