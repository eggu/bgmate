import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_xml_parser.dart';
import 'package:bgmate_flutter/domain/model/game_source.dart';
import 'package:bgmate_flutter/domain/repository/account_repository.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';

enum SyncStep { fetchingCollection, savingToDb, done }

class CollectionSyncResult {
  final int added;
  final int updated;
  final int preserved;

  const CollectionSyncResult({
    required this.added,
    required this.updated,
    required this.preserved,
  });
}

class CollectionSyncService {
  final BggApiService _bggApiService;
  final GameRepository _gameRepository;
  final AccountRepository _accountRepository;

  CollectionSyncService(
    this._bggApiService,
    this._gameRepository,
    this._accountRepository,
  );

  /// BGG 컬렉션을 가져와 로컬 DB와 동기화합니다.
  ///
  /// - BGG에만 있는 게임 → 추가
  /// - 양쪽 모두 있는 게임 → statuses만 BGG 값으로 덮어씀, notes/userRating 보존
  /// - 로컬에만 있는 게임 → 보존 (수동 추가 또는 이전에 삭제한 게임)
  ///
  /// 전체 DB 쓰기는 단일 트랜잭션으로 처리되므로 중간 실패 시 롤백됩니다.
  /// [onProgress]로 단계별 진행 상태를 콜백받을 수 있습니다.
  Future<CollectionSyncResult> sync(
    String username, {
    void Function(SyncStep step)? onProgress,
  }) async {
    onProgress?.call(SyncStep.fetchingCollection);

    final xml = await _bggApiService.fetchCollection(username);
    final bggGames = BggXmlParser.parseCollectionResults(xml);

    onProgress?.call(SyncStep.savingToDb);

    final localGames = await _gameRepository.getCollection();
    final localByBggId = {for (final g in localGames) g.bggId: g};

    var added = 0;
    var updated = 0;
    var preserved = 0;

    final gamesToUpsert = <dynamic>[];

    for (final bggGame in bggGames) {
      final existing = localByBggId[bggGame.bggId];
      if (existing == null) {
        gamesToUpsert.add(bggGame);
        added++;
      } else {
        // statuses만 BGG로 업데이트, 사용자 데이터 보존
        gamesToUpsert.add(
          existing.copyWith(
            statuses: bggGame.statuses,
            source: GameSource.bggSync,
            // thumbnail/name/year 등 기본 정보도 최신화
            name: bggGame.name,
            yearPublished: bggGame.yearPublished,
            thumbnail: bggGame.thumbnail.isNotEmpty
                ? bggGame.thumbnail
                : existing.thumbnail,
            minPlayers: bggGame.minPlayers > 0
                ? bggGame.minPlayers
                : existing.minPlayers,
            maxPlayers: bggGame.maxPlayers > 0
                ? bggGame.maxPlayers
                : existing.maxPlayers,
            playingTime: bggGame.playingTime > 0
                ? bggGame.playingTime
                : existing.playingTime,
          ),
        );
        updated++;
      }
    }

    preserved = localGames.length - updated;

    await _gameRepository.upsertGames(
      gamesToUpsert.cast(),
    );

    final now = DateTime.now();
    await _accountRepository.updateLastSyncedAt(now);

    onProgress?.call(SyncStep.done);

    return CollectionSyncResult(
      added: added,
      updated: updated,
      preserved: preserved,
    );
  }
}
