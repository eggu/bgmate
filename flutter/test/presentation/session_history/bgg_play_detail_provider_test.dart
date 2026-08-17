import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/data/remote/bgg_api_service.dart';
import 'package:bgmate_flutter/data/remote/bgg_plays_api_service.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:bgmate_flutter/presentation/session_history/bgg_play_detail_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBggPlaysApiService extends BggPlaysApiService {
  String? username;
  int? bggId;

  _FakeBggPlaysApiService()
    : super(apiService: BggApiService(token: 'test-token'));

  @override
  Future<BggPlayDetail> fetchPlays({
    required String username,
    required int bggId,
  }) async {
    this.username = username;
    this.bggId = bggId;
    return BggPlayDetail(
      username: username,
      bggId: bggId,
      plays: const [],
      syncedAt: DateTime(2026, 7, 2),
    );
  }
}

void main() {
  test('BGG 플레이 상세 조회는 저장된 동기화 계정으로 요청한다', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final service = _FakeBggPlaysApiService();
    await db.appSettingsDao.setValue(bggUsernameSettingKey, 'kurt');

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        bggPlaysApiServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(bggPlayDetailProvider(13).future);

    expect(service.username, 'kurt');
    expect(service.bggId, 13);
  });
}
