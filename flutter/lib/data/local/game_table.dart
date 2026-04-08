import 'package:drift/drift.dart';

class GameTable extends Table {
  IntColumn get bggId => integer()();

  TextColumn get name => text()();

  IntColumn get yearPublished => integer()();

  TextColumn get thumbnail => text().withDefault(const Constant(''))();

  IntColumn get minPlayers => integer().withDefault(const Constant(0))();

  IntColumn get maxPlayers => integer().withDefault(const Constant(0))();

  IntColumn get playingTime => integer().withDefault(const Constant(0))();

  TextColumn get description => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().nullable().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {bggId};
}
