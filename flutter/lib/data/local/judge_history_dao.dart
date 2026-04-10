import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/judge_histories.dart';
import 'package:drift/drift.dart';

part 'judge_history_dao.g.dart';

@DriftAccessor(tables: [JudgeHistories])
class JudgeHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$JudgeHistoryDaoMixin {
  JudgeHistoryDao(super.db);

  Future<void> insertHistory(JudgeHistoriesCompanion entry) =>
      into(judgeHistories).insert(entry);

  Stream<List<JudgeHistoryRecord>> watchRecent(int limit) =>
      (select(judgeHistories)
            ..orderBy([(t) => OrderingTerm.desc(t.askedAt)])
            ..limit(limit))
          .watch();
}
