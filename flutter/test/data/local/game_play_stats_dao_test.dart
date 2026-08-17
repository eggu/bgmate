import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BGG 전적 통계를 전체 삭제한다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.gameDao.upsert(
      const BoardGamesCompanion(
        bggId: Value(1),
        name: Value('Catan'),
        yearPublished: Value(1995),
      ),
    );
    await db.gamePlayStatsDao.upsertAll([
      GamePlayStatsTableCompanion(
        bggId: const Value(1),
        syncedAt: Value(DateTime(2026, 7, 2)),
      ),
    ]);

    await db.gamePlayStatsDao.deleteAll();

    expect(await db.gamePlayStatsDao.getAll(), isEmpty);
  });
}
