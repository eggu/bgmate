import 'package:drift/drift.dart';

@DataClassName('BoardGameRecord')
class BoardGames extends Table {
  IntColumn get bggId => integer()();

  TextColumn get name => text()();

  IntColumn get yearPublished => integer()();

  TextColumn get thumbnail => text().withDefault(const Constant(''))();

  IntColumn get minPlayers => integer().withDefault(const Constant(0))();

  IntColumn get maxPlayers => integer().withDefault(const Constant(0))();

  IntColumn get playingTime => integer().withDefault(const Constant(0))();

  TextColumn get description => text().withDefault(const Constant(''))();

  // v4: statuses replaces isInCollection. Serialized as comma-separated enum names.
  TextColumn get statuses => text().withDefault(const Constant('owned'))();

  // v4: tracks whether game was added via search or BGG account sync
  TextColumn get source => text().withDefault(const Constant('manualSearch'))();

  // v4: user notes and rating
  TextColumn get notes => text().withDefault(const Constant(''))();

  IntColumn get userRating => integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().nullable().clientDefault(() => DateTime.now())();

  @override
  String get tableName => 'game_table';

  @override
  Set<Column> get primaryKey => {bggId};
}
