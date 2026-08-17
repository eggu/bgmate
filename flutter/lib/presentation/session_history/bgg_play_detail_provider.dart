import 'package:bgmate_flutter/data/local/app_settings.dart';
import 'package:bgmate_flutter/di/database_provider.dart';
import 'package:bgmate_flutter/di/remote_provider.dart';
import 'package:bgmate_flutter/domain/model/bgg_play_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bggPlayDetailProvider = FutureProvider.autoDispose
    .family<BggPlayDetail, int>((ref, bggId) async {
      final username = await ref
          .watch(appSettingsDaoProvider)
          .getValue(bggUsernameSettingKey);
      if (username == null || username.trim().isEmpty) {
        throw StateError('BGG 동기화 계정이 없습니다.');
      }
      return ref
          .watch(bggPlaysApiServiceProvider)
          .fetchPlays(username: username, bggId: bggId);
    });
