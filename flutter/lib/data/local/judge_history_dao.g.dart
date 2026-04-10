// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'judge_history_dao.dart';

// ignore_for_file: type=lint
mixin _$JudgeHistoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $JudgeHistoriesTable get judgeHistories => attachedDatabase.judgeHistories;
  JudgeHistoryDaoManager get managers => JudgeHistoryDaoManager(this);
}

class JudgeHistoryDaoManager {
  final _$JudgeHistoryDaoMixin _db;
  JudgeHistoryDaoManager(this._db);
  $$JudgeHistoriesTableTableManager get judgeHistories =>
      $$JudgeHistoriesTableTableManager(
        _db.attachedDatabase,
        _db.judgeHistories,
      );
}
