// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GameTableTable extends GameTable
    with TableInfo<$GameTableTable, GameTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bggIdMeta = const VerificationMeta('bggId');
  @override
  late final GeneratedColumn<int> bggId = GeneratedColumn<int>(
    'bgg_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailMeta = const VerificationMeta(
    'thumbnail',
  );
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
    'thumbnail',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _minPlayersMeta = const VerificationMeta(
    'minPlayers',
  );
  @override
  late final GeneratedColumn<int> minPlayers = GeneratedColumn<int>(
    'min_players',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxPlayersMeta = const VerificationMeta(
    'maxPlayers',
  );
  @override
  late final GeneratedColumn<int> maxPlayers = GeneratedColumn<int>(
    'max_players',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _playingTimeMeta = const VerificationMeta(
    'playingTime',
  );
  @override
  late final GeneratedColumn<int> playingTime = GeneratedColumn<int>(
    'playing_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    bggId,
    name,
    thumbnail,
    minPlayers,
    maxPlayers,
    playingTime,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bgg_id')) {
      context.handle(
        _bggIdMeta,
        bggId.isAcceptableOrUnknown(data['bgg_id']!, _bggIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('thumbnail')) {
      context.handle(
        _thumbnailMeta,
        thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta),
      );
    }
    if (data.containsKey('min_players')) {
      context.handle(
        _minPlayersMeta,
        minPlayers.isAcceptableOrUnknown(data['min_players']!, _minPlayersMeta),
      );
    }
    if (data.containsKey('max_players')) {
      context.handle(
        _maxPlayersMeta,
        maxPlayers.isAcceptableOrUnknown(data['max_players']!, _maxPlayersMeta),
      );
    }
    if (data.containsKey('playing_time')) {
      context.handle(
        _playingTimeMeta,
        playingTime.isAcceptableOrUnknown(
          data['playing_time']!,
          _playingTimeMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bggId};
  @override
  GameTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameTableData(
      bggId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bgg_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      thumbnail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail'],
      )!,
      minPlayers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_players'],
      )!,
      maxPlayers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_players'],
      )!,
      playingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}playing_time'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $GameTableTable createAlias(String alias) {
    return $GameTableTable(attachedDatabase, alias);
  }
}

