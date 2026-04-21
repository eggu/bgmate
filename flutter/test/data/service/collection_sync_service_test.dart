import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/service/collection_sync_service.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/collection_status.dart';
import 'package:bgmate_flutter/domain/model/game_source.dart';
import 'package:bgmate_flutter/domain/repository/account_repository.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'collection_sync_service_test.mocks.dart';

@GenerateMocks([BggApiService, GameRepository, AccountRepository])
void main() {
  late MockBggApiService mockBggApi;
  late MockGameRepository mockGameRepo;
  late MockAccountRepository mockAccountRepo;
  late CollectionSyncService syncService;

  final bggGame = BoardGame(
    bggId: 224517,
    name: 'Brass: Birmingham',
    yearPublished: 2018,
    thumbnail: 'https://example.com/brass.jpg',
    minPlayers: 2,
    maxPlayers: 4,
    statuses: {CollectionStatus.owned},
    source: GameSource.bggSync,
  );

  const collectionXml = '''<?xml version="1.0" encoding="utf-8"?>
<items totalitems="1" termsofuse="" pubdate="">
  <item objecttype="thing" objectid="224517" subtype="boardgame" collid="1">
    <name sortindex="1">Brass: Birmingham</name>
    <yearpublished>2018</yearpublished>
    <thumbnail>//example.com/brass.jpg</thumbnail>
    <stats minplayers="2" maxplayers="4" playingtime="120">
      <rating value="8.5"><usersrated value="50000"/></rating>
    </stats>
    <status own="1" prevowned="0" fortrade="0" want="0" wanttoplay="0" wanttobuy="0" wishlist="0" preordered="0" lastmodified="2024-01-01 00:00:00"/>
    <numplays>5</numplays>
  </item>
</items>''';

  setUp(() {
    mockBggApi = MockBggApiService();
    mockGameRepo = MockGameRepository();
    mockAccountRepo = MockAccountRepository();
    syncService = CollectionSyncService(mockBggApi, mockGameRepo, mockAccountRepo);

    when(mockBggApi.fetchCollection(any)).thenAnswer((_) async => collectionXml);
    when(mockGameRepo.getCollection()).thenAnswer((_) async => []);
    when(mockGameRepo.upsertGames(any)).thenAnswer((_) async {});
    when(mockAccountRepo.updateLastSyncedAt(any)).thenAnswer((_) async {});
  });

  group('CollectionSyncService.sync', () {
    test('BGG에만 있는 게임 → 새로 추가됨', () async {
      when(mockGameRepo.getCollection()).thenAnswer((_) async => []);

      final result = await syncService.sync('testuser');

      expect(result.added, equals(1));
      expect(result.updated, equals(0));
      verify(mockGameRepo.upsertGames(any)).called(1);
    });

    test('로컬에 이미 있는 게임 → statuses 업데이트, notes 보존', () async {
      final localGame = bggGame.copyWith(
        statuses: {CollectionStatus.owned},
        notes: '내 메모',
        userRating: 9,
        source: GameSource.manualSearch,
      );
      when(mockGameRepo.getCollection()).thenAnswer((_) async => [localGame]);

      final result = await syncService.sync('testuser');

      expect(result.updated, equals(1));
      expect(result.added, equals(0));

      final captured = verify(
        mockGameRepo.upsertGames(captureAny),
      ).captured.first as List<BoardGame>;

      expect(captured.first.notes, equals('내 메모'));
      expect(captured.first.userRating, equals(9));
      expect(captured.first.statuses, equals({CollectionStatus.owned}));
    });

    test('로컬에만 있는 게임은 건드리지 않음', () async {
      final localOnlyGame = BoardGame(
        bggId: 99999,
        name: '로컬 전용 게임',
        yearPublished: 2020,
        statuses: {CollectionStatus.owned},
        source: GameSource.manualSearch,
      );
      when(mockGameRepo.getCollection()).thenAnswer((_) async => [localOnlyGame]);

      final result = await syncService.sync('testuser');

      // BGG에서 온 1개 추가, 로컬 전용 1개 보존
      expect(result.added, equals(1));
      expect(result.preserved, equals(1));
    });

    test('동기화 성공 후 lastSyncedAt 갱신됨', () async {
      await syncService.sync('testuser');

      verify(mockAccountRepo.updateLastSyncedAt(any)).called(1);
    });

    test('BGG API 실패 시 DB 변경 없음', () async {
      when(mockBggApi.fetchCollection(any)).thenThrow(Exception('Network error'));

      expect(() => syncService.sync('testuser'), throwsException);
      verifyNever(mockGameRepo.upsertGames(any));
      verifyNever(mockAccountRepo.updateLastSyncedAt(any));
    });

    test('onProgress 콜백으로 단계 전달됨', () async {
      final steps = <SyncStep>[];
      await syncService.sync('testuser', onProgress: steps.add);

      expect(steps, containsAllInOrder([
        SyncStep.fetchingCollection,
        SyncStep.savingToDb,
        SyncStep.done,
      ]));
    });
  });
}
