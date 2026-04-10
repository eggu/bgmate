// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BoardGamesTable extends BoardGames
    with TableInfo<$BoardGamesTable, BoardGameRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoardGamesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _yearPublishedMeta = const VerificationMeta(
    'yearPublished',
  );
  @override
  late final GeneratedColumn<int> yearPublished = GeneratedColumn<int>(
    'year_published',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    bggId,
    name,
    yearPublished,
    thumbnail,
    minPlayers,
    maxPlayers,
    playingTime,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BoardGameRecord> instance, {
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
    if (data.containsKey('year_published')) {
      context.handle(
        _yearPublishedMeta,
        yearPublished.isAcceptableOrUnknown(
          data['year_published']!,
          _yearPublishedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yearPublishedMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bggId};
  @override
  BoardGameRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BoardGameRecord(
      bggId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bgg_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      yearPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_published'],
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $BoardGamesTable createAlias(String alias) {
    return $BoardGamesTable(attachedDatabase, alias);
  }
}

class BoardGameRecord extends DataClass implements Insertable<BoardGameRecord> {
  final int bggId;
  final String name;
  final int yearPublished;
  final String thumbnail;
  final int minPlayers;
  final int maxPlayers;
  final int playingTime;
  final String description;
  final DateTime? createdAt;
  const BoardGameRecord({
    required this.bggId,
    required this.name,
    required this.yearPublished,
    required this.thumbnail,
    required this.minPlayers,
    required this.maxPlayers,
    required this.playingTime,
    required this.description,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bgg_id'] = Variable<int>(bggId);
    map['name'] = Variable<String>(name);
    map['year_published'] = Variable<int>(yearPublished);
    map['thumbnail'] = Variable<String>(thumbnail);
    map['min_players'] = Variable<int>(minPlayers);
    map['max_players'] = Variable<int>(maxPlayers);
    map['playing_time'] = Variable<int>(playingTime);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  BoardGamesCompanion toCompanion(bool nullToAbsent) {
    return BoardGamesCompanion(
      bggId: Value(bggId),
      name: Value(name),
      yearPublished: Value(yearPublished),
      thumbnail: Value(thumbnail),
      minPlayers: Value(minPlayers),
      maxPlayers: Value(maxPlayers),
      playingTime: Value(playingTime),
      description: Value(description),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory BoardGameRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BoardGameRecord(
      bggId: serializer.fromJson<int>(json['bggId']),
      name: serializer.fromJson<String>(json['name']),
      yearPublished: serializer.fromJson<int>(json['yearPublished']),
      thumbnail: serializer.fromJson<String>(json['thumbnail']),
      minPlayers: serializer.fromJson<int>(json['minPlayers']),
      maxPlayers: serializer.fromJson<int>(json['maxPlayers']),
      playingTime: serializer.fromJson<int>(json['playingTime']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bggId': serializer.toJson<int>(bggId),
      'name': serializer.toJson<String>(name),
      'yearPublished': serializer.toJson<int>(yearPublished),
      'thumbnail': serializer.toJson<String>(thumbnail),
      'minPlayers': serializer.toJson<int>(minPlayers),
      'maxPlayers': serializer.toJson<int>(maxPlayers),
      'playingTime': serializer.toJson<int>(playingTime),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  BoardGameRecord copyWith({
    int? bggId,
    String? name,
    int? yearPublished,
    String? thumbnail,
    int? minPlayers,
    int? maxPlayers,
    int? playingTime,
    String? description,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => BoardGameRecord(
    bggId: bggId ?? this.bggId,
    name: name ?? this.name,
    yearPublished: yearPublished ?? this.yearPublished,
    thumbnail: thumbnail ?? this.thumbnail,
    minPlayers: minPlayers ?? this.minPlayers,
    maxPlayers: maxPlayers ?? this.maxPlayers,
    playingTime: playingTime ?? this.playingTime,
    description: description ?? this.description,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  BoardGameRecord copyWithCompanion(BoardGamesCompanion data) {
    return BoardGameRecord(
      bggId: data.bggId.present ? data.bggId.value : this.bggId,
      name: data.name.present ? data.name.value : this.name,
      yearPublished: data.yearPublished.present
          ? data.yearPublished.value
          : this.yearPublished,
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
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BoardGameRecord(')
          ..write('bggId: $bggId, ')
          ..write('name: $name, ')
          ..write('yearPublished: $yearPublished, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('playingTime: $playingTime, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bggId,
    name,
    yearPublished,
    thumbnail,
    minPlayers,
    maxPlayers,
    playingTime,
    description,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoardGameRecord &&
          other.bggId == this.bggId &&
          other.name == this.name &&
          other.yearPublished == this.yearPublished &&
          other.thumbnail == this.thumbnail &&
          other.minPlayers == this.minPlayers &&
          other.maxPlayers == this.maxPlayers &&
          other.playingTime == this.playingTime &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class BoardGamesCompanion extends UpdateCompanion<BoardGameRecord> {
  final Value<int> bggId;
  final Value<String> name;
  final Value<int> yearPublished;
  final Value<String> thumbnail;
  final Value<int> minPlayers;
  final Value<int> maxPlayers;
  final Value<int> playingTime;
  final Value<String> description;
  final Value<DateTime?> createdAt;
  const BoardGamesCompanion({
    this.bggId = const Value.absent(),
    this.name = const Value.absent(),
    this.yearPublished = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.playingTime = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BoardGamesCompanion.insert({
    this.bggId = const Value.absent(),
    required String name,
    required int yearPublished,
    this.thumbnail = const Value.absent(),
    this.minPlayers = const Value.absent(),
    this.maxPlayers = const Value.absent(),
    this.playingTime = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       yearPublished = Value(yearPublished);
  static Insertable<BoardGameRecord> custom({
    Expression<int>? bggId,
    Expression<String>? name,
    Expression<int>? yearPublished,
    Expression<String>? thumbnail,
    Expression<int>? minPlayers,
    Expression<int>? maxPlayers,
    Expression<int>? playingTime,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (bggId != null) 'bgg_id': bggId,
      if (name != null) 'name': name,
      if (yearPublished != null) 'year_published': yearPublished,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (minPlayers != null) 'min_players': minPlayers,
      if (maxPlayers != null) 'max_players': maxPlayers,
      if (playingTime != null) 'playing_time': playingTime,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BoardGamesCompanion copyWith({
    Value<int>? bggId,
    Value<String>? name,
    Value<int>? yearPublished,
    Value<String>? thumbnail,
    Value<int>? minPlayers,
    Value<int>? maxPlayers,
    Value<int>? playingTime,
    Value<String>? description,
    Value<DateTime?>? createdAt,
  }) {
    return BoardGamesCompanion(
      bggId: bggId ?? this.bggId,
      name: name ?? this.name,
      yearPublished: yearPublished ?? this.yearPublished,
      thumbnail: thumbnail ?? this.thumbnail,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      playingTime: playingTime ?? this.playingTime,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
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
    if (yearPublished.present) {
      map['year_published'] = Variable<int>(yearPublished.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoardGamesCompanion(')
          ..write('bggId: $bggId, ')
          ..write('name: $name, ')
          ..write('yearPublished: $yearPublished, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('minPlayers: $minPlayers, ')
          ..write('maxPlayers: $maxPlayers, ')
          ..write('playingTime: $playingTime, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlayersTable extends Players
    with TableInfo<$PlayersTable, PlayerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class PlayerRecord extends DataClass implements Insertable<PlayerRecord> {
  final int id;
  final String name;
  final DateTime? createdAt;
  const PlayerRecord({required this.id, required this.name, this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory PlayerRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerRecord(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  PlayerRecord copyWith({
    int? id,
    String? name,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => PlayerRecord(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  PlayerRecord copyWithCompanion(PlayersCompanion data) {
    return PlayerRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class PlayersCompanion extends UpdateCompanion<PlayerRecord> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime?> createdAt;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PlayerRecord> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime?>? createdAt,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bggIdMeta = const VerificationMeta('bggId');
  @override
  late final GeneratedColumn<int> bggId = GeneratedColumn<int>(
    'bgg_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES game_table(bgg_id) ON DELETE CASCADE',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  @override
  List<GeneratedColumn> get $columns => [id, bggId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bgg_id')) {
      context.handle(
        _bggIdMeta,
        bggId.isAcceptableOrUnknown(data['bgg_id']!, _bggIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bggIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bggId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bgg_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionRecord extends DataClass implements Insertable<SessionRecord> {
  final int id;
  final int bggId;
  final DateTime createdAt;
  const SessionRecord({
    required this.id,
    required this.bggId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bgg_id'] = Variable<int>(bggId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      bggId: Value(bggId),
      createdAt: Value(createdAt),
    );
  }

  factory SessionRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRecord(
      id: serializer.fromJson<int>(json['id']),
      bggId: serializer.fromJson<int>(json['bggId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bggId': serializer.toJson<int>(bggId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionRecord copyWith({int? id, int? bggId, DateTime? createdAt}) =>
      SessionRecord(
        id: id ?? this.id,
        bggId: bggId ?? this.bggId,
        createdAt: createdAt ?? this.createdAt,
      );
  SessionRecord copyWithCompanion(SessionsCompanion data) {
    return SessionRecord(
      id: data.id.present ? data.id.value : this.id,
      bggId: data.bggId.present ? data.bggId.value : this.bggId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRecord(')
          ..write('id: $id, ')
          ..write('bggId: $bggId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bggId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRecord &&
          other.id == this.id &&
          other.bggId == this.bggId &&
          other.createdAt == this.createdAt);
}

class SessionsCompanion extends UpdateCompanion<SessionRecord> {
  final Value<int> id;
  final Value<int> bggId;
  final Value<DateTime> createdAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.bggId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int bggId,
    this.createdAt = const Value.absent(),
  }) : bggId = Value(bggId);
  static Insertable<SessionRecord> custom({
    Expression<int>? id,
    Expression<int>? bggId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bggId != null) 'bgg_id': bggId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? bggId,
    Value<DateTime>? createdAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      bggId: bggId ?? this.bggId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bggId.present) {
      map['bgg_id'] = Variable<int>(bggId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('bggId: $bggId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlayerScoresTable extends PlayerScores
    with TableInfo<$PlayerScoresTable, PlayerScoreRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerScoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES sessions(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<int> playerId = GeneratedColumn<int>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'REFERENCES players(id) ON DELETE CASCADE',
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, playerId, score, rank];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerScoreRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerScoreRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerScoreRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}player_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
    );
  }

  @override
  $PlayerScoresTable createAlias(String alias) {
    return $PlayerScoresTable(attachedDatabase, alias);
  }
}

class PlayerScoreRecord extends DataClass
    implements Insertable<PlayerScoreRecord> {
  final int id;
  final int sessionId;
  final int playerId;
  final int score;
  final int rank;
  const PlayerScoreRecord({
    required this.id,
    required this.sessionId,
    required this.playerId,
    required this.score,
    required this.rank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['player_id'] = Variable<int>(playerId);
    map['score'] = Variable<int>(score);
    map['rank'] = Variable<int>(rank);
    return map;
  }

  PlayerScoresCompanion toCompanion(bool nullToAbsent) {
    return PlayerScoresCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      playerId: Value(playerId),
      score: Value(score),
      rank: Value(rank),
    );
  }

  factory PlayerScoreRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerScoreRecord(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      playerId: serializer.fromJson<int>(json['playerId']),
      score: serializer.fromJson<int>(json['score']),
      rank: serializer.fromJson<int>(json['rank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'playerId': serializer.toJson<int>(playerId),
      'score': serializer.toJson<int>(score),
      'rank': serializer.toJson<int>(rank),
    };
  }

  PlayerScoreRecord copyWith({
    int? id,
    int? sessionId,
    int? playerId,
    int? score,
    int? rank,
  }) => PlayerScoreRecord(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    playerId: playerId ?? this.playerId,
    score: score ?? this.score,
    rank: rank ?? this.rank,
  );
  PlayerScoreRecord copyWithCompanion(PlayerScoresCompanion data) {
    return PlayerScoreRecord(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      score: data.score.present ? data.score.value : this.score,
      rank: data.rank.present ? data.rank.value : this.rank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerScoreRecord(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('score: $score, ')
          ..write('rank: $rank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, playerId, score, rank);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerScoreRecord &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.playerId == this.playerId &&
          other.score == this.score &&
          other.rank == this.rank);
}

class PlayerScoresCompanion extends UpdateCompanion<PlayerScoreRecord> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> playerId;
  final Value<int> score;
  final Value<int> rank;
  const PlayerScoresCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.score = const Value.absent(),
    this.rank = const Value.absent(),
  });
  PlayerScoresCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int playerId,
    this.score = const Value.absent(),
    this.rank = const Value.absent(),
  }) : sessionId = Value(sessionId),
       playerId = Value(playerId);
  static Insertable<PlayerScoreRecord> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? playerId,
    Expression<int>? score,
    Expression<int>? rank,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (playerId != null) 'player_id': playerId,
      if (score != null) 'score': score,
      if (rank != null) 'rank': rank,
    });
  }

  PlayerScoresCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? playerId,
    Value<int>? score,
    Value<int>? rank,
  }) {
    return PlayerScoresCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      playerId: playerId ?? this.playerId,
      score: score ?? this.score,
      rank: rank ?? this.rank,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<int>(playerId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerScoresCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('playerId: $playerId, ')
          ..write('score: $score, ')
          ..write('rank: $rank')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BoardGamesTable boardGames = $BoardGamesTable(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $PlayerScoresTable playerScores = $PlayerScoresTable(this);
  late final GameDao gameDao = GameDao(this as AppDatabase);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    boardGames,
    players,
    sessions,
    playerScores,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'game_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('player_scores', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'players',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('player_scores', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$BoardGamesTableCreateCompanionBuilder =
    BoardGamesCompanion Function({
      Value<int> bggId,
      required String name,
      required int yearPublished,
      Value<String> thumbnail,
      Value<int> minPlayers,
      Value<int> maxPlayers,
      Value<int> playingTime,
      Value<String> description,
      Value<DateTime?> createdAt,
    });
typedef $$BoardGamesTableUpdateCompanionBuilder =
    BoardGamesCompanion Function({
      Value<int> bggId,
      Value<String> name,
      Value<int> yearPublished,
      Value<String> thumbnail,
      Value<int> minPlayers,
      Value<int> maxPlayers,
      Value<int> playingTime,
      Value<String> description,
      Value<DateTime?> createdAt,
    });

final class $$BoardGamesTableReferences
    extends BaseReferences<_$AppDatabase, $BoardGamesTable, BoardGameRecord> {
  $$BoardGamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<SessionRecord>>
  _sessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: $_aliasNameGenerator(db.boardGames.bggId, db.sessions.bggId),
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.bggId.bggId.sqlEquals($_itemColumn<int>('bgg_id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BoardGamesTableFilterComposer
    extends Composer<_$AppDatabase, $BoardGamesTable> {
  $$BoardGamesTableFilterComposer({
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

  ColumnFilters<int> get yearPublished => $composableBuilder(
    column: $table.yearPublished,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bggId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.bggId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BoardGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $BoardGamesTable> {
  $$BoardGamesTableOrderingComposer({
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

  ColumnOrderings<int> get yearPublished => $composableBuilder(
    column: $table.yearPublished,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BoardGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BoardGamesTable> {
  $$BoardGamesTableAnnotationComposer({
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

  GeneratedColumn<int> get yearPublished => $composableBuilder(
    column: $table.yearPublished,
    builder: (column) => column,
  );

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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bggId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.bggId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BoardGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BoardGamesTable,
          BoardGameRecord,
          $$BoardGamesTableFilterComposer,
          $$BoardGamesTableOrderingComposer,
          $$BoardGamesTableAnnotationComposer,
          $$BoardGamesTableCreateCompanionBuilder,
          $$BoardGamesTableUpdateCompanionBuilder,
          (BoardGameRecord, $$BoardGamesTableReferences),
          BoardGameRecord,
          PrefetchHooks Function({bool sessionsRefs})
        > {
  $$BoardGamesTableTableManager(_$AppDatabase db, $BoardGamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BoardGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BoardGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BoardGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> bggId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> yearPublished = const Value.absent(),
                Value<String> thumbnail = const Value.absent(),
                Value<int> minPlayers = const Value.absent(),
                Value<int> maxPlayers = const Value.absent(),
                Value<int> playingTime = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => BoardGamesCompanion(
                bggId: bggId,
                name: name,
                yearPublished: yearPublished,
                thumbnail: thumbnail,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                playingTime: playingTime,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> bggId = const Value.absent(),
                required String name,
                required int yearPublished,
                Value<String> thumbnail = const Value.absent(),
                Value<int> minPlayers = const Value.absent(),
                Value<int> maxPlayers = const Value.absent(),
                Value<int> playingTime = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => BoardGamesCompanion.insert(
                bggId: bggId,
                name: name,
                yearPublished: yearPublished,
                thumbnail: thumbnail,
                minPlayers: minPlayers,
                maxPlayers: maxPlayers,
                playingTime: playingTime,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BoardGamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<
                      BoardGameRecord,
                      $BoardGamesTable,
                      SessionRecord
                    >(
                      currentTable: table,
                      referencedTable: $$BoardGamesTableReferences
                          ._sessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BoardGamesTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.bggId == item.bggId),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BoardGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BoardGamesTable,
      BoardGameRecord,
      $$BoardGamesTableFilterComposer,
      $$BoardGamesTableOrderingComposer,
      $$BoardGamesTableAnnotationComposer,
      $$BoardGamesTableCreateCompanionBuilder,
      $$BoardGamesTableUpdateCompanionBuilder,
      (BoardGameRecord, $$BoardGamesTableReferences),
      BoardGameRecord,
      PrefetchHooks Function({bool sessionsRefs})
    >;
typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime?> createdAt,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime?> createdAt,
    });

final class $$PlayersTableReferences
    extends BaseReferences<_$AppDatabase, $PlayersTable, PlayerRecord> {
  $$PlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlayerScoresTable, List<PlayerScoreRecord>>
  _playerScoresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playerScores,
    aliasName: $_aliasNameGenerator(db.players.id, db.playerScores.playerId),
  );

  $$PlayerScoresTableProcessedTableManager get playerScoresRefs {
    final manager = $$PlayerScoresTableTableManager(
      $_db,
      $_db.playerScores,
    ).filter((f) => f.playerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerScoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> playerScoresRefs(
    Expression<bool> Function($$PlayerScoresTableFilterComposer f) f,
  ) {
    final $$PlayerScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerScores,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerScoresTableFilterComposer(
            $db: $db,
            $table: $db.playerScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> playerScoresRefs<T extends Object>(
    Expression<T> Function($$PlayerScoresTableAnnotationComposer a) f,
  ) {
    final $$PlayerScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerScores,
      getReferencedColumn: (t) => t.playerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.playerScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          PlayerRecord,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (PlayerRecord, $$PlayersTableReferences),
          PlayerRecord,
          PrefetchHooks Function({bool playerScoresRefs})
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => PlayersCompanion(id: id, name: name, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime?> createdAt = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({playerScoresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (playerScoresRefs) db.playerScores],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playerScoresRefs)
                    await $_getPrefetchedData<
                      PlayerRecord,
                      $PlayersTable,
                      PlayerScoreRecord
                    >(
                      currentTable: table,
                      referencedTable: $$PlayersTableReferences
                          ._playerScoresRefsTable(db),
                      managerFromTypedResult: (p0) => $$PlayersTableReferences(
                        db,
                        table,
                        p0,
                      ).playerScoresRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.playerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      PlayerRecord,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (PlayerRecord, $$PlayersTableReferences),
      PlayerRecord,
      PrefetchHooks Function({bool playerScoresRefs})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required int bggId,
      Value<DateTime> createdAt,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<int> bggId,
      Value<DateTime> createdAt,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionRecord> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BoardGamesTable _bggIdTable(_$AppDatabase db) =>
      db.boardGames.createAlias(
        $_aliasNameGenerator(db.sessions.bggId, db.boardGames.bggId),
      );

  $$BoardGamesTableProcessedTableManager get bggId {
    final $_column = $_itemColumn<int>('bgg_id')!;

    final manager = $$BoardGamesTableTableManager(
      $_db,
      $_db.boardGames,
    ).filter((f) => f.bggId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bggIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlayerScoresTable, List<PlayerScoreRecord>>
  _playerScoresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.playerScores,
    aliasName: $_aliasNameGenerator(db.sessions.id, db.playerScores.sessionId),
  );

  $$PlayerScoresTableProcessedTableManager get playerScoresRefs {
    final manager = $$PlayerScoresTableTableManager(
      $_db,
      $_db.playerScores,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_playerScoresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BoardGamesTableFilterComposer get bggId {
    final $$BoardGamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bggId,
      referencedTable: $db.boardGames,
      getReferencedColumn: (t) => t.bggId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardGamesTableFilterComposer(
            $db: $db,
            $table: $db.boardGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> playerScoresRefs(
    Expression<bool> Function($$PlayerScoresTableFilterComposer f) f,
  ) {
    final $$PlayerScoresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerScores,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerScoresTableFilterComposer(
            $db: $db,
            $table: $db.playerScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BoardGamesTableOrderingComposer get bggId {
    final $$BoardGamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bggId,
      referencedTable: $db.boardGames,
      getReferencedColumn: (t) => t.bggId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardGamesTableOrderingComposer(
            $db: $db,
            $table: $db.boardGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BoardGamesTableAnnotationComposer get bggId {
    final $$BoardGamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bggId,
      referencedTable: $db.boardGames,
      getReferencedColumn: (t) => t.bggId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardGamesTableAnnotationComposer(
            $db: $db,
            $table: $db.boardGames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> playerScoresRefs<T extends Object>(
    Expression<T> Function($$PlayerScoresTableAnnotationComposer a) f,
  ) {
    final $$PlayerScoresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.playerScores,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayerScoresTableAnnotationComposer(
            $db: $db,
            $table: $db.playerScores,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          SessionRecord,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (SessionRecord, $$SessionsTableReferences),
          SessionRecord,
          PrefetchHooks Function({bool bggId, bool playerScoresRefs})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bggId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) =>
                  SessionsCompanion(id: id, bggId: bggId, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bggId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                bggId: bggId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bggId = false, playerScoresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (playerScoresRefs) db.playerScores],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bggId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bggId,
                                referencedTable: $$SessionsTableReferences
                                    ._bggIdTable(db),
                                referencedColumn: $$SessionsTableReferences
                                    ._bggIdTable(db)
                                    .bggId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (playerScoresRefs)
                    await $_getPrefetchedData<
                      SessionRecord,
                      $SessionsTable,
                      PlayerScoreRecord
                    >(
                      currentTable: table,
                      referencedTable: $$SessionsTableReferences
                          ._playerScoresRefsTable(db),
                      managerFromTypedResult: (p0) => $$SessionsTableReferences(
                        db,
                        table,
                        p0,
                      ).playerScoresRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      SessionRecord,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (SessionRecord, $$SessionsTableReferences),
      SessionRecord,
      PrefetchHooks Function({bool bggId, bool playerScoresRefs})
    >;
typedef $$PlayerScoresTableCreateCompanionBuilder =
    PlayerScoresCompanion Function({
      Value<int> id,
      required int sessionId,
      required int playerId,
      Value<int> score,
      Value<int> rank,
    });
typedef $$PlayerScoresTableUpdateCompanionBuilder =
    PlayerScoresCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> playerId,
      Value<int> score,
      Value<int> rank,
    });

final class $$PlayerScoresTableReferences
    extends
        BaseReferences<_$AppDatabase, $PlayerScoresTable, PlayerScoreRecord> {
  $$PlayerScoresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias(
        $_aliasNameGenerator(db.playerScores.sessionId, db.sessions.id),
      );

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlayersTable _playerIdTable(_$AppDatabase db) =>
      db.players.createAlias(
        $_aliasNameGenerator(db.playerScores.playerId, db.players.id),
      );

  $$PlayersTableProcessedTableManager get playerId {
    final $_column = $_itemColumn<int>('player_id')!;

    final manager = $$PlayersTableTableManager(
      $_db,
      $_db.players,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlayerScoresTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerScoresTable> {
  $$PlayerScoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableFilterComposer get playerId {
    final $$PlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableFilterComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerScoresTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerScoresTable> {
  $$PlayerScoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableOrderingComposer get playerId {
    final $$PlayersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableOrderingComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerScoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerScoresTable> {
  $$PlayerScoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlayersTableAnnotationComposer get playerId {
    final $$PlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playerId,
      referencedTable: $db.players,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.players,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlayerScoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerScoresTable,
          PlayerScoreRecord,
          $$PlayerScoresTableFilterComposer,
          $$PlayerScoresTableOrderingComposer,
          $$PlayerScoresTableAnnotationComposer,
          $$PlayerScoresTableCreateCompanionBuilder,
          $$PlayerScoresTableUpdateCompanionBuilder,
          (PlayerScoreRecord, $$PlayerScoresTableReferences),
          PlayerScoreRecord,
          PrefetchHooks Function({bool sessionId, bool playerId})
        > {
  $$PlayerScoresTableTableManager(_$AppDatabase db, $PlayerScoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerScoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerScoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerScoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> playerId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> rank = const Value.absent(),
              }) => PlayerScoresCompanion(
                id: id,
                sessionId: sessionId,
                playerId: playerId,
                score: score,
                rank: rank,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int playerId,
                Value<int> score = const Value.absent(),
                Value<int> rank = const Value.absent(),
              }) => PlayerScoresCompanion.insert(
                id: id,
                sessionId: sessionId,
                playerId: playerId,
                score: score,
                rank: rank,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlayerScoresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, playerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$PlayerScoresTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$PlayerScoresTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (playerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.playerId,
                                referencedTable: $$PlayerScoresTableReferences
                                    ._playerIdTable(db),
                                referencedColumn: $$PlayerScoresTableReferences
                                    ._playerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlayerScoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerScoresTable,
      PlayerScoreRecord,
      $$PlayerScoresTableFilterComposer,
      $$PlayerScoresTableOrderingComposer,
      $$PlayerScoresTableAnnotationComposer,
      $$PlayerScoresTableCreateCompanionBuilder,
      $$PlayerScoresTableUpdateCompanionBuilder,
      (PlayerScoreRecord, $$PlayerScoresTableReferences),
      PlayerScoreRecord,
      PrefetchHooks Function({bool sessionId, bool playerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BoardGamesTableTableManager get boardGames =>
      $$BoardGamesTableTableManager(_db, _db.boardGames);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$PlayerScoresTableTableManager get playerScores =>
      $$PlayerScoresTableTableManager(_db, _db.playerScores);
}
