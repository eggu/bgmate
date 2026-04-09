import 'package:bgmate_flutter/data/local/app_database.dart';
import 'package:bgmate_flutter/data/local/players.dart';
import 'package:drift/drift.dart';

part 'player_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayerDao extends DatabaseAccessor<AppDatabase> with _$PlayerDaoMixin {
  PlayerDao(super.db);

  Future<void> insert(PlayersCompanion entity) =>
      into(players).insert(entity, mode: InsertMode.insertOrIgnore);

}
