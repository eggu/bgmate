import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BGG 플레이 점수를 로컬 전적으로 동기화하고 재동기화 시 중복 저장하지 않는다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.gameDao.upsert(
      const BoardGamesCompanion(
        bggId: Value(13),
        name: Value('Catan'),
        yearPublished: Value(1995),
      ),
    );

    await db.sessionDao.replaceBggSyncedSessions([
      (
        bggId: 13,
        bggPlayId: 9001,
        playedAt: DateTime(2026, 6, 1),
        scores: [
          (name: 'Alice', score: 10, rank: 1),
          (name: 'Bob', score: 8, rank: 2),
        ],
      ),
    ]);
    await db.sessionDao.replaceBggSyncedSessions([
      (
        bggId: 13,
        bggPlayId: 9001,
        playedAt: DateTime(2026, 6, 1),
        scores: [
          (name: 'Alice', score: 11, rank: 1),
          (name: 'Bob', score: 8, rank: 2),
        ],
      ),
    ]);

    final sessions = await db.sessionDao.watchSessions().first;

    expect(sessions, hasLength(1));
    expect(sessions.single.session.bggPlayId, 9001);
    expect(sessions.single.session.createdAt, DateTime(2026, 6, 1));
    expect(sessions.single.scores.map((score) => score.player.name), [
      'Alice',
      'Bob',
    ]);
    expect(sessions.single.scores.map((score) => score.score), [11, 8]);
  });

  test('BGG 동기화 세션 삭제는 로컬 수기 전적을 유지한다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.gameDao.upsert(
      const BoardGamesCompanion(
        bggId: Value(13),
        name: Value('Catan'),
        yearPublished: Value(1995),
      ),
    );
    await db.sessionDao.insertSessionWithPlayers(
      const SessionsCompanion(bggId: Value(13)),
      const [(PlayersCompanion(name: Value('Local')), 7, 1)],
    );
    await db.sessionDao.replaceBggSyncedSessions([
      (
        bggId: 13,
        bggPlayId: 9001,
        playedAt: DateTime(2026, 6, 1),
        scores: [(name: 'BGG', score: 10, rank: 1)],
      ),
    ]);

    await db.sessionDao.replaceBggSyncedSessions([]);

    final sessions = await db.sessionDao.watchSessions().first;

    expect(sessions, hasLength(1));
    expect(sessions.single.scores.single.player.name, 'Local');
  });

  test('BGG 플레이어 점수가 없어도 전적 세션을 저장한다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await db.gameDao.upsert(
      const BoardGamesCompanion(
        bggId: Value(13),
        name: Value('Catan'),
        yearPublished: Value(1995),
      ),
    );

    await db.sessionDao.replaceBggSyncedSessions([
      (bggId: 13, bggPlayId: 9002, playedAt: DateTime(2026, 6, 2), scores: []),
    ]);

    final sessions = await db.sessionDao.watchSessions().first;

    expect(sessions, hasLength(1));
    expect(sessions.single.session.bggPlayId, 9002);
    expect(sessions.single.scores, isEmpty);
  });
}