class GameTableData extends DataClass implements Insertable<GameTableData> {
  final int bggId;
  final String name;
  final String thumbnail;
  final int minPlayers;
  final int maxPlayers;
  final int playingTime;
  final String description;
  const GameTableData({
    required this.bggId,
    required this.name,
    required this.thumbnail,
    required this.minPlayers,
    required this.maxPlayers,
    required this.playingTime,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bgg_id'] = Variable<int>(bggId);
    map['name'] = Variable<String>(name);
    map['thumbnail'] = Variable<String>(thumbnail);
    map['min_players'] = Variable<int>(minPlayers);
    map['max_players'] = Variable<int>(maxPlayers);
    map['playing_time'] = Variable<int>(playingTime);
    map['description'] = Variable<String>(description);
    return map;
  }

  GameTableCompanion toCompanion(bool nullToAbsent) {
    return GameTableCompanion(
      bggId: Value(bggId),
      name: Value(name),
      thumbnail: Value(thumbnail),
      minPlayers: Value(minPlayers),
      maxPlayers: Value(maxPlayers),
      playingTime: Value(playingTime),
      description: Value(description),
    );
  }

  factory GameTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameTableData(
      bggId: serializer.fromJson<int>(json['bggId']),
      name: serializer.fromJson<String>(json['name']),
      thumbnail: serializer.fromJson<String>(json['thumbnail']),
      minPlayers: serializer.fromJson<int>(json['minPlayers']),
      maxPlayers: serializer.fromJson<int>(json['maxPlayers']),
      playingTime: serializer.fromJson<int>(json['playingTime']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bggId': serializer.toJson<int>(bggId),
      'name': serializer.toJson<String>(name),
      'thumbnail': serializer.toJson<String>(thumbnail),
      'minPlayers': serializer.toJson<int>(minPlayers),
      'maxPlayers': serializer.toJson<int>(maxPlayers),
      'playingTime': serializer.toJson<int>(playingTime),
      'description': serializer.toJson<String>(description),
    };
  }

  GameTableData copyWith({
    int? bggId,
    String? name,
    String? thumbnail,
    int? minPlayers,
    int? maxPlayers,
    int? playingTime,
    String? description,
  }) => GameTableData(
    bggId: bggId ?? this.bggId,
    name: name ?? this.name,
    thumbnail: thumbnail ?? this.thumbnail,
    minPlayers: minPlayers ?? this.minPlayers,
    maxPlayers: maxPlayers ?? this.maxPlayers,
    playingTime: playingTime ?? this.playingTime,
    description: description ?? this.description,
  );
  GameTableData copyWithCompanion(GameTableCompanion data) {
    return GameTableData(
      bggId: data.bggId.present ? data.bggId.value : this.bggId,
      name: data.name.present ? data.name.value : this.name,
      thumbnail: data.thumbnail.present ? data.thumbnail.value : this.thumbnail,
      minPlayers: data.minPlayers.present
          ? data.minPlayers.value
          : this.minPlayers,
      maxPlayers: data.maxPlayers.present
          ? data.maxPlayers.value
          : this.maxPlayers,
      playingTime: data.playingTime.present
          ? data.playingTime.value
          : this.playingTime,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameTableData(')
          ..write('bggId: $bggId, ')
          ..write('name: $name, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('playingTime: $playingTime, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bggId,
    name,
    thumbnail,
    minPlayers,
    maxPlayers,
    playingTime,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameTableData &&
          other.bggId == this.bggId &&
          other.name == this.name &&
          other.thumbnail == this.thumbnail &&
          other.minPlayers == this.minPlayers &&
          other.maxPlayers == this.maxPlayers &&
          other.playingTime == this.playingTime &&
          other.description == this.description);
}

class GameTableCompanion extends UpdateCompanion<GameTableData> {
  final Value<int> bggId;
  final Value<String> name;
  final Value<String> thumbnail;
  final Value<int> minPlayers;
  final Value<int> maxPlayers;
  final Value<int> playingTime;
  final Value<String> description;
  const GameTableCompanion({
    this.bggId = const Value.absent(),
    this.name = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.playingTime = const Value.absent(),
    this.description = const Value.absent(),
  });
  GameTableCompanion.insert({
    this.bggId = const Value.absent(),
    required String name,
    this.thumbnail = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.playingTime = const Value.absent(),
    this.description = const Value.absent(),
  }) : name = Value(name);
  static Insertable<GameTableData> custom({
    Expression<int>? bggId,
    Expression<String>? name,
    Expression<String>? thumbnail,
    Expression<int>? minPlayers,
    Expression<int>? maxPlayers,
    Expression<int>? playingTime,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (bggId != null) 'bgg_id': bggId,
      if (name != null) 'name': name,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (minPlayers != null) 'min_players': minPlayers,
      if (maxPlayers != null) 'max_players': maxPlayers,
      if (playingTime != null) 'playing_time': playingTime,
      if (description != null) 'description': description,
    });
  }

  GameTableCompanion copyWith({
    Value<int>? bggId,
    Value<String>? name,
    Value<String>? thumbnail,
    Value<int>? minPlayers,
    Value<int>? maxPlayers,
    Value<int>? playingTime,
    Value<String>? description,
  }) {
    return GameTableCompanion(
      bggId: bggId ?? this.bggId,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      playingTime: playingTime ?? this.playingTime,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bggId.present) {
      map['bgg_id'] = Variable<int>(bggId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (minPlayers.present) {
      map['min_players'] = Variable<int>(minPlayers.value);
    }
    if (maxPlayers.present) {
      map['max_players'] = Variable<int>(maxPlayers.value);
    }
    if (playingTime.present) {
      map['playing_time'] = Variable<int>(playingTime.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameTableCompanion(')
          ..write('bggId: $bggId, ')
          ..write('name: $name, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('playingTime: $playingTime, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GameTableTable gameTable = $GameTableTable(this);
  late final GameDao gameDao = GameDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [gameTable];
}

typedef $$GameTableTableCreateCompanionBuilder =
    GameTableCompanion Function({
      Value<int> bggId,
      required String name,
      Value<String> thumbnail,
      Value<int> minPlayers,
      Value<int> maxPlayers,
      Value<int> playingTime,
      Value<String> description,
    });
typedef $$GameTableTableUpdateCompanionBuilder =
    GameTableCompanion Function({
      Value<int> bggId,
      Value<String> name,
      Value<String> thumbnail,
      Value<int> minPlayers,
      Value<int> maxPlayers,
      Value<int> playingTime,
      Value<String> description,
    });

class $$GameTableTableFilterComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get bggId => $composableBuilder(
    column: $table.bggId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnail => $composableBuilder(
    column: $table.thumbnail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playingTime => $composableBuilder(
    column: $table.playingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get bggId => $composableBuilder(
    column: $table.bggId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnail => $composableBuilder(
    column: $table.thumbnail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playingTime => $composableBuilder(
    column: $table.playingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameTableTable> {
  $$GameTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get bggId =>
      $composableBuilder(column: $table.bggId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get thumbnail =>
      $composableBuilder(column: $table.thumbnail, builder: (column) => column);

  GeneratedColumn<int> get minPlayers => $composableBuilder(
    column: $table.minPlayers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPlayers => $composableBuilder(
    column: $table.maxPlayers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playingTime => $composableBuilder(
    column: $table.playingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$GameTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameTableTable,
          GameTableData,
          $$GameTableTableFilterComposer,
          $$GameTableTableOrderingComposer,
          $$GameTableTableAnnotationComposer,
          $$GameTableTableCreateCompanionBuilder,
          $$GameTableTableUpdateCompanionBuilder,
          (
            GameTableData,
            BaseReferences<_$AppDatabase, $GameTableTable, GameTableData>,
          ),
          GameTableData,
          PrefetchHooks Function()
        > {
  $$GameTableTableTableManager(_$AppDatabase db, $GameTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> bggId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> thumbnail = const Value.absent(),
                Value<int> minPlayers = const Value.absent(),
                Value<int> maxPlayers = const Value.absent(),
                Value<int> playingTime = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => GameTableCompanion(
                bggId: bggId,
                name: name,
                thumbnail: thumbnail,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                playingTime: playingTime,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> bggId = const Value.absent(),
                required String name,
                Value<String> thumbnail = const Value.absent(),
                Value<int> minPlayers = const Value.absent(),
                Value<int> maxPlayers = const Value.absent(),
                Value<int> playingTime = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => GameTableCompanion.insert(
                bggId: bggId,
                name: name,
                thumbnail: thumbnail,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                playingTime: playingTime,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameTableTable,
      GameTableData,
      $$GameTableTableFilterComposer,
      $$GameTableTableOrderingComposer,
      $$GameTableTableAnnotationComposer,
      $$GameTableTableCreateCompanionBuilder,
      $$GameTableTableUpdateCompanionBuilder,
      (
        GameTableData,
        BaseReferences<_$AppDatabase, $GameTableTable, GameTableData>,
      ),
      GameTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GameTableTableTableManager get gameTable =>
      $$GameTableTableTableManager(_db, _db.gameTable);
}
