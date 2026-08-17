import 'package:bgmate_flutter/data/remote/used_price_api_service.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/di/repository_provider.dart';
import 'package:bgmate_flutter/domain/model/board_game.dart';
import 'package:bgmate_flutter/domain/model/used_price.dart';
import 'package:bgmate_flutter/domain/repository/game_repository.dart';
import 'package:bgmate_flutter/presentation/collection/game_used_price_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGameRepository implements GameRepository {
  @override
  Future<List<BoardGame>> enrichWithDetails(List<BoardGame> games) async {
    return [games.single.copyWith(name: 'Venus: Deluxe Edition')];
  }

  @override
  Future<void> addToCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> getCollection() async => [];

  @override
  Future<BoardGame?> getGame(int id) async => null;

  @override
  Future<void> removeFromCollection(BoardGame game) async {}

  @override
  Future<List<BoardGame>> searchBgg(String query) async => [];

  @override
  Stream<List<BoardGame>> watchGames() => const Stream.empty();
}

class _FakeUsedPriceApiService extends UsedPriceApiService {
  String? fetchedName;
  String? fetchedOriginalName;

  _FakeUsedPriceApiService()
    : super(dio: Dio(), baseUrl: 'https://example.com');

  @override
  Future<UsedPrice?> fetchUsedPrice(
    BoardGame game, {
    String? originalName,
  }) async {
    fetchedName = game.name;
    fetchedOriginalName = originalName;
    return null;
  }
}

void main() {
  test('중고가 조회는 표시명과 BGG thing primary 이름을 함께 요청한다', () async {
    final service = _FakeUsedPriceApiService();
    final container = ProviderContainer(
      overrides: [
        gameRepositoryProvider.overrideWithValue(_FakeGameRepository()),
        usedPriceApiServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);

    await container.read(
      gameUsedPriceProvider(
        const BoardGame(bggId: 123, name: '비뉴스 딜럭스 에디션', yearPublished: 2025),
      ).future,
    );

    expect(service.fetchedName, '비뉴스 딜럭스 에디션');
    expect(service.fetchedOriginalName, 'Venus: Deluxe Edition');
  });
}
