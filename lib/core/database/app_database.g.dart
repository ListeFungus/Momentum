// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultProjectColorHex),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trashedAt = GeneratedColumn<DateTime>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purgeAtMeta = const VerificationMeta(
    'purgeAt',
  );
  @override
  late final GeneratedColumn<DateTime> purgeAt = GeneratedColumn<DateTime>(
    'purge_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    colorHex,
    sortOrder,
    archivedAt,
    trashedAt,
    purgeAt,
    deletedAt,
    revision,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    }
    if (data.containsKey('purge_at')) {
      context.handle(
        _purgeAtMeta,
        purgeAt.isAcceptableOrUnknown(data['purge_at']!, _purgeAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      colorHex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color_hex'],
          )!,
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trashed_at'],
      ),
      purgeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purge_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      revision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}revision'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String description;
  final String colorHex;
  final int sortOrder;
  final DateTime? archivedAt;
  final DateTime? trashedAt;
  final DateTime? purgeAt;
  final DateTime? deletedAt;
  final int revision;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.colorHex,
    required this.sortOrder,
    this.archivedAt,
    this.trashedAt,
    this.purgeAt,
    this.deletedAt,
    required this.revision,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['color_hex'] = Variable<String>(colorHex);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<DateTime>(trashedAt);
    }
    if (!nullToAbsent || purgeAt != null) {
      map['purge_at'] = Variable<DateTime>(purgeAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['revision'] = Variable<int>(revision);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      colorHex: Value(colorHex),
      sortOrder: Value(sortOrder),
      archivedAt:
          archivedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(archivedAt),
      trashedAt:
          trashedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(trashedAt),
      purgeAt:
          purgeAt == null && nullToAbsent
              ? const Value.absent()
              : Value(purgeAt),
      deletedAt:
          deletedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(deletedAt),
      revision: Value(revision),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      trashedAt: serializer.fromJson<DateTime?>(json['trashedAt']),
      purgeAt: serializer.fromJson<DateTime?>(json['purgeAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'colorHex': serializer.toJson<String>(colorHex),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'trashedAt': serializer.toJson<DateTime?>(trashedAt),
      'purgeAt': serializer.toJson<DateTime?>(purgeAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'revision': serializer.toJson<int>(revision),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? colorHex,
    int? sortOrder,
    Value<DateTime?> archivedAt = const Value.absent(),
    Value<DateTime?> trashedAt = const Value.absent(),
    Value<DateTime?> purgeAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    int? revision,
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    colorHex: colorHex ?? this.colorHex,
    sortOrder: sortOrder ?? this.sortOrder,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
    purgeAt: purgeAt.present ? purgeAt.value : this.purgeAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    revision: revision ?? this.revision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      purgeAt: data.purgeAt.present ? data.purgeAt.value : this.purgeAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('purgeAt: $purgeAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    colorHex,
    sortOrder,
    archivedAt,
    trashedAt,
    purgeAt,
    deletedAt,
    revision,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.colorHex == this.colorHex &&
          other.sortOrder == this.sortOrder &&
          other.archivedAt == this.archivedAt &&
          other.trashedAt == this.trashedAt &&
          other.purgeAt == this.purgeAt &&
          other.deletedAt == this.deletedAt &&
          other.revision == this.revision &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> colorHex;
  final Value<int> sortOrder;
  final Value<DateTime?> archivedAt;
  final Value<DateTime?> trashedAt;
  final Value<DateTime?> purgeAt;
  final Value<DateTime?> deletedAt;
  final Value<int> revision;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.purgeAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.purgeAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? colorHex,
    Expression<int>? sortOrder,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? trashedAt,
    Expression<DateTime>? purgeAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? revision,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (colorHex != null) 'color_hex': colorHex,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (purgeAt != null) 'purge_at': purgeAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (revision != null) 'revision': revision,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? colorHex,
    Value<int>? sortOrder,
    Value<DateTime?>? archivedAt,
    Value<DateTime?>? trashedAt,
    Value<DateTime?>? purgeAt,
    Value<DateTime?>? deletedAt,
    Value<int>? revision,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      sortOrder: sortOrder ?? this.sortOrder,
      archivedAt: archivedAt ?? this.archivedAt,
      trashedAt: trashedAt ?? this.trashedAt,
      purgeAt: purgeAt ?? this.purgeAt,
      deletedAt: deletedAt ?? this.deletedAt,
      revision: revision ?? this.revision,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<DateTime>(trashedAt.value);
    }
    if (purgeAt.present) {
      map['purge_at'] = Variable<DateTime>(purgeAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('purgeAt: $purgeAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AufgabenTable extends Aufgaben with TableInfo<$AufgabenTable, Aufgabe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AufgabenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE SET NULL',
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
  );
  static const VerificationMeta _beschreibungMeta = const VerificationMeta(
    'beschreibung',
  );
  @override
  late final GeneratedColumn<String> beschreibung = GeneratedColumn<String>(
    'beschreibung',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _erfassungsmodusMeta = const VerificationMeta(
    'erfassungsmodus',
  );
  @override
  late final GeneratedColumn<String> erfassungsmodus = GeneratedColumn<String>(
    'erfassungsmodus',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('habit'),
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _successValueMeta = const VerificationMeta(
    'successValue',
  );
  @override
  late final GeneratedColumn<bool> successValue = GeneratedColumn<bool>(
    'success_value',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success_value" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _activeWeekdaysMeta = const VerificationMeta(
    'activeWeekdays',
  );
  @override
  late final GeneratedColumn<String> activeWeekdays = GeneratedColumn<String>(
    'active_weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('1,2,3,4,5,6,7'),
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trashedAt = GeneratedColumn<DateTime>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purgeAtMeta = const VerificationMeta(
    'purgeAt',
  );
  @override
  late final GeneratedColumn<DateTime> purgeAt = GeneratedColumn<DateTime>(
    'purge_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lifecycleRevisionMeta = const VerificationMeta(
    'lifecycleRevision',
  );
  @override
  late final GeneratedColumn<int> lifecycleRevision = GeneratedColumn<int>(
    'lifecycle_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lifecycleUpdatedAtMeta =
      const VerificationMeta('lifecycleUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lifecycleUpdatedAt =
      GeneratedColumn<DateTime>(
        'lifecycle_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _missedPolicyMeta = const VerificationMeta(
    'missedPolicy',
  );
  @override
  late final GeneratedColumn<String> missedPolicy = GeneratedColumn<String>(
    'missed_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(MissedPolicy.none),
  );
  static const VerificationMeta _missedConsequenceMeta = const VerificationMeta(
    'missedConsequence',
  );
  @override
  late final GeneratedColumn<String> missedConsequence =
      GeneratedColumn<String>(
        'missed_consequence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(MissedConsequence.markAsNotDone),
      );
  static const VerificationMeta _missedBufferDaysMeta = const VerificationMeta(
    'missedBufferDays',
  );
  @override
  late final GeneratedColumn<int> missedBufferDays = GeneratedColumn<int>(
    'missed_buffer_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _postBufferBehaviorMeta =
      const VerificationMeta('postBufferBehavior');
  @override
  late final GeneratedColumn<String> postBufferBehavior =
      GeneratedColumn<String>(
        'post_buffer_behavior',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(PostBufferBehavior.markAsFailure),
      );
  static const VerificationMeta _maxCarryoverCountMeta = const VerificationMeta(
    'maxCarryoverCount',
  );
  @override
  late final GeneratedColumn<int> maxCarryoverCount = GeneratedColumn<int>(
    'max_carryover_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskGoalType.none),
  );
  static const VerificationMeta _goalValueMeta = const VerificationMeta(
    'goalValue',
  );
  @override
  late final GeneratedColumn<int> goalValue = GeneratedColumn<int>(
    'goal_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _goalWindowDaysMeta = const VerificationMeta(
    'goalWindowDays',
  );
  @override
  late final GeneratedColumn<int> goalWindowDays = GeneratedColumn<int>(
    'goal_window_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalPeriodMeta = const VerificationMeta(
    'goalPeriod',
  );
  @override
  late final GeneratedColumn<String> goalPeriod = GeneratedColumn<String>(
    'goal_period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(GoalPeriod.week),
  );
  static const VerificationMeta _goalPeriodAlignmentMeta =
      const VerificationMeta('goalPeriodAlignment');
  @override
  late final GeneratedColumn<String> goalPeriodAlignment =
      GeneratedColumn<String>(
        'goal_period_alignment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(GoalPeriodAlignment.calendar),
      );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _valueCommitmentMeta = const VerificationMeta(
    'valueCommitment',
  );
  @override
  late final GeneratedColumn<String> valueCommitment = GeneratedColumn<String>(
    'value_commitment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _valueUnitKeyMeta = const VerificationMeta(
    'valueUnitKey',
  );
  @override
  late final GeneratedColumn<String> valueUnitKey = GeneratedColumn<String>(
    'value_unit_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _valueUnitLabelMeta = const VerificationMeta(
    'valueUnitLabel',
  );
  @override
  late final GeneratedColumn<String> valueUnitLabel = GeneratedColumn<String>(
    'value_unit_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    beschreibung,
    erfassungsmodus,
    taskType,
    questionText,
    successValue,
    activeWeekdays,
    recurrence,
    startDate,
    createdAt,
    updatedAt,
    endDate,
    dueDate,
    isActive,
    trashedAt,
    purgeAt,
    lifecycleRevision,
    lifecycleUpdatedAt,
    missedPolicy,
    missedConsequence,
    missedBufferDays,
    postBufferBehavior,
    maxCarryoverCount,
    goalType,
    goalValue,
    goalWindowDays,
    goalPeriod,
    goalPeriodAlignment,
    valueType,
    valueCommitment,
    valueUnitKey,
    valueUnitLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aufgaben';
  @override
  VerificationContext validateIntegrity(
    Insertable<Aufgabe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
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
    if (data.containsKey('beschreibung')) {
      context.handle(
        _beschreibungMeta,
        beschreibung.isAcceptableOrUnknown(
          data['beschreibung']!,
          _beschreibungMeta,
        ),
      );
    }
    if (data.containsKey('erfassungsmodus')) {
      context.handle(
        _erfassungsmodusMeta,
        erfassungsmodus.isAcceptableOrUnknown(
          data['erfassungsmodus']!,
          _erfassungsmodusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_erfassungsmodusMeta);
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    }
    if (data.containsKey('success_value')) {
      context.handle(
        _successValueMeta,
        successValue.isAcceptableOrUnknown(
          data['success_value']!,
          _successValueMeta,
        ),
      );
    }
    if (data.containsKey('active_weekdays')) {
      context.handle(
        _activeWeekdaysMeta,
        activeWeekdays.isAcceptableOrUnknown(
          data['active_weekdays']!,
          _activeWeekdaysMeta,
        ),
      );
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    }
    if (data.containsKey('purge_at')) {
      context.handle(
        _purgeAtMeta,
        purgeAt.isAcceptableOrUnknown(data['purge_at']!, _purgeAtMeta),
      );
    }
    if (data.containsKey('lifecycle_revision')) {
      context.handle(
        _lifecycleRevisionMeta,
        lifecycleRevision.isAcceptableOrUnknown(
          data['lifecycle_revision']!,
          _lifecycleRevisionMeta,
        ),
      );
    }
    if (data.containsKey('lifecycle_updated_at')) {
      context.handle(
        _lifecycleUpdatedAtMeta,
        lifecycleUpdatedAt.isAcceptableOrUnknown(
          data['lifecycle_updated_at']!,
          _lifecycleUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('missed_policy')) {
      context.handle(
        _missedPolicyMeta,
        missedPolicy.isAcceptableOrUnknown(
          data['missed_policy']!,
          _missedPolicyMeta,
        ),
      );
    }
    if (data.containsKey('missed_consequence')) {
      context.handle(
        _missedConsequenceMeta,
        missedConsequence.isAcceptableOrUnknown(
          data['missed_consequence']!,
          _missedConsequenceMeta,
        ),
      );
    }
    if (data.containsKey('missed_buffer_days')) {
      context.handle(
        _missedBufferDaysMeta,
        missedBufferDays.isAcceptableOrUnknown(
          data['missed_buffer_days']!,
          _missedBufferDaysMeta,
        ),
      );
    }
    if (data.containsKey('post_buffer_behavior')) {
      context.handle(
        _postBufferBehaviorMeta,
        postBufferBehavior.isAcceptableOrUnknown(
          data['post_buffer_behavior']!,
          _postBufferBehaviorMeta,
        ),
      );
    }
    if (data.containsKey('max_carryover_count')) {
      context.handle(
        _maxCarryoverCountMeta,
        maxCarryoverCount.isAcceptableOrUnknown(
          data['max_carryover_count']!,
          _maxCarryoverCountMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('goal_value')) {
      context.handle(
        _goalValueMeta,
        goalValue.isAcceptableOrUnknown(data['goal_value']!, _goalValueMeta),
      );
    }
    if (data.containsKey('goal_window_days')) {
      context.handle(
        _goalWindowDaysMeta,
        goalWindowDays.isAcceptableOrUnknown(
          data['goal_window_days']!,
          _goalWindowDaysMeta,
        ),
      );
    }
    if (data.containsKey('goal_period')) {
      context.handle(
        _goalPeriodMeta,
        goalPeriod.isAcceptableOrUnknown(data['goal_period']!, _goalPeriodMeta),
      );
    }
    if (data.containsKey('goal_period_alignment')) {
      context.handle(
        _goalPeriodAlignmentMeta,
        goalPeriodAlignment.isAcceptableOrUnknown(
          data['goal_period_alignment']!,
          _goalPeriodAlignmentMeta,
        ),
      );
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    }
    if (data.containsKey('value_commitment')) {
      context.handle(
        _valueCommitmentMeta,
        valueCommitment.isAcceptableOrUnknown(
          data['value_commitment']!,
          _valueCommitmentMeta,
        ),
      );
    }
    if (data.containsKey('value_unit_key')) {
      context.handle(
        _valueUnitKeyMeta,
        valueUnitKey.isAcceptableOrUnknown(
          data['value_unit_key']!,
          _valueUnitKeyMeta,
        ),
      );
    }
    if (data.containsKey('value_unit_label')) {
      context.handle(
        _valueUnitLabelMeta,
        valueUnitLabel.isAcceptableOrUnknown(
          data['value_unit_label']!,
          _valueUnitLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Aufgabe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Aufgabe(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      beschreibung:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}beschreibung'],
          )!,
      erfassungsmodus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}erfassungsmodus'],
          )!,
      taskType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_type'],
          )!,
      questionText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}question_text'],
          )!,
      successValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}success_value'],
          )!,
      activeWeekdays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}active_weekdays'],
          )!,
      recurrence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}recurrence'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trashed_at'],
      ),
      purgeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purge_at'],
      ),
      lifecycleRevision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}lifecycle_revision'],
          )!,
      lifecycleUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lifecycle_updated_at'],
      ),
      missedPolicy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}missed_policy'],
          )!,
      missedConsequence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}missed_consequence'],
          )!,
      missedBufferDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}missed_buffer_days'],
          )!,
      postBufferBehavior:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}post_buffer_behavior'],
          )!,
      maxCarryoverCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}max_carryover_count'],
          )!,
      goalType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_type'],
          )!,
      goalValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}goal_value'],
          )!,
      goalWindowDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_window_days'],
      ),
      goalPeriod:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_period'],
          )!,
      goalPeriodAlignment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_period_alignment'],
          )!,
      valueType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_type'],
          )!,
      valueCommitment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_commitment'],
          )!,
      valueUnitKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_unit_key'],
          )!,
      valueUnitLabel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_unit_label'],
          )!,
    );
  }

  @override
  $AufgabenTable createAlias(String alias) {
    return $AufgabenTable(attachedDatabase, alias);
  }
}

class Aufgabe extends DataClass implements Insertable<Aufgabe> {
  final String id;
  final String? projectId;
  final String name;
  final String beschreibung;
  final String erfassungsmodus;
  final String taskType;
  final String questionText;
  final bool successValue;
  final String activeWeekdays;
  final String recurrence;
  final DateTime startDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? endDate;
  final DateTime? dueDate;
  final bool isActive;
  final DateTime? trashedAt;
  final DateTime? purgeAt;
  final int lifecycleRevision;
  final DateTime? lifecycleUpdatedAt;
  final String missedPolicy;
  final String missedConsequence;
  final int missedBufferDays;
  final String postBufferBehavior;
  final int maxCarryoverCount;
  final String goalType;
  final int goalValue;
  final int? goalWindowDays;
  final String goalPeriod;
  final String goalPeriodAlignment;
  final String valueType;
  final String valueCommitment;
  final String valueUnitKey;
  final String valueUnitLabel;
  const Aufgabe({
    required this.id,
    this.projectId,
    required this.name,
    required this.beschreibung,
    required this.erfassungsmodus,
    required this.taskType,
    required this.questionText,
    required this.successValue,
    required this.activeWeekdays,
    required this.recurrence,
    required this.startDate,
    required this.createdAt,
    this.updatedAt,
    this.endDate,
    this.dueDate,
    required this.isActive,
    this.trashedAt,
    this.purgeAt,
    required this.lifecycleRevision,
    this.lifecycleUpdatedAt,
    required this.missedPolicy,
    required this.missedConsequence,
    required this.missedBufferDays,
    required this.postBufferBehavior,
    required this.maxCarryoverCount,
    required this.goalType,
    required this.goalValue,
    this.goalWindowDays,
    required this.goalPeriod,
    required this.goalPeriodAlignment,
    required this.valueType,
    required this.valueCommitment,
    required this.valueUnitKey,
    required this.valueUnitLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['name'] = Variable<String>(name);
    map['beschreibung'] = Variable<String>(beschreibung);
    map['erfassungsmodus'] = Variable<String>(erfassungsmodus);
    map['task_type'] = Variable<String>(taskType);
    map['question_text'] = Variable<String>(questionText);
    map['success_value'] = Variable<bool>(successValue);
    map['active_weekdays'] = Variable<String>(activeWeekdays);
    map['recurrence'] = Variable<String>(recurrence);
    map['start_date'] = Variable<DateTime>(startDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<DateTime>(trashedAt);
    }
    if (!nullToAbsent || purgeAt != null) {
      map['purge_at'] = Variable<DateTime>(purgeAt);
    }
    map['lifecycle_revision'] = Variable<int>(lifecycleRevision);
    if (!nullToAbsent || lifecycleUpdatedAt != null) {
      map['lifecycle_updated_at'] = Variable<DateTime>(lifecycleUpdatedAt);
    }
    map['missed_policy'] = Variable<String>(missedPolicy);
    map['missed_consequence'] = Variable<String>(missedConsequence);
    map['missed_buffer_days'] = Variable<int>(missedBufferDays);
    map['post_buffer_behavior'] = Variable<String>(postBufferBehavior);
    map['max_carryover_count'] = Variable<int>(maxCarryoverCount);
    map['goal_type'] = Variable<String>(goalType);
    map['goal_value'] = Variable<int>(goalValue);
    if (!nullToAbsent || goalWindowDays != null) {
      map['goal_window_days'] = Variable<int>(goalWindowDays);
    }
    map['goal_period'] = Variable<String>(goalPeriod);
    map['goal_period_alignment'] = Variable<String>(goalPeriodAlignment);
    map['value_type'] = Variable<String>(valueType);
    map['value_commitment'] = Variable<String>(valueCommitment);
    map['value_unit_key'] = Variable<String>(valueUnitKey);
    map['value_unit_label'] = Variable<String>(valueUnitLabel);
    return map;
  }

  AufgabenCompanion toCompanion(bool nullToAbsent) {
    return AufgabenCompanion(
      id: Value(id),
      projectId:
          projectId == null && nullToAbsent
              ? const Value.absent()
              : Value(projectId),
      name: Value(name),
      beschreibung: Value(beschreibung),
      erfassungsmodus: Value(erfassungsmodus),
      taskType: Value(taskType),
      questionText: Value(questionText),
      successValue: Value(successValue),
      activeWeekdays: Value(activeWeekdays),
      recurrence: Value(recurrence),
      startDate: Value(startDate),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
      endDate:
          endDate == null && nullToAbsent
              ? const Value.absent()
              : Value(endDate),
      dueDate:
          dueDate == null && nullToAbsent
              ? const Value.absent()
              : Value(dueDate),
      isActive: Value(isActive),
      trashedAt:
          trashedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(trashedAt),
      purgeAt:
          purgeAt == null && nullToAbsent
              ? const Value.absent()
              : Value(purgeAt),
      lifecycleRevision: Value(lifecycleRevision),
      lifecycleUpdatedAt:
          lifecycleUpdatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lifecycleUpdatedAt),
      missedPolicy: Value(missedPolicy),
      missedConsequence: Value(missedConsequence),
      missedBufferDays: Value(missedBufferDays),
      postBufferBehavior: Value(postBufferBehavior),
      maxCarryoverCount: Value(maxCarryoverCount),
      goalType: Value(goalType),
      goalValue: Value(goalValue),
      goalWindowDays:
          goalWindowDays == null && nullToAbsent
              ? const Value.absent()
              : Value(goalWindowDays),
      goalPeriod: Value(goalPeriod),
      goalPeriodAlignment: Value(goalPeriodAlignment),
      valueType: Value(valueType),
      valueCommitment: Value(valueCommitment),
      valueUnitKey: Value(valueUnitKey),
      valueUnitLabel: Value(valueUnitLabel),
    );
  }

  factory Aufgabe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Aufgabe(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      beschreibung: serializer.fromJson<String>(json['beschreibung']),
      erfassungsmodus: serializer.fromJson<String>(json['erfassungsmodus']),
      taskType: serializer.fromJson<String>(json['taskType']),
      questionText: serializer.fromJson<String>(json['questionText']),
      successValue: serializer.fromJson<bool>(json['successValue']),
      activeWeekdays: serializer.fromJson<String>(json['activeWeekdays']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      trashedAt: serializer.fromJson<DateTime?>(json['trashedAt']),
      purgeAt: serializer.fromJson<DateTime?>(json['purgeAt']),
      lifecycleRevision: serializer.fromJson<int>(json['lifecycleRevision']),
      lifecycleUpdatedAt: serializer.fromJson<DateTime?>(
        json['lifecycleUpdatedAt'],
      ),
      missedPolicy: serializer.fromJson<String>(json['missedPolicy']),
      missedConsequence: serializer.fromJson<String>(json['missedConsequence']),
      missedBufferDays: serializer.fromJson<int>(json['missedBufferDays']),
      postBufferBehavior: serializer.fromJson<String>(
        json['postBufferBehavior'],
      ),
      maxCarryoverCount: serializer.fromJson<int>(json['maxCarryoverCount']),
      goalType: serializer.fromJson<String>(json['goalType']),
      goalValue: serializer.fromJson<int>(json['goalValue']),
      goalWindowDays: serializer.fromJson<int?>(json['goalWindowDays']),
      goalPeriod: serializer.fromJson<String>(json['goalPeriod']),
      goalPeriodAlignment: serializer.fromJson<String>(
        json['goalPeriodAlignment'],
      ),
      valueType: serializer.fromJson<String>(json['valueType']),
      valueCommitment: serializer.fromJson<String>(json['valueCommitment']),
      valueUnitKey: serializer.fromJson<String>(json['valueUnitKey']),
      valueUnitLabel: serializer.fromJson<String>(json['valueUnitLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'name': serializer.toJson<String>(name),
      'beschreibung': serializer.toJson<String>(beschreibung),
      'erfassungsmodus': serializer.toJson<String>(erfassungsmodus),
      'taskType': serializer.toJson<String>(taskType),
      'questionText': serializer.toJson<String>(questionText),
      'successValue': serializer.toJson<bool>(successValue),
      'activeWeekdays': serializer.toJson<String>(activeWeekdays),
      'recurrence': serializer.toJson<String>(recurrence),
      'startDate': serializer.toJson<DateTime>(startDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'isActive': serializer.toJson<bool>(isActive),
      'trashedAt': serializer.toJson<DateTime?>(trashedAt),
      'purgeAt': serializer.toJson<DateTime?>(purgeAt),
      'lifecycleRevision': serializer.toJson<int>(lifecycleRevision),
      'lifecycleUpdatedAt': serializer.toJson<DateTime?>(lifecycleUpdatedAt),
      'missedPolicy': serializer.toJson<String>(missedPolicy),
      'missedConsequence': serializer.toJson<String>(missedConsequence),
      'missedBufferDays': serializer.toJson<int>(missedBufferDays),
      'postBufferBehavior': serializer.toJson<String>(postBufferBehavior),
      'maxCarryoverCount': serializer.toJson<int>(maxCarryoverCount),
      'goalType': serializer.toJson<String>(goalType),
      'goalValue': serializer.toJson<int>(goalValue),
      'goalWindowDays': serializer.toJson<int?>(goalWindowDays),
      'goalPeriod': serializer.toJson<String>(goalPeriod),
      'goalPeriodAlignment': serializer.toJson<String>(goalPeriodAlignment),
      'valueType': serializer.toJson<String>(valueType),
      'valueCommitment': serializer.toJson<String>(valueCommitment),
      'valueUnitKey': serializer.toJson<String>(valueUnitKey),
      'valueUnitLabel': serializer.toJson<String>(valueUnitLabel),
    };
  }

  Aufgabe copyWith({
    String? id,
    Value<String?> projectId = const Value.absent(),
    String? name,
    String? beschreibung,
    String? erfassungsmodus,
    String? taskType,
    String? questionText,
    bool? successValue,
    String? activeWeekdays,
    String? recurrence,
    DateTime? startDate,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    bool? isActive,
    Value<DateTime?> trashedAt = const Value.absent(),
    Value<DateTime?> purgeAt = const Value.absent(),
    int? lifecycleRevision,
    Value<DateTime?> lifecycleUpdatedAt = const Value.absent(),
    String? missedPolicy,
    String? missedConsequence,
    int? missedBufferDays,
    String? postBufferBehavior,
    int? maxCarryoverCount,
    String? goalType,
    int? goalValue,
    Value<int?> goalWindowDays = const Value.absent(),
    String? goalPeriod,
    String? goalPeriodAlignment,
    String? valueType,
    String? valueCommitment,
    String? valueUnitKey,
    String? valueUnitLabel,
  }) => Aufgabe(
    id: id ?? this.id,
    projectId: projectId.present ? projectId.value : this.projectId,
    name: name ?? this.name,
    beschreibung: beschreibung ?? this.beschreibung,
    erfassungsmodus: erfassungsmodus ?? this.erfassungsmodus,
    taskType: taskType ?? this.taskType,
    questionText: questionText ?? this.questionText,
    successValue: successValue ?? this.successValue,
    activeWeekdays: activeWeekdays ?? this.activeWeekdays,
    recurrence: recurrence ?? this.recurrence,
    startDate: startDate ?? this.startDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    endDate: endDate.present ? endDate.value : this.endDate,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    isActive: isActive ?? this.isActive,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
    purgeAt: purgeAt.present ? purgeAt.value : this.purgeAt,
    lifecycleRevision: lifecycleRevision ?? this.lifecycleRevision,
    lifecycleUpdatedAt:
        lifecycleUpdatedAt.present
            ? lifecycleUpdatedAt.value
            : this.lifecycleUpdatedAt,
    missedPolicy: missedPolicy ?? this.missedPolicy,
    missedConsequence: missedConsequence ?? this.missedConsequence,
    missedBufferDays: missedBufferDays ?? this.missedBufferDays,
    postBufferBehavior: postBufferBehavior ?? this.postBufferBehavior,
    maxCarryoverCount: maxCarryoverCount ?? this.maxCarryoverCount,
    goalType: goalType ?? this.goalType,
    goalValue: goalValue ?? this.goalValue,
    goalWindowDays:
        goalWindowDays.present ? goalWindowDays.value : this.goalWindowDays,
    goalPeriod: goalPeriod ?? this.goalPeriod,
    goalPeriodAlignment: goalPeriodAlignment ?? this.goalPeriodAlignment,
    valueType: valueType ?? this.valueType,
    valueCommitment: valueCommitment ?? this.valueCommitment,
    valueUnitKey: valueUnitKey ?? this.valueUnitKey,
    valueUnitLabel: valueUnitLabel ?? this.valueUnitLabel,
  );
  Aufgabe copyWithCompanion(AufgabenCompanion data) {
    return Aufgabe(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      beschreibung:
          data.beschreibung.present
              ? data.beschreibung.value
              : this.beschreibung,
      erfassungsmodus:
          data.erfassungsmodus.present
              ? data.erfassungsmodus.value
              : this.erfassungsmodus,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      questionText:
          data.questionText.present
              ? data.questionText.value
              : this.questionText,
      successValue:
          data.successValue.present
              ? data.successValue.value
              : this.successValue,
      activeWeekdays:
          data.activeWeekdays.present
              ? data.activeWeekdays.value
              : this.activeWeekdays,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      purgeAt: data.purgeAt.present ? data.purgeAt.value : this.purgeAt,
      lifecycleRevision:
          data.lifecycleRevision.present
              ? data.lifecycleRevision.value
              : this.lifecycleRevision,
      lifecycleUpdatedAt:
          data.lifecycleUpdatedAt.present
              ? data.lifecycleUpdatedAt.value
              : this.lifecycleUpdatedAt,
      missedPolicy:
          data.missedPolicy.present
              ? data.missedPolicy.value
              : this.missedPolicy,
      missedConsequence:
          data.missedConsequence.present
              ? data.missedConsequence.value
              : this.missedConsequence,
      missedBufferDays:
          data.missedBufferDays.present
              ? data.missedBufferDays.value
              : this.missedBufferDays,
      postBufferBehavior:
          data.postBufferBehavior.present
              ? data.postBufferBehavior.value
              : this.postBufferBehavior,
      maxCarryoverCount:
          data.maxCarryoverCount.present
              ? data.maxCarryoverCount.value
              : this.maxCarryoverCount,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      goalValue: data.goalValue.present ? data.goalValue.value : this.goalValue,
      goalWindowDays:
          data.goalWindowDays.present
              ? data.goalWindowDays.value
              : this.goalWindowDays,
      goalPeriod:
          data.goalPeriod.present ? data.goalPeriod.value : this.goalPeriod,
      goalPeriodAlignment:
          data.goalPeriodAlignment.present
              ? data.goalPeriodAlignment.value
              : this.goalPeriodAlignment,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      valueCommitment:
          data.valueCommitment.present
              ? data.valueCommitment.value
              : this.valueCommitment,
      valueUnitKey:
          data.valueUnitKey.present
              ? data.valueUnitKey.value
              : this.valueUnitKey,
      valueUnitLabel:
          data.valueUnitLabel.present
              ? data.valueUnitLabel.value
              : this.valueUnitLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Aufgabe(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('beschreibung: $beschreibung, ')
          ..write('erfassungsmodus: $erfassungsmodus, ')
          ..write('taskType: $taskType, ')
          ..write('questionText: $questionText, ')
          ..write('successValue: $successValue, ')
          ..write('activeWeekdays: $activeWeekdays, ')
          ..write('recurrence: $recurrence, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('endDate: $endDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('isActive: $isActive, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('purgeAt: $purgeAt, ')
          ..write('lifecycleRevision: $lifecycleRevision, ')
          ..write('lifecycleUpdatedAt: $lifecycleUpdatedAt, ')
          ..write('missedPolicy: $missedPolicy, ')
          ..write('missedConsequence: $missedConsequence, ')
          ..write('missedBufferDays: $missedBufferDays, ')
          ..write('postBufferBehavior: $postBufferBehavior, ')
          ..write('maxCarryoverCount: $maxCarryoverCount, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('goalWindowDays: $goalWindowDays, ')
          ..write('goalPeriod: $goalPeriod, ')
          ..write('goalPeriodAlignment: $goalPeriodAlignment, ')
          ..write('valueType: $valueType, ')
          ..write('valueCommitment: $valueCommitment, ')
          ..write('valueUnitKey: $valueUnitKey, ')
          ..write('valueUnitLabel: $valueUnitLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    projectId,
    name,
    beschreibung,
    erfassungsmodus,
    taskType,
    questionText,
    successValue,
    activeWeekdays,
    recurrence,
    startDate,
    createdAt,
    updatedAt,
    endDate,
    dueDate,
    isActive,
    trashedAt,
    purgeAt,
    lifecycleRevision,
    lifecycleUpdatedAt,
    missedPolicy,
    missedConsequence,
    missedBufferDays,
    postBufferBehavior,
    maxCarryoverCount,
    goalType,
    goalValue,
    goalWindowDays,
    goalPeriod,
    goalPeriodAlignment,
    valueType,
    valueCommitment,
    valueUnitKey,
    valueUnitLabel,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Aufgabe &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.beschreibung == this.beschreibung &&
          other.erfassungsmodus == this.erfassungsmodus &&
          other.taskType == this.taskType &&
          other.questionText == this.questionText &&
          other.successValue == this.successValue &&
          other.activeWeekdays == this.activeWeekdays &&
          other.recurrence == this.recurrence &&
          other.startDate == this.startDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.endDate == this.endDate &&
          other.dueDate == this.dueDate &&
          other.isActive == this.isActive &&
          other.trashedAt == this.trashedAt &&
          other.purgeAt == this.purgeAt &&
          other.lifecycleRevision == this.lifecycleRevision &&
          other.lifecycleUpdatedAt == this.lifecycleUpdatedAt &&
          other.missedPolicy == this.missedPolicy &&
          other.missedConsequence == this.missedConsequence &&
          other.missedBufferDays == this.missedBufferDays &&
          other.postBufferBehavior == this.postBufferBehavior &&
          other.maxCarryoverCount == this.maxCarryoverCount &&
          other.goalType == this.goalType &&
          other.goalValue == this.goalValue &&
          other.goalWindowDays == this.goalWindowDays &&
          other.goalPeriod == this.goalPeriod &&
          other.goalPeriodAlignment == this.goalPeriodAlignment &&
          other.valueType == this.valueType &&
          other.valueCommitment == this.valueCommitment &&
          other.valueUnitKey == this.valueUnitKey &&
          other.valueUnitLabel == this.valueUnitLabel);
}

class AufgabenCompanion extends UpdateCompanion<Aufgabe> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> name;
  final Value<String> beschreibung;
  final Value<String> erfassungsmodus;
  final Value<String> taskType;
  final Value<String> questionText;
  final Value<bool> successValue;
  final Value<String> activeWeekdays;
  final Value<String> recurrence;
  final Value<DateTime> startDate;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> endDate;
  final Value<DateTime?> dueDate;
  final Value<bool> isActive;
  final Value<DateTime?> trashedAt;
  final Value<DateTime?> purgeAt;
  final Value<int> lifecycleRevision;
  final Value<DateTime?> lifecycleUpdatedAt;
  final Value<String> missedPolicy;
  final Value<String> missedConsequence;
  final Value<int> missedBufferDays;
  final Value<String> postBufferBehavior;
  final Value<int> maxCarryoverCount;
  final Value<String> goalType;
  final Value<int> goalValue;
  final Value<int?> goalWindowDays;
  final Value<String> goalPeriod;
  final Value<String> goalPeriodAlignment;
  final Value<String> valueType;
  final Value<String> valueCommitment;
  final Value<String> valueUnitKey;
  final Value<String> valueUnitLabel;
  final Value<int> rowid;
  const AufgabenCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.beschreibung = const Value.absent(),
    this.erfassungsmodus = const Value.absent(),
    this.taskType = const Value.absent(),
    this.questionText = const Value.absent(),
    this.successValue = const Value.absent(),
    this.activeWeekdays = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.endDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.purgeAt = const Value.absent(),
    this.lifecycleRevision = const Value.absent(),
    this.lifecycleUpdatedAt = const Value.absent(),
    this.missedPolicy = const Value.absent(),
    this.missedConsequence = const Value.absent(),
    this.missedBufferDays = const Value.absent(),
    this.postBufferBehavior = const Value.absent(),
    this.maxCarryoverCount = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.goalWindowDays = const Value.absent(),
    this.goalPeriod = const Value.absent(),
    this.goalPeriodAlignment = const Value.absent(),
    this.valueType = const Value.absent(),
    this.valueCommitment = const Value.absent(),
    this.valueUnitKey = const Value.absent(),
    this.valueUnitLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AufgabenCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String name,
    this.beschreibung = const Value.absent(),
    required String erfassungsmodus,
    this.taskType = const Value.absent(),
    this.questionText = const Value.absent(),
    this.successValue = const Value.absent(),
    this.activeWeekdays = const Value.absent(),
    this.recurrence = const Value.absent(),
    required DateTime startDate,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.endDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.purgeAt = const Value.absent(),
    this.lifecycleRevision = const Value.absent(),
    this.lifecycleUpdatedAt = const Value.absent(),
    this.missedPolicy = const Value.absent(),
    this.missedConsequence = const Value.absent(),
    this.missedBufferDays = const Value.absent(),
    this.postBufferBehavior = const Value.absent(),
    this.maxCarryoverCount = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.goalWindowDays = const Value.absent(),
    this.goalPeriod = const Value.absent(),
    this.goalPeriodAlignment = const Value.absent(),
    this.valueType = const Value.absent(),
    this.valueCommitment = const Value.absent(),
    this.valueUnitKey = const Value.absent(),
    this.valueUnitLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       erfassungsmodus = Value(erfassungsmodus),
       startDate = Value(startDate);
  static Insertable<Aufgabe> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? beschreibung,
    Expression<String>? erfassungsmodus,
    Expression<String>? taskType,
    Expression<String>? questionText,
    Expression<bool>? successValue,
    Expression<String>? activeWeekdays,
    Expression<String>? recurrence,
    Expression<DateTime>? startDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? endDate,
    Expression<DateTime>? dueDate,
    Expression<bool>? isActive,
    Expression<DateTime>? trashedAt,
    Expression<DateTime>? purgeAt,
    Expression<int>? lifecycleRevision,
    Expression<DateTime>? lifecycleUpdatedAt,
    Expression<String>? missedPolicy,
    Expression<String>? missedConsequence,
    Expression<int>? missedBufferDays,
    Expression<String>? postBufferBehavior,
    Expression<int>? maxCarryoverCount,
    Expression<String>? goalType,
    Expression<int>? goalValue,
    Expression<int>? goalWindowDays,
    Expression<String>? goalPeriod,
    Expression<String>? goalPeriodAlignment,
    Expression<String>? valueType,
    Expression<String>? valueCommitment,
    Expression<String>? valueUnitKey,
    Expression<String>? valueUnitLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (beschreibung != null) 'beschreibung': beschreibung,
      if (erfassungsmodus != null) 'erfassungsmodus': erfassungsmodus,
      if (taskType != null) 'task_type': taskType,
      if (questionText != null) 'question_text': questionText,
      if (successValue != null) 'success_value': successValue,
      if (activeWeekdays != null) 'active_weekdays': activeWeekdays,
      if (recurrence != null) 'recurrence': recurrence,
      if (startDate != null) 'start_date': startDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (endDate != null) 'end_date': endDate,
      if (dueDate != null) 'due_date': dueDate,
      if (isActive != null) 'is_active': isActive,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (purgeAt != null) 'purge_at': purgeAt,
      if (lifecycleRevision != null) 'lifecycle_revision': lifecycleRevision,
      if (lifecycleUpdatedAt != null)
        'lifecycle_updated_at': lifecycleUpdatedAt,
      if (missedPolicy != null) 'missed_policy': missedPolicy,
      if (missedConsequence != null) 'missed_consequence': missedConsequence,
      if (missedBufferDays != null) 'missed_buffer_days': missedBufferDays,
      if (postBufferBehavior != null)
        'post_buffer_behavior': postBufferBehavior,
      if (maxCarryoverCount != null) 'max_carryover_count': maxCarryoverCount,
      if (goalType != null) 'goal_type': goalType,
      if (goalValue != null) 'goal_value': goalValue,
      if (goalWindowDays != null) 'goal_window_days': goalWindowDays,
      if (goalPeriod != null) 'goal_period': goalPeriod,
      if (goalPeriodAlignment != null)
        'goal_period_alignment': goalPeriodAlignment,
      if (valueType != null) 'value_type': valueType,
      if (valueCommitment != null) 'value_commitment': valueCommitment,
      if (valueUnitKey != null) 'value_unit_key': valueUnitKey,
      if (valueUnitLabel != null) 'value_unit_label': valueUnitLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AufgabenCompanion copyWith({
    Value<String>? id,
    Value<String?>? projectId,
    Value<String>? name,
    Value<String>? beschreibung,
    Value<String>? erfassungsmodus,
    Value<String>? taskType,
    Value<String>? questionText,
    Value<bool>? successValue,
    Value<String>? activeWeekdays,
    Value<String>? recurrence,
    Value<DateTime>? startDate,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? endDate,
    Value<DateTime?>? dueDate,
    Value<bool>? isActive,
    Value<DateTime?>? trashedAt,
    Value<DateTime?>? purgeAt,
    Value<int>? lifecycleRevision,
    Value<DateTime?>? lifecycleUpdatedAt,
    Value<String>? missedPolicy,
    Value<String>? missedConsequence,
    Value<int>? missedBufferDays,
    Value<String>? postBufferBehavior,
    Value<int>? maxCarryoverCount,
    Value<String>? goalType,
    Value<int>? goalValue,
    Value<int?>? goalWindowDays,
    Value<String>? goalPeriod,
    Value<String>? goalPeriodAlignment,
    Value<String>? valueType,
    Value<String>? valueCommitment,
    Value<String>? valueUnitKey,
    Value<String>? valueUnitLabel,
    Value<int>? rowid,
  }) {
    return AufgabenCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      beschreibung: beschreibung ?? this.beschreibung,
      erfassungsmodus: erfassungsmodus ?? this.erfassungsmodus,
      taskType: taskType ?? this.taskType,
      questionText: questionText ?? this.questionText,
      successValue: successValue ?? this.successValue,
      activeWeekdays: activeWeekdays ?? this.activeWeekdays,
      recurrence: recurrence ?? this.recurrence,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      endDate: endDate ?? this.endDate,
      dueDate: dueDate ?? this.dueDate,
      isActive: isActive ?? this.isActive,
      trashedAt: trashedAt ?? this.trashedAt,
      purgeAt: purgeAt ?? this.purgeAt,
      lifecycleRevision: lifecycleRevision ?? this.lifecycleRevision,
      lifecycleUpdatedAt: lifecycleUpdatedAt ?? this.lifecycleUpdatedAt,
      missedPolicy: missedPolicy ?? this.missedPolicy,
      missedConsequence: missedConsequence ?? this.missedConsequence,
      missedBufferDays: missedBufferDays ?? this.missedBufferDays,
      postBufferBehavior: postBufferBehavior ?? this.postBufferBehavior,
      maxCarryoverCount: maxCarryoverCount ?? this.maxCarryoverCount,
      goalType: goalType ?? this.goalType,
      goalValue: goalValue ?? this.goalValue,
      goalWindowDays: goalWindowDays ?? this.goalWindowDays,
      goalPeriod: goalPeriod ?? this.goalPeriod,
      goalPeriodAlignment: goalPeriodAlignment ?? this.goalPeriodAlignment,
      valueType: valueType ?? this.valueType,
      valueCommitment: valueCommitment ?? this.valueCommitment,
      valueUnitKey: valueUnitKey ?? this.valueUnitKey,
      valueUnitLabel: valueUnitLabel ?? this.valueUnitLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (beschreibung.present) {
      map['beschreibung'] = Variable<String>(beschreibung.value);
    }
    if (erfassungsmodus.present) {
      map['erfassungsmodus'] = Variable<String>(erfassungsmodus.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (successValue.present) {
      map['success_value'] = Variable<bool>(successValue.value);
    }
    if (activeWeekdays.present) {
      map['active_weekdays'] = Variable<String>(activeWeekdays.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<DateTime>(trashedAt.value);
    }
    if (purgeAt.present) {
      map['purge_at'] = Variable<DateTime>(purgeAt.value);
    }
    if (lifecycleRevision.present) {
      map['lifecycle_revision'] = Variable<int>(lifecycleRevision.value);
    }
    if (lifecycleUpdatedAt.present) {
      map['lifecycle_updated_at'] = Variable<DateTime>(
        lifecycleUpdatedAt.value,
      );
    }
    if (missedPolicy.present) {
      map['missed_policy'] = Variable<String>(missedPolicy.value);
    }
    if (missedConsequence.present) {
      map['missed_consequence'] = Variable<String>(missedConsequence.value);
    }
    if (missedBufferDays.present) {
      map['missed_buffer_days'] = Variable<int>(missedBufferDays.value);
    }
    if (postBufferBehavior.present) {
      map['post_buffer_behavior'] = Variable<String>(postBufferBehavior.value);
    }
    if (maxCarryoverCount.present) {
      map['max_carryover_count'] = Variable<int>(maxCarryoverCount.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (goalValue.present) {
      map['goal_value'] = Variable<int>(goalValue.value);
    }
    if (goalWindowDays.present) {
      map['goal_window_days'] = Variable<int>(goalWindowDays.value);
    }
    if (goalPeriod.present) {
      map['goal_period'] = Variable<String>(goalPeriod.value);
    }
    if (goalPeriodAlignment.present) {
      map['goal_period_alignment'] = Variable<String>(
        goalPeriodAlignment.value,
      );
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (valueCommitment.present) {
      map['value_commitment'] = Variable<String>(valueCommitment.value);
    }
    if (valueUnitKey.present) {
      map['value_unit_key'] = Variable<String>(valueUnitKey.value);
    }
    if (valueUnitLabel.present) {
      map['value_unit_label'] = Variable<String>(valueUnitLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AufgabenCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('beschreibung: $beschreibung, ')
          ..write('erfassungsmodus: $erfassungsmodus, ')
          ..write('taskType: $taskType, ')
          ..write('questionText: $questionText, ')
          ..write('successValue: $successValue, ')
          ..write('activeWeekdays: $activeWeekdays, ')
          ..write('recurrence: $recurrence, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('endDate: $endDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('isActive: $isActive, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('purgeAt: $purgeAt, ')
          ..write('lifecycleRevision: $lifecycleRevision, ')
          ..write('lifecycleUpdatedAt: $lifecycleUpdatedAt, ')
          ..write('missedPolicy: $missedPolicy, ')
          ..write('missedConsequence: $missedConsequence, ')
          ..write('missedBufferDays: $missedBufferDays, ')
          ..write('postBufferBehavior: $postBufferBehavior, ')
          ..write('maxCarryoverCount: $maxCarryoverCount, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('goalWindowDays: $goalWindowDays, ')
          ..write('goalPeriod: $goalPeriod, ')
          ..write('goalPeriodAlignment: $goalPeriodAlignment, ')
          ..write('valueType: $valueType, ')
          ..write('valueCommitment: $valueCommitment, ')
          ..write('valueUnitKey: $valueUnitKey, ')
          ..write('valueUnitLabel: $valueUnitLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskDefinitionVersionsTable extends TaskDefinitionVersions
    with TableInfo<$TaskDefinitionVersionsTable, TaskDefinitionVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskDefinitionVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _versionNumberMeta = const VerificationMeta(
    'versionNumber',
  );
  @override
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>(
    'version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousVersionIdMeta = const VerificationMeta(
    'previousVersionId',
  );
  @override
  late final GeneratedColumn<String> previousVersionId =
      GeneratedColumn<String>(
        'previous_version_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supersededAtMeta = const VerificationMeta(
    'supersededAt',
  );
  @override
  late final GeneratedColumn<DateTime> supersededAt = GeneratedColumn<DateTime>(
    'superseded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taskTypeMeta = const VerificationMeta(
    'taskType',
  );
  @override
  late final GeneratedColumn<String> taskType = GeneratedColumn<String>(
    'task_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captureModeMeta = const VerificationMeta(
    'captureMode',
  );
  @override
  late final GeneratedColumn<String> captureMode = GeneratedColumn<String>(
    'capture_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successValueMeta = const VerificationMeta(
    'successValue',
  );
  @override
  late final GeneratedColumn<bool> successValue = GeneratedColumn<bool>(
    'success_value',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success_value" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _activeWeekdaysMeta = const VerificationMeta(
    'activeWeekdays',
  );
  @override
  late final GeneratedColumn<String> activeWeekdays = GeneratedColumn<String>(
    'active_weekdays',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _missedPolicyMeta = const VerificationMeta(
    'missedPolicy',
  );
  @override
  late final GeneratedColumn<String> missedPolicy = GeneratedColumn<String>(
    'missed_policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(MissedPolicy.none),
  );
  static const VerificationMeta _missedConsequenceMeta = const VerificationMeta(
    'missedConsequence',
  );
  @override
  late final GeneratedColumn<String> missedConsequence =
      GeneratedColumn<String>(
        'missed_consequence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(MissedConsequence.markAsNotDone),
      );
  static const VerificationMeta _missedBufferDaysMeta = const VerificationMeta(
    'missedBufferDays',
  );
  @override
  late final GeneratedColumn<int> missedBufferDays = GeneratedColumn<int>(
    'missed_buffer_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _postBufferBehaviorMeta =
      const VerificationMeta('postBufferBehavior');
  @override
  late final GeneratedColumn<String> postBufferBehavior =
      GeneratedColumn<String>(
        'post_buffer_behavior',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(PostBufferBehavior.markAsFailure),
      );
  static const VerificationMeta _maxCarryoverCountMeta = const VerificationMeta(
    'maxCarryoverCount',
  );
  @override
  late final GeneratedColumn<int> maxCarryoverCount = GeneratedColumn<int>(
    'max_carryover_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskGoalType.none),
  );
  static const VerificationMeta _goalValueMeta = const VerificationMeta(
    'goalValue',
  );
  @override
  late final GeneratedColumn<int> goalValue = GeneratedColumn<int>(
    'goal_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _goalWindowDaysMeta = const VerificationMeta(
    'goalWindowDays',
  );
  @override
  late final GeneratedColumn<int> goalWindowDays = GeneratedColumn<int>(
    'goal_window_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalPeriodMeta = const VerificationMeta(
    'goalPeriod',
  );
  @override
  late final GeneratedColumn<String> goalPeriod = GeneratedColumn<String>(
    'goal_period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(GoalPeriod.week),
  );
  static const VerificationMeta _goalPeriodAlignmentMeta =
      const VerificationMeta('goalPeriodAlignment');
  @override
  late final GeneratedColumn<String> goalPeriodAlignment =
      GeneratedColumn<String>(
        'goal_period_alignment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(GoalPeriodAlignment.calendar),
      );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _valueCommitmentMeta = const VerificationMeta(
    'valueCommitment',
  );
  @override
  late final GeneratedColumn<String> valueCommitment = GeneratedColumn<String>(
    'value_commitment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _valueUnitKeyMeta = const VerificationMeta(
    'valueUnitKey',
  );
  @override
  late final GeneratedColumn<String> valueUnitKey = GeneratedColumn<String>(
    'value_unit_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _valueUnitLabelMeta = const VerificationMeta(
    'valueUnitLabel',
  );
  @override
  late final GeneratedColumn<String> valueUnitLabel = GeneratedColumn<String>(
    'value_unit_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    versionNumber,
    previousVersionId,
    validFrom,
    createdAt,
    supersededAt,
    name,
    description,
    questionText,
    projectId,
    taskType,
    captureMode,
    successValue,
    activeWeekdays,
    recurrence,
    startDate,
    endDate,
    dueDate,
    missedPolicy,
    missedConsequence,
    missedBufferDays,
    postBufferBehavior,
    maxCarryoverCount,
    goalType,
    goalValue,
    goalWindowDays,
    goalPeriod,
    goalPeriodAlignment,
    valueType,
    valueCommitment,
    valueUnitKey,
    valueUnitLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_definition_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskDefinitionVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('version_number')) {
      context.handle(
        _versionNumberMeta,
        versionNumber.isAcceptableOrUnknown(
          data['version_number']!,
          _versionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionNumberMeta);
    }
    if (data.containsKey('previous_version_id')) {
      context.handle(
        _previousVersionIdMeta,
        previousVersionId.isAcceptableOrUnknown(
          data['previous_version_id']!,
          _previousVersionIdMeta,
        ),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('superseded_at')) {
      context.handle(
        _supersededAtMeta,
        supersededAt.isAcceptableOrUnknown(
          data['superseded_at']!,
          _supersededAtMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
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
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('task_type')) {
      context.handle(
        _taskTypeMeta,
        taskType.isAcceptableOrUnknown(data['task_type']!, _taskTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_taskTypeMeta);
    }
    if (data.containsKey('capture_mode')) {
      context.handle(
        _captureModeMeta,
        captureMode.isAcceptableOrUnknown(
          data['capture_mode']!,
          _captureModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_captureModeMeta);
    }
    if (data.containsKey('success_value')) {
      context.handle(
        _successValueMeta,
        successValue.isAcceptableOrUnknown(
          data['success_value']!,
          _successValueMeta,
        ),
      );
    }
    if (data.containsKey('active_weekdays')) {
      context.handle(
        _activeWeekdaysMeta,
        activeWeekdays.isAcceptableOrUnknown(
          data['active_weekdays']!,
          _activeWeekdaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeWeekdaysMeta);
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    } else if (isInserting) {
      context.missing(_recurrenceMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('missed_policy')) {
      context.handle(
        _missedPolicyMeta,
        missedPolicy.isAcceptableOrUnknown(
          data['missed_policy']!,
          _missedPolicyMeta,
        ),
      );
    }
    if (data.containsKey('missed_consequence')) {
      context.handle(
        _missedConsequenceMeta,
        missedConsequence.isAcceptableOrUnknown(
          data['missed_consequence']!,
          _missedConsequenceMeta,
        ),
      );
    }
    if (data.containsKey('missed_buffer_days')) {
      context.handle(
        _missedBufferDaysMeta,
        missedBufferDays.isAcceptableOrUnknown(
          data['missed_buffer_days']!,
          _missedBufferDaysMeta,
        ),
      );
    }
    if (data.containsKey('post_buffer_behavior')) {
      context.handle(
        _postBufferBehaviorMeta,
        postBufferBehavior.isAcceptableOrUnknown(
          data['post_buffer_behavior']!,
          _postBufferBehaviorMeta,
        ),
      );
    }
    if (data.containsKey('max_carryover_count')) {
      context.handle(
        _maxCarryoverCountMeta,
        maxCarryoverCount.isAcceptableOrUnknown(
          data['max_carryover_count']!,
          _maxCarryoverCountMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('goal_value')) {
      context.handle(
        _goalValueMeta,
        goalValue.isAcceptableOrUnknown(data['goal_value']!, _goalValueMeta),
      );
    }
    if (data.containsKey('goal_window_days')) {
      context.handle(
        _goalWindowDaysMeta,
        goalWindowDays.isAcceptableOrUnknown(
          data['goal_window_days']!,
          _goalWindowDaysMeta,
        ),
      );
    }
    if (data.containsKey('goal_period')) {
      context.handle(
        _goalPeriodMeta,
        goalPeriod.isAcceptableOrUnknown(data['goal_period']!, _goalPeriodMeta),
      );
    }
    if (data.containsKey('goal_period_alignment')) {
      context.handle(
        _goalPeriodAlignmentMeta,
        goalPeriodAlignment.isAcceptableOrUnknown(
          data['goal_period_alignment']!,
          _goalPeriodAlignmentMeta,
        ),
      );
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    }
    if (data.containsKey('value_commitment')) {
      context.handle(
        _valueCommitmentMeta,
        valueCommitment.isAcceptableOrUnknown(
          data['value_commitment']!,
          _valueCommitmentMeta,
        ),
      );
    }
    if (data.containsKey('value_unit_key')) {
      context.handle(
        _valueUnitKeyMeta,
        valueUnitKey.isAcceptableOrUnknown(
          data['value_unit_key']!,
          _valueUnitKeyMeta,
        ),
      );
    }
    if (data.containsKey('value_unit_label')) {
      context.handle(
        _valueUnitLabelMeta,
        valueUnitLabel.isAcceptableOrUnknown(
          data['value_unit_label']!,
          _valueUnitLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {taskId, versionNumber},
  ];
  @override
  TaskDefinitionVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskDefinitionVersion(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_id'],
          )!,
      versionNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}version_number'],
          )!,
      previousVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_version_id'],
      ),
      validFrom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}valid_from'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      supersededAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}superseded_at'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      questionText:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}question_text'],
          )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      taskType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_type'],
          )!,
      captureMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}capture_mode'],
          )!,
      successValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}success_value'],
          )!,
      activeWeekdays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}active_weekdays'],
          )!,
      recurrence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}recurrence'],
          )!,
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      missedPolicy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}missed_policy'],
          )!,
      missedConsequence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}missed_consequence'],
          )!,
      missedBufferDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}missed_buffer_days'],
          )!,
      postBufferBehavior:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}post_buffer_behavior'],
          )!,
      maxCarryoverCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}max_carryover_count'],
          )!,
      goalType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_type'],
          )!,
      goalValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}goal_value'],
          )!,
      goalWindowDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_window_days'],
      ),
      goalPeriod:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_period'],
          )!,
      goalPeriodAlignment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_period_alignment'],
          )!,
      valueType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_type'],
          )!,
      valueCommitment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_commitment'],
          )!,
      valueUnitKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_unit_key'],
          )!,
      valueUnitLabel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_unit_label'],
          )!,
    );
  }

  @override
  $TaskDefinitionVersionsTable createAlias(String alias) {
    return $TaskDefinitionVersionsTable(attachedDatabase, alias);
  }
}

class TaskDefinitionVersion extends DataClass
    implements Insertable<TaskDefinitionVersion> {
  final String id;
  final String taskId;
  final int versionNumber;
  final String? previousVersionId;
  final DateTime validFrom;
  final DateTime createdAt;
  final DateTime? supersededAt;
  final String name;
  final String description;
  final String questionText;
  final String? projectId;
  final String taskType;
  final String captureMode;
  final bool successValue;
  final String activeWeekdays;
  final String recurrence;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? dueDate;
  final String missedPolicy;
  final String missedConsequence;
  final int missedBufferDays;
  final String postBufferBehavior;
  final int maxCarryoverCount;
  final String goalType;
  final int goalValue;
  final int? goalWindowDays;
  final String goalPeriod;
  final String goalPeriodAlignment;
  final String valueType;
  final String valueCommitment;
  final String valueUnitKey;
  final String valueUnitLabel;
  const TaskDefinitionVersion({
    required this.id,
    required this.taskId,
    required this.versionNumber,
    this.previousVersionId,
    required this.validFrom,
    required this.createdAt,
    this.supersededAt,
    required this.name,
    required this.description,
    required this.questionText,
    this.projectId,
    required this.taskType,
    required this.captureMode,
    required this.successValue,
    required this.activeWeekdays,
    required this.recurrence,
    required this.startDate,
    this.endDate,
    this.dueDate,
    required this.missedPolicy,
    required this.missedConsequence,
    required this.missedBufferDays,
    required this.postBufferBehavior,
    required this.maxCarryoverCount,
    required this.goalType,
    required this.goalValue,
    this.goalWindowDays,
    required this.goalPeriod,
    required this.goalPeriodAlignment,
    required this.valueType,
    required this.valueCommitment,
    required this.valueUnitKey,
    required this.valueUnitLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['version_number'] = Variable<int>(versionNumber);
    if (!nullToAbsent || previousVersionId != null) {
      map['previous_version_id'] = Variable<String>(previousVersionId);
    }
    map['valid_from'] = Variable<DateTime>(validFrom);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || supersededAt != null) {
      map['superseded_at'] = Variable<DateTime>(supersededAt);
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['question_text'] = Variable<String>(questionText);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['task_type'] = Variable<String>(taskType);
    map['capture_mode'] = Variable<String>(captureMode);
    map['success_value'] = Variable<bool>(successValue);
    map['active_weekdays'] = Variable<String>(activeWeekdays);
    map['recurrence'] = Variable<String>(recurrence);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['missed_policy'] = Variable<String>(missedPolicy);
    map['missed_consequence'] = Variable<String>(missedConsequence);
    map['missed_buffer_days'] = Variable<int>(missedBufferDays);
    map['post_buffer_behavior'] = Variable<String>(postBufferBehavior);
    map['max_carryover_count'] = Variable<int>(maxCarryoverCount);
    map['goal_type'] = Variable<String>(goalType);
    map['goal_value'] = Variable<int>(goalValue);
    if (!nullToAbsent || goalWindowDays != null) {
      map['goal_window_days'] = Variable<int>(goalWindowDays);
    }
    map['goal_period'] = Variable<String>(goalPeriod);
    map['goal_period_alignment'] = Variable<String>(goalPeriodAlignment);
    map['value_type'] = Variable<String>(valueType);
    map['value_commitment'] = Variable<String>(valueCommitment);
    map['value_unit_key'] = Variable<String>(valueUnitKey);
    map['value_unit_label'] = Variable<String>(valueUnitLabel);
    return map;
  }

  TaskDefinitionVersionsCompanion toCompanion(bool nullToAbsent) {
    return TaskDefinitionVersionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      versionNumber: Value(versionNumber),
      previousVersionId:
          previousVersionId == null && nullToAbsent
              ? const Value.absent()
              : Value(previousVersionId),
      validFrom: Value(validFrom),
      createdAt: Value(createdAt),
      supersededAt:
          supersededAt == null && nullToAbsent
              ? const Value.absent()
              : Value(supersededAt),
      name: Value(name),
      description: Value(description),
      questionText: Value(questionText),
      projectId:
          projectId == null && nullToAbsent
              ? const Value.absent()
              : Value(projectId),
      taskType: Value(taskType),
      captureMode: Value(captureMode),
      successValue: Value(successValue),
      activeWeekdays: Value(activeWeekdays),
      recurrence: Value(recurrence),
      startDate: Value(startDate),
      endDate:
          endDate == null && nullToAbsent
              ? const Value.absent()
              : Value(endDate),
      dueDate:
          dueDate == null && nullToAbsent
              ? const Value.absent()
              : Value(dueDate),
      missedPolicy: Value(missedPolicy),
      missedConsequence: Value(missedConsequence),
      missedBufferDays: Value(missedBufferDays),
      postBufferBehavior: Value(postBufferBehavior),
      maxCarryoverCount: Value(maxCarryoverCount),
      goalType: Value(goalType),
      goalValue: Value(goalValue),
      goalWindowDays:
          goalWindowDays == null && nullToAbsent
              ? const Value.absent()
              : Value(goalWindowDays),
      goalPeriod: Value(goalPeriod),
      goalPeriodAlignment: Value(goalPeriodAlignment),
      valueType: Value(valueType),
      valueCommitment: Value(valueCommitment),
      valueUnitKey: Value(valueUnitKey),
      valueUnitLabel: Value(valueUnitLabel),
    );
  }

  factory TaskDefinitionVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskDefinitionVersion(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      previousVersionId: serializer.fromJson<String?>(
        json['previousVersionId'],
      ),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      supersededAt: serializer.fromJson<DateTime?>(json['supersededAt']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      questionText: serializer.fromJson<String>(json['questionText']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      taskType: serializer.fromJson<String>(json['taskType']),
      captureMode: serializer.fromJson<String>(json['captureMode']),
      successValue: serializer.fromJson<bool>(json['successValue']),
      activeWeekdays: serializer.fromJson<String>(json['activeWeekdays']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      missedPolicy: serializer.fromJson<String>(json['missedPolicy']),
      missedConsequence: serializer.fromJson<String>(json['missedConsequence']),
      missedBufferDays: serializer.fromJson<int>(json['missedBufferDays']),
      postBufferBehavior: serializer.fromJson<String>(
        json['postBufferBehavior'],
      ),
      maxCarryoverCount: serializer.fromJson<int>(json['maxCarryoverCount']),
      goalType: serializer.fromJson<String>(json['goalType']),
      goalValue: serializer.fromJson<int>(json['goalValue']),
      goalWindowDays: serializer.fromJson<int?>(json['goalWindowDays']),
      goalPeriod: serializer.fromJson<String>(json['goalPeriod']),
      goalPeriodAlignment: serializer.fromJson<String>(
        json['goalPeriodAlignment'],
      ),
      valueType: serializer.fromJson<String>(json['valueType']),
      valueCommitment: serializer.fromJson<String>(json['valueCommitment']),
      valueUnitKey: serializer.fromJson<String>(json['valueUnitKey']),
      valueUnitLabel: serializer.fromJson<String>(json['valueUnitLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'previousVersionId': serializer.toJson<String?>(previousVersionId),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'supersededAt': serializer.toJson<DateTime?>(supersededAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'questionText': serializer.toJson<String>(questionText),
      'projectId': serializer.toJson<String?>(projectId),
      'taskType': serializer.toJson<String>(taskType),
      'captureMode': serializer.toJson<String>(captureMode),
      'successValue': serializer.toJson<bool>(successValue),
      'activeWeekdays': serializer.toJson<String>(activeWeekdays),
      'recurrence': serializer.toJson<String>(recurrence),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'missedPolicy': serializer.toJson<String>(missedPolicy),
      'missedConsequence': serializer.toJson<String>(missedConsequence),
      'missedBufferDays': serializer.toJson<int>(missedBufferDays),
      'postBufferBehavior': serializer.toJson<String>(postBufferBehavior),
      'maxCarryoverCount': serializer.toJson<int>(maxCarryoverCount),
      'goalType': serializer.toJson<String>(goalType),
      'goalValue': serializer.toJson<int>(goalValue),
      'goalWindowDays': serializer.toJson<int?>(goalWindowDays),
      'goalPeriod': serializer.toJson<String>(goalPeriod),
      'goalPeriodAlignment': serializer.toJson<String>(goalPeriodAlignment),
      'valueType': serializer.toJson<String>(valueType),
      'valueCommitment': serializer.toJson<String>(valueCommitment),
      'valueUnitKey': serializer.toJson<String>(valueUnitKey),
      'valueUnitLabel': serializer.toJson<String>(valueUnitLabel),
    };
  }

  TaskDefinitionVersion copyWith({
    String? id,
    String? taskId,
    int? versionNumber,
    Value<String?> previousVersionId = const Value.absent(),
    DateTime? validFrom,
    DateTime? createdAt,
    Value<DateTime?> supersededAt = const Value.absent(),
    String? name,
    String? description,
    String? questionText,
    Value<String?> projectId = const Value.absent(),
    String? taskType,
    String? captureMode,
    bool? successValue,
    String? activeWeekdays,
    String? recurrence,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    String? missedPolicy,
    String? missedConsequence,
    int? missedBufferDays,
    String? postBufferBehavior,
    int? maxCarryoverCount,
    String? goalType,
    int? goalValue,
    Value<int?> goalWindowDays = const Value.absent(),
    String? goalPeriod,
    String? goalPeriodAlignment,
    String? valueType,
    String? valueCommitment,
    String? valueUnitKey,
    String? valueUnitLabel,
  }) => TaskDefinitionVersion(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    versionNumber: versionNumber ?? this.versionNumber,
    previousVersionId:
        previousVersionId.present
            ? previousVersionId.value
            : this.previousVersionId,
    validFrom: validFrom ?? this.validFrom,
    createdAt: createdAt ?? this.createdAt,
    supersededAt: supersededAt.present ? supersededAt.value : this.supersededAt,
    name: name ?? this.name,
    description: description ?? this.description,
    questionText: questionText ?? this.questionText,
    projectId: projectId.present ? projectId.value : this.projectId,
    taskType: taskType ?? this.taskType,
    captureMode: captureMode ?? this.captureMode,
    successValue: successValue ?? this.successValue,
    activeWeekdays: activeWeekdays ?? this.activeWeekdays,
    recurrence: recurrence ?? this.recurrence,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    missedPolicy: missedPolicy ?? this.missedPolicy,
    missedConsequence: missedConsequence ?? this.missedConsequence,
    missedBufferDays: missedBufferDays ?? this.missedBufferDays,
    postBufferBehavior: postBufferBehavior ?? this.postBufferBehavior,
    maxCarryoverCount: maxCarryoverCount ?? this.maxCarryoverCount,
    goalType: goalType ?? this.goalType,
    goalValue: goalValue ?? this.goalValue,
    goalWindowDays:
        goalWindowDays.present ? goalWindowDays.value : this.goalWindowDays,
    goalPeriod: goalPeriod ?? this.goalPeriod,
    goalPeriodAlignment: goalPeriodAlignment ?? this.goalPeriodAlignment,
    valueType: valueType ?? this.valueType,
    valueCommitment: valueCommitment ?? this.valueCommitment,
    valueUnitKey: valueUnitKey ?? this.valueUnitKey,
    valueUnitLabel: valueUnitLabel ?? this.valueUnitLabel,
  );
  TaskDefinitionVersion copyWithCompanion(
    TaskDefinitionVersionsCompanion data,
  ) {
    return TaskDefinitionVersion(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      versionNumber:
          data.versionNumber.present
              ? data.versionNumber.value
              : this.versionNumber,
      previousVersionId:
          data.previousVersionId.present
              ? data.previousVersionId.value
              : this.previousVersionId,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      supersededAt:
          data.supersededAt.present
              ? data.supersededAt.value
              : this.supersededAt,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      questionText:
          data.questionText.present
              ? data.questionText.value
              : this.questionText,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      taskType: data.taskType.present ? data.taskType.value : this.taskType,
      captureMode:
          data.captureMode.present ? data.captureMode.value : this.captureMode,
      successValue:
          data.successValue.present
              ? data.successValue.value
              : this.successValue,
      activeWeekdays:
          data.activeWeekdays.present
              ? data.activeWeekdays.value
              : this.activeWeekdays,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      missedPolicy:
          data.missedPolicy.present
              ? data.missedPolicy.value
              : this.missedPolicy,
      missedConsequence:
          data.missedConsequence.present
              ? data.missedConsequence.value
              : this.missedConsequence,
      missedBufferDays:
          data.missedBufferDays.present
              ? data.missedBufferDays.value
              : this.missedBufferDays,
      postBufferBehavior:
          data.postBufferBehavior.present
              ? data.postBufferBehavior.value
              : this.postBufferBehavior,
      maxCarryoverCount:
          data.maxCarryoverCount.present
              ? data.maxCarryoverCount.value
              : this.maxCarryoverCount,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      goalValue: data.goalValue.present ? data.goalValue.value : this.goalValue,
      goalWindowDays:
          data.goalWindowDays.present
              ? data.goalWindowDays.value
              : this.goalWindowDays,
      goalPeriod:
          data.goalPeriod.present ? data.goalPeriod.value : this.goalPeriod,
      goalPeriodAlignment:
          data.goalPeriodAlignment.present
              ? data.goalPeriodAlignment.value
              : this.goalPeriodAlignment,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      valueCommitment:
          data.valueCommitment.present
              ? data.valueCommitment.value
              : this.valueCommitment,
      valueUnitKey:
          data.valueUnitKey.present
              ? data.valueUnitKey.value
              : this.valueUnitKey,
      valueUnitLabel:
          data.valueUnitLabel.present
              ? data.valueUnitLabel.value
              : this.valueUnitLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskDefinitionVersion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('validFrom: $validFrom, ')
          ..write('createdAt: $createdAt, ')
          ..write('supersededAt: $supersededAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('questionText: $questionText, ')
          ..write('projectId: $projectId, ')
          ..write('taskType: $taskType, ')
          ..write('captureMode: $captureMode, ')
          ..write('successValue: $successValue, ')
          ..write('activeWeekdays: $activeWeekdays, ')
          ..write('recurrence: $recurrence, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('missedPolicy: $missedPolicy, ')
          ..write('missedConsequence: $missedConsequence, ')
          ..write('missedBufferDays: $missedBufferDays, ')
          ..write('postBufferBehavior: $postBufferBehavior, ')
          ..write('maxCarryoverCount: $maxCarryoverCount, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('goalWindowDays: $goalWindowDays, ')
          ..write('goalPeriod: $goalPeriod, ')
          ..write('goalPeriodAlignment: $goalPeriodAlignment, ')
          ..write('valueType: $valueType, ')
          ..write('valueCommitment: $valueCommitment, ')
          ..write('valueUnitKey: $valueUnitKey, ')
          ..write('valueUnitLabel: $valueUnitLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    taskId,
    versionNumber,
    previousVersionId,
    validFrom,
    createdAt,
    supersededAt,
    name,
    description,
    questionText,
    projectId,
    taskType,
    captureMode,
    successValue,
    activeWeekdays,
    recurrence,
    startDate,
    endDate,
    dueDate,
    missedPolicy,
    missedConsequence,
    missedBufferDays,
    postBufferBehavior,
    maxCarryoverCount,
    goalType,
    goalValue,
    goalWindowDays,
    goalPeriod,
    goalPeriodAlignment,
    valueType,
    valueCommitment,
    valueUnitKey,
    valueUnitLabel,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskDefinitionVersion &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.versionNumber == this.versionNumber &&
          other.previousVersionId == this.previousVersionId &&
          other.validFrom == this.validFrom &&
          other.createdAt == this.createdAt &&
          other.supersededAt == this.supersededAt &&
          other.name == this.name &&
          other.description == this.description &&
          other.questionText == this.questionText &&
          other.projectId == this.projectId &&
          other.taskType == this.taskType &&
          other.captureMode == this.captureMode &&
          other.successValue == this.successValue &&
          other.activeWeekdays == this.activeWeekdays &&
          other.recurrence == this.recurrence &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.dueDate == this.dueDate &&
          other.missedPolicy == this.missedPolicy &&
          other.missedConsequence == this.missedConsequence &&
          other.missedBufferDays == this.missedBufferDays &&
          other.postBufferBehavior == this.postBufferBehavior &&
          other.maxCarryoverCount == this.maxCarryoverCount &&
          other.goalType == this.goalType &&
          other.goalValue == this.goalValue &&
          other.goalWindowDays == this.goalWindowDays &&
          other.goalPeriod == this.goalPeriod &&
          other.goalPeriodAlignment == this.goalPeriodAlignment &&
          other.valueType == this.valueType &&
          other.valueCommitment == this.valueCommitment &&
          other.valueUnitKey == this.valueUnitKey &&
          other.valueUnitLabel == this.valueUnitLabel);
}

class TaskDefinitionVersionsCompanion
    extends UpdateCompanion<TaskDefinitionVersion> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<int> versionNumber;
  final Value<String?> previousVersionId;
  final Value<DateTime> validFrom;
  final Value<DateTime> createdAt;
  final Value<DateTime?> supersededAt;
  final Value<String> name;
  final Value<String> description;
  final Value<String> questionText;
  final Value<String?> projectId;
  final Value<String> taskType;
  final Value<String> captureMode;
  final Value<bool> successValue;
  final Value<String> activeWeekdays;
  final Value<String> recurrence;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> dueDate;
  final Value<String> missedPolicy;
  final Value<String> missedConsequence;
  final Value<int> missedBufferDays;
  final Value<String> postBufferBehavior;
  final Value<int> maxCarryoverCount;
  final Value<String> goalType;
  final Value<int> goalValue;
  final Value<int?> goalWindowDays;
  final Value<String> goalPeriod;
  final Value<String> goalPeriodAlignment;
  final Value<String> valueType;
  final Value<String> valueCommitment;
  final Value<String> valueUnitKey;
  final Value<String> valueUnitLabel;
  final Value<int> rowid;
  const TaskDefinitionVersionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.previousVersionId = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.supersededAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.questionText = const Value.absent(),
    this.projectId = const Value.absent(),
    this.taskType = const Value.absent(),
    this.captureMode = const Value.absent(),
    this.successValue = const Value.absent(),
    this.activeWeekdays = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.missedPolicy = const Value.absent(),
    this.missedConsequence = const Value.absent(),
    this.missedBufferDays = const Value.absent(),
    this.postBufferBehavior = const Value.absent(),
    this.maxCarryoverCount = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.goalWindowDays = const Value.absent(),
    this.goalPeriod = const Value.absent(),
    this.goalPeriodAlignment = const Value.absent(),
    this.valueType = const Value.absent(),
    this.valueCommitment = const Value.absent(),
    this.valueUnitKey = const Value.absent(),
    this.valueUnitLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskDefinitionVersionsCompanion.insert({
    required String id,
    required String taskId,
    required int versionNumber,
    this.previousVersionId = const Value.absent(),
    required DateTime validFrom,
    required DateTime createdAt,
    this.supersededAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.questionText = const Value.absent(),
    this.projectId = const Value.absent(),
    required String taskType,
    required String captureMode,
    this.successValue = const Value.absent(),
    required String activeWeekdays,
    required String recurrence,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.missedPolicy = const Value.absent(),
    this.missedConsequence = const Value.absent(),
    this.missedBufferDays = const Value.absent(),
    this.postBufferBehavior = const Value.absent(),
    this.maxCarryoverCount = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.goalWindowDays = const Value.absent(),
    this.goalPeriod = const Value.absent(),
    this.goalPeriodAlignment = const Value.absent(),
    this.valueType = const Value.absent(),
    this.valueCommitment = const Value.absent(),
    this.valueUnitKey = const Value.absent(),
    this.valueUnitLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       versionNumber = Value(versionNumber),
       validFrom = Value(validFrom),
       createdAt = Value(createdAt),
       taskType = Value(taskType),
       captureMode = Value(captureMode),
       activeWeekdays = Value(activeWeekdays),
       recurrence = Value(recurrence),
       startDate = Value(startDate);
  static Insertable<TaskDefinitionVersion> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<int>? versionNumber,
    Expression<String>? previousVersionId,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? supersededAt,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? questionText,
    Expression<String>? projectId,
    Expression<String>? taskType,
    Expression<String>? captureMode,
    Expression<bool>? successValue,
    Expression<String>? activeWeekdays,
    Expression<String>? recurrence,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? dueDate,
    Expression<String>? missedPolicy,
    Expression<String>? missedConsequence,
    Expression<int>? missedBufferDays,
    Expression<String>? postBufferBehavior,
    Expression<int>? maxCarryoverCount,
    Expression<String>? goalType,
    Expression<int>? goalValue,
    Expression<int>? goalWindowDays,
    Expression<String>? goalPeriod,
    Expression<String>? goalPeriodAlignment,
    Expression<String>? valueType,
    Expression<String>? valueCommitment,
    Expression<String>? valueUnitKey,
    Expression<String>? valueUnitLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (versionNumber != null) 'version_number': versionNumber,
      if (previousVersionId != null) 'previous_version_id': previousVersionId,
      if (validFrom != null) 'valid_from': validFrom,
      if (createdAt != null) 'created_at': createdAt,
      if (supersededAt != null) 'superseded_at': supersededAt,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (questionText != null) 'question_text': questionText,
      if (projectId != null) 'project_id': projectId,
      if (taskType != null) 'task_type': taskType,
      if (captureMode != null) 'capture_mode': captureMode,
      if (successValue != null) 'success_value': successValue,
      if (activeWeekdays != null) 'active_weekdays': activeWeekdays,
      if (recurrence != null) 'recurrence': recurrence,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (dueDate != null) 'due_date': dueDate,
      if (missedPolicy != null) 'missed_policy': missedPolicy,
      if (missedConsequence != null) 'missed_consequence': missedConsequence,
      if (missedBufferDays != null) 'missed_buffer_days': missedBufferDays,
      if (postBufferBehavior != null)
        'post_buffer_behavior': postBufferBehavior,
      if (maxCarryoverCount != null) 'max_carryover_count': maxCarryoverCount,
      if (goalType != null) 'goal_type': goalType,
      if (goalValue != null) 'goal_value': goalValue,
      if (goalWindowDays != null) 'goal_window_days': goalWindowDays,
      if (goalPeriod != null) 'goal_period': goalPeriod,
      if (goalPeriodAlignment != null)
        'goal_period_alignment': goalPeriodAlignment,
      if (valueType != null) 'value_type': valueType,
      if (valueCommitment != null) 'value_commitment': valueCommitment,
      if (valueUnitKey != null) 'value_unit_key': valueUnitKey,
      if (valueUnitLabel != null) 'value_unit_label': valueUnitLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskDefinitionVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<int>? versionNumber,
    Value<String?>? previousVersionId,
    Value<DateTime>? validFrom,
    Value<DateTime>? createdAt,
    Value<DateTime?>? supersededAt,
    Value<String>? name,
    Value<String>? description,
    Value<String>? questionText,
    Value<String?>? projectId,
    Value<String>? taskType,
    Value<String>? captureMode,
    Value<bool>? successValue,
    Value<String>? activeWeekdays,
    Value<String>? recurrence,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime?>? dueDate,
    Value<String>? missedPolicy,
    Value<String>? missedConsequence,
    Value<int>? missedBufferDays,
    Value<String>? postBufferBehavior,
    Value<int>? maxCarryoverCount,
    Value<String>? goalType,
    Value<int>? goalValue,
    Value<int?>? goalWindowDays,
    Value<String>? goalPeriod,
    Value<String>? goalPeriodAlignment,
    Value<String>? valueType,
    Value<String>? valueCommitment,
    Value<String>? valueUnitKey,
    Value<String>? valueUnitLabel,
    Value<int>? rowid,
  }) {
    return TaskDefinitionVersionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      versionNumber: versionNumber ?? this.versionNumber,
      previousVersionId: previousVersionId ?? this.previousVersionId,
      validFrom: validFrom ?? this.validFrom,
      createdAt: createdAt ?? this.createdAt,
      supersededAt: supersededAt ?? this.supersededAt,
      name: name ?? this.name,
      description: description ?? this.description,
      questionText: questionText ?? this.questionText,
      projectId: projectId ?? this.projectId,
      taskType: taskType ?? this.taskType,
      captureMode: captureMode ?? this.captureMode,
      successValue: successValue ?? this.successValue,
      activeWeekdays: activeWeekdays ?? this.activeWeekdays,
      recurrence: recurrence ?? this.recurrence,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dueDate: dueDate ?? this.dueDate,
      missedPolicy: missedPolicy ?? this.missedPolicy,
      missedConsequence: missedConsequence ?? this.missedConsequence,
      missedBufferDays: missedBufferDays ?? this.missedBufferDays,
      postBufferBehavior: postBufferBehavior ?? this.postBufferBehavior,
      maxCarryoverCount: maxCarryoverCount ?? this.maxCarryoverCount,
      goalType: goalType ?? this.goalType,
      goalValue: goalValue ?? this.goalValue,
      goalWindowDays: goalWindowDays ?? this.goalWindowDays,
      goalPeriod: goalPeriod ?? this.goalPeriod,
      goalPeriodAlignment: goalPeriodAlignment ?? this.goalPeriodAlignment,
      valueType: valueType ?? this.valueType,
      valueCommitment: valueCommitment ?? this.valueCommitment,
      valueUnitKey: valueUnitKey ?? this.valueUnitKey,
      valueUnitLabel: valueUnitLabel ?? this.valueUnitLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (previousVersionId.present) {
      map['previous_version_id'] = Variable<String>(previousVersionId.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (supersededAt.present) {
      map['superseded_at'] = Variable<DateTime>(supersededAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (taskType.present) {
      map['task_type'] = Variable<String>(taskType.value);
    }
    if (captureMode.present) {
      map['capture_mode'] = Variable<String>(captureMode.value);
    }
    if (successValue.present) {
      map['success_value'] = Variable<bool>(successValue.value);
    }
    if (activeWeekdays.present) {
      map['active_weekdays'] = Variable<String>(activeWeekdays.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (missedPolicy.present) {
      map['missed_policy'] = Variable<String>(missedPolicy.value);
    }
    if (missedConsequence.present) {
      map['missed_consequence'] = Variable<String>(missedConsequence.value);
    }
    if (missedBufferDays.present) {
      map['missed_buffer_days'] = Variable<int>(missedBufferDays.value);
    }
    if (postBufferBehavior.present) {
      map['post_buffer_behavior'] = Variable<String>(postBufferBehavior.value);
    }
    if (maxCarryoverCount.present) {
      map['max_carryover_count'] = Variable<int>(maxCarryoverCount.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (goalValue.present) {
      map['goal_value'] = Variable<int>(goalValue.value);
    }
    if (goalWindowDays.present) {
      map['goal_window_days'] = Variable<int>(goalWindowDays.value);
    }
    if (goalPeriod.present) {
      map['goal_period'] = Variable<String>(goalPeriod.value);
    }
    if (goalPeriodAlignment.present) {
      map['goal_period_alignment'] = Variable<String>(
        goalPeriodAlignment.value,
      );
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (valueCommitment.present) {
      map['value_commitment'] = Variable<String>(valueCommitment.value);
    }
    if (valueUnitKey.present) {
      map['value_unit_key'] = Variable<String>(valueUnitKey.value);
    }
    if (valueUnitLabel.present) {
      map['value_unit_label'] = Variable<String>(valueUnitLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskDefinitionVersionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('validFrom: $validFrom, ')
          ..write('createdAt: $createdAt, ')
          ..write('supersededAt: $supersededAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('questionText: $questionText, ')
          ..write('projectId: $projectId, ')
          ..write('taskType: $taskType, ')
          ..write('captureMode: $captureMode, ')
          ..write('successValue: $successValue, ')
          ..write('activeWeekdays: $activeWeekdays, ')
          ..write('recurrence: $recurrence, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('missedPolicy: $missedPolicy, ')
          ..write('missedConsequence: $missedConsequence, ')
          ..write('missedBufferDays: $missedBufferDays, ')
          ..write('postBufferBehavior: $postBufferBehavior, ')
          ..write('maxCarryoverCount: $maxCarryoverCount, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('goalWindowDays: $goalWindowDays, ')
          ..write('goalPeriod: $goalPeriod, ')
          ..write('goalPeriodAlignment: $goalPeriodAlignment, ')
          ..write('valueType: $valueType, ')
          ..write('valueCommitment: $valueCommitment, ')
          ..write('valueUnitKey: $valueUnitKey, ')
          ..write('valueUnitLabel: $valueUnitLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEntriesTable extends TaskEntries
    with TableInfo<$TaskEntriesTable, TaskEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskDefinitionVersionIdMeta =
      const VerificationMeta('taskDefinitionVersionId');
  @override
  late final GeneratedColumn<String> taskDefinitionVersionId =
      GeneratedColumn<String>(
        'task_definition_version_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES task_definition_versions (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>(
        'scheduled_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _originalScheduledDateMeta =
      const VerificationMeta('originalScheduledDate');
  @override
  late final GeneratedColumn<DateTime> originalScheduledDate =
      GeneratedColumn<DateTime>(
        'original_scheduled_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskEntryStatus.pending),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _respondedAtMeta = const VerificationMeta(
    'respondedAt',
  );
  @override
  late final GeneratedColumn<DateTime> respondedAt = GeneratedColumn<DateTime>(
    'responded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finalizedAtMeta = const VerificationMeta(
    'finalizedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finalizedAt = GeneratedColumn<DateTime>(
    'finalized_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectiveAtMeta = const VerificationMeta(
    'effectiveAt',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveAt = GeneratedColumn<DateTime>(
    'effective_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performedOnMeta = const VerificationMeta(
    'performedOn',
  );
  @override
  late final GeneratedColumn<DateTime> performedOn = GeneratedColumn<DateTime>(
    'performed_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _performedOnSourceMeta = const VerificationMeta(
    'performedOnSource',
  );
  @override
  late final GeneratedColumn<String> performedOnSource =
      GeneratedColumn<String>(
        'performed_on_source',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _planningOriginMeta = const VerificationMeta(
    'planningOrigin',
  );
  @override
  late final GeneratedColumn<String> planningOrigin = GeneratedColumn<String>(
    'planning_origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskEntryPlanningOrigin.planned),
  );
  static const VerificationMeta _resolutionOriginMeta = const VerificationMeta(
    'resolutionOrigin',
  );
  @override
  late final GeneratedColumn<String> resolutionOrigin = GeneratedColumn<String>(
    'resolution_origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appliedMissedPolicyMeta =
      const VerificationMeta('appliedMissedPolicy');
  @override
  late final GeneratedColumn<String> appliedMissedPolicy =
      GeneratedColumn<String>(
        'applied_missed_policy',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _appliedMissedConsequenceMeta =
      const VerificationMeta('appliedMissedConsequence');
  @override
  late final GeneratedColumn<String> appliedMissedConsequence =
      GeneratedColumn<String>(
        'applied_missed_consequence',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _checkboxValueMeta = const VerificationMeta(
    'checkboxValue',
  );
  @override
  late final GeneratedColumn<bool> checkboxValue = GeneratedColumn<bool>(
    'checkbox_value',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checkbox_value" IN (0, 1))',
    ),
  );
  static const VerificationMeta _numberValueMeta = const VerificationMeta(
    'numberValue',
  );
  @override
  late final GeneratedColumn<double> numberValue = GeneratedColumn<double>(
    'number_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    taskDefinitionVersionId,
    scheduledDate,
    originalScheduledDate,
    createdAt,
    status,
    updatedAt,
    respondedAt,
    finalizedAt,
    effectiveAt,
    performedOn,
    performedOnSource,
    revision,
    planningOrigin,
    resolutionOrigin,
    appliedMissedPolicy,
    appliedMissedConsequence,
    checkboxValue,
    numberValue,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('task_definition_version_id')) {
      context.handle(
        _taskDefinitionVersionIdMeta,
        taskDefinitionVersionId.isAcceptableOrUnknown(
          data['task_definition_version_id']!,
          _taskDefinitionVersionIdMeta,
        ),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDateMeta);
    }
    if (data.containsKey('original_scheduled_date')) {
      context.handle(
        _originalScheduledDateMeta,
        originalScheduledDate.isAcceptableOrUnknown(
          data['original_scheduled_date']!,
          _originalScheduledDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('responded_at')) {
      context.handle(
        _respondedAtMeta,
        respondedAt.isAcceptableOrUnknown(
          data['responded_at']!,
          _respondedAtMeta,
        ),
      );
    }
    if (data.containsKey('finalized_at')) {
      context.handle(
        _finalizedAtMeta,
        finalizedAt.isAcceptableOrUnknown(
          data['finalized_at']!,
          _finalizedAtMeta,
        ),
      );
    }
    if (data.containsKey('effective_at')) {
      context.handle(
        _effectiveAtMeta,
        effectiveAt.isAcceptableOrUnknown(
          data['effective_at']!,
          _effectiveAtMeta,
        ),
      );
    }
    if (data.containsKey('performed_on')) {
      context.handle(
        _performedOnMeta,
        performedOn.isAcceptableOrUnknown(
          data['performed_on']!,
          _performedOnMeta,
        ),
      );
    }
    if (data.containsKey('performed_on_source')) {
      context.handle(
        _performedOnSourceMeta,
        performedOnSource.isAcceptableOrUnknown(
          data['performed_on_source']!,
          _performedOnSourceMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('planning_origin')) {
      context.handle(
        _planningOriginMeta,
        planningOrigin.isAcceptableOrUnknown(
          data['planning_origin']!,
          _planningOriginMeta,
        ),
      );
    }
    if (data.containsKey('resolution_origin')) {
      context.handle(
        _resolutionOriginMeta,
        resolutionOrigin.isAcceptableOrUnknown(
          data['resolution_origin']!,
          _resolutionOriginMeta,
        ),
      );
    }
    if (data.containsKey('applied_missed_policy')) {
      context.handle(
        _appliedMissedPolicyMeta,
        appliedMissedPolicy.isAcceptableOrUnknown(
          data['applied_missed_policy']!,
          _appliedMissedPolicyMeta,
        ),
      );
    }
    if (data.containsKey('applied_missed_consequence')) {
      context.handle(
        _appliedMissedConsequenceMeta,
        appliedMissedConsequence.isAcceptableOrUnknown(
          data['applied_missed_consequence']!,
          _appliedMissedConsequenceMeta,
        ),
      );
    }
    if (data.containsKey('checkbox_value')) {
      context.handle(
        _checkboxValueMeta,
        checkboxValue.isAcceptableOrUnknown(
          data['checkbox_value']!,
          _checkboxValueMeta,
        ),
      );
    }
    if (data.containsKey('number_value')) {
      context.handle(
        _numberValueMeta,
        numberValue.isAcceptableOrUnknown(
          data['number_value']!,
          _numberValueMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {taskId, scheduledDate},
  ];
  @override
  TaskEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntry(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_id'],
          )!,
      taskDefinitionVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_definition_version_id'],
      ),
      scheduledDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}scheduled_date'],
          )!,
      originalScheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}original_scheduled_date'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      respondedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}responded_at'],
      ),
      finalizedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finalized_at'],
      ),
      effectiveAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_at'],
      ),
      performedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_on'],
      ),
      performedOnSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}performed_on_source'],
      ),
      revision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}revision'],
          )!,
      planningOrigin:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}planning_origin'],
          )!,
      resolutionOrigin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution_origin'],
      ),
      appliedMissedPolicy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applied_missed_policy'],
      ),
      appliedMissedConsequence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applied_missed_consequence'],
      ),
      checkboxValue: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checkbox_value'],
      ),
      numberValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}number_value'],
      ),
      note:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}note'],
          )!,
    );
  }

  @override
  $TaskEntriesTable createAlias(String alias) {
    return $TaskEntriesTable(attachedDatabase, alias);
  }
}

class TaskEntry extends DataClass implements Insertable<TaskEntry> {
  final String id;
  final String taskId;
  final String? taskDefinitionVersionId;
  final DateTime scheduledDate;
  final DateTime? originalScheduledDate;
  final DateTime createdAt;
  final String status;
  final DateTime updatedAt;
  final DateTime? respondedAt;
  final DateTime? finalizedAt;
  final DateTime? effectiveAt;
  final DateTime? performedOn;
  final String? performedOnSource;
  final int revision;
  final String planningOrigin;
  final String? resolutionOrigin;
  final String? appliedMissedPolicy;
  final String? appliedMissedConsequence;
  final bool? checkboxValue;
  final double? numberValue;
  final String note;
  const TaskEntry({
    required this.id,
    required this.taskId,
    this.taskDefinitionVersionId,
    required this.scheduledDate,
    this.originalScheduledDate,
    required this.createdAt,
    required this.status,
    required this.updatedAt,
    this.respondedAt,
    this.finalizedAt,
    this.effectiveAt,
    this.performedOn,
    this.performedOnSource,
    required this.revision,
    required this.planningOrigin,
    this.resolutionOrigin,
    this.appliedMissedPolicy,
    this.appliedMissedConsequence,
    this.checkboxValue,
    this.numberValue,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || taskDefinitionVersionId != null) {
      map['task_definition_version_id'] = Variable<String>(
        taskDefinitionVersionId,
      );
    }
    map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    if (!nullToAbsent || originalScheduledDate != null) {
      map['original_scheduled_date'] = Variable<DateTime>(
        originalScheduledDate,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || respondedAt != null) {
      map['responded_at'] = Variable<DateTime>(respondedAt);
    }
    if (!nullToAbsent || finalizedAt != null) {
      map['finalized_at'] = Variable<DateTime>(finalizedAt);
    }
    if (!nullToAbsent || effectiveAt != null) {
      map['effective_at'] = Variable<DateTime>(effectiveAt);
    }
    if (!nullToAbsent || performedOn != null) {
      map['performed_on'] = Variable<DateTime>(performedOn);
    }
    if (!nullToAbsent || performedOnSource != null) {
      map['performed_on_source'] = Variable<String>(performedOnSource);
    }
    map['revision'] = Variable<int>(revision);
    map['planning_origin'] = Variable<String>(planningOrigin);
    if (!nullToAbsent || resolutionOrigin != null) {
      map['resolution_origin'] = Variable<String>(resolutionOrigin);
    }
    if (!nullToAbsent || appliedMissedPolicy != null) {
      map['applied_missed_policy'] = Variable<String>(appliedMissedPolicy);
    }
    if (!nullToAbsent || appliedMissedConsequence != null) {
      map['applied_missed_consequence'] = Variable<String>(
        appliedMissedConsequence,
      );
    }
    if (!nullToAbsent || checkboxValue != null) {
      map['checkbox_value'] = Variable<bool>(checkboxValue);
    }
    if (!nullToAbsent || numberValue != null) {
      map['number_value'] = Variable<double>(numberValue);
    }
    map['note'] = Variable<String>(note);
    return map;
  }

  TaskEntriesCompanion toCompanion(bool nullToAbsent) {
    return TaskEntriesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      taskDefinitionVersionId:
          taskDefinitionVersionId == null && nullToAbsent
              ? const Value.absent()
              : Value(taskDefinitionVersionId),
      scheduledDate: Value(scheduledDate),
      originalScheduledDate:
          originalScheduledDate == null && nullToAbsent
              ? const Value.absent()
              : Value(originalScheduledDate),
      createdAt: Value(createdAt),
      status: Value(status),
      updatedAt: Value(updatedAt),
      respondedAt:
          respondedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(respondedAt),
      finalizedAt:
          finalizedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(finalizedAt),
      effectiveAt:
          effectiveAt == null && nullToAbsent
              ? const Value.absent()
              : Value(effectiveAt),
      performedOn:
          performedOn == null && nullToAbsent
              ? const Value.absent()
              : Value(performedOn),
      performedOnSource:
          performedOnSource == null && nullToAbsent
              ? const Value.absent()
              : Value(performedOnSource),
      revision: Value(revision),
      planningOrigin: Value(planningOrigin),
      resolutionOrigin:
          resolutionOrigin == null && nullToAbsent
              ? const Value.absent()
              : Value(resolutionOrigin),
      appliedMissedPolicy:
          appliedMissedPolicy == null && nullToAbsent
              ? const Value.absent()
              : Value(appliedMissedPolicy),
      appliedMissedConsequence:
          appliedMissedConsequence == null && nullToAbsent
              ? const Value.absent()
              : Value(appliedMissedConsequence),
      checkboxValue:
          checkboxValue == null && nullToAbsent
              ? const Value.absent()
              : Value(checkboxValue),
      numberValue:
          numberValue == null && nullToAbsent
              ? const Value.absent()
              : Value(numberValue),
      note: Value(note),
    );
  }

  factory TaskEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntry(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      taskDefinitionVersionId: serializer.fromJson<String?>(
        json['taskDefinitionVersionId'],
      ),
      scheduledDate: serializer.fromJson<DateTime>(json['scheduledDate']),
      originalScheduledDate: serializer.fromJson<DateTime?>(
        json['originalScheduledDate'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      respondedAt: serializer.fromJson<DateTime?>(json['respondedAt']),
      finalizedAt: serializer.fromJson<DateTime?>(json['finalizedAt']),
      effectiveAt: serializer.fromJson<DateTime?>(json['effectiveAt']),
      performedOn: serializer.fromJson<DateTime?>(json['performedOn']),
      performedOnSource: serializer.fromJson<String?>(
        json['performedOnSource'],
      ),
      revision: serializer.fromJson<int>(json['revision']),
      planningOrigin: serializer.fromJson<String>(json['planningOrigin']),
      resolutionOrigin: serializer.fromJson<String?>(json['resolutionOrigin']),
      appliedMissedPolicy: serializer.fromJson<String?>(
        json['appliedMissedPolicy'],
      ),
      appliedMissedConsequence: serializer.fromJson<String?>(
        json['appliedMissedConsequence'],
      ),
      checkboxValue: serializer.fromJson<bool?>(json['checkboxValue']),
      numberValue: serializer.fromJson<double?>(json['numberValue']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'taskDefinitionVersionId': serializer.toJson<String?>(
        taskDefinitionVersionId,
      ),
      'scheduledDate': serializer.toJson<DateTime>(scheduledDate),
      'originalScheduledDate': serializer.toJson<DateTime?>(
        originalScheduledDate,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'respondedAt': serializer.toJson<DateTime?>(respondedAt),
      'finalizedAt': serializer.toJson<DateTime?>(finalizedAt),
      'effectiveAt': serializer.toJson<DateTime?>(effectiveAt),
      'performedOn': serializer.toJson<DateTime?>(performedOn),
      'performedOnSource': serializer.toJson<String?>(performedOnSource),
      'revision': serializer.toJson<int>(revision),
      'planningOrigin': serializer.toJson<String>(planningOrigin),
      'resolutionOrigin': serializer.toJson<String?>(resolutionOrigin),
      'appliedMissedPolicy': serializer.toJson<String?>(appliedMissedPolicy),
      'appliedMissedConsequence': serializer.toJson<String?>(
        appliedMissedConsequence,
      ),
      'checkboxValue': serializer.toJson<bool?>(checkboxValue),
      'numberValue': serializer.toJson<double?>(numberValue),
      'note': serializer.toJson<String>(note),
    };
  }

  TaskEntry copyWith({
    String? id,
    String? taskId,
    Value<String?> taskDefinitionVersionId = const Value.absent(),
    DateTime? scheduledDate,
    Value<DateTime?> originalScheduledDate = const Value.absent(),
    DateTime? createdAt,
    String? status,
    DateTime? updatedAt,
    Value<DateTime?> respondedAt = const Value.absent(),
    Value<DateTime?> finalizedAt = const Value.absent(),
    Value<DateTime?> effectiveAt = const Value.absent(),
    Value<DateTime?> performedOn = const Value.absent(),
    Value<String?> performedOnSource = const Value.absent(),
    int? revision,
    String? planningOrigin,
    Value<String?> resolutionOrigin = const Value.absent(),
    Value<String?> appliedMissedPolicy = const Value.absent(),
    Value<String?> appliedMissedConsequence = const Value.absent(),
    Value<bool?> checkboxValue = const Value.absent(),
    Value<double?> numberValue = const Value.absent(),
    String? note,
  }) => TaskEntry(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    taskDefinitionVersionId:
        taskDefinitionVersionId.present
            ? taskDefinitionVersionId.value
            : this.taskDefinitionVersionId,
    scheduledDate: scheduledDate ?? this.scheduledDate,
    originalScheduledDate:
        originalScheduledDate.present
            ? originalScheduledDate.value
            : this.originalScheduledDate,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    respondedAt: respondedAt.present ? respondedAt.value : this.respondedAt,
    finalizedAt: finalizedAt.present ? finalizedAt.value : this.finalizedAt,
    effectiveAt: effectiveAt.present ? effectiveAt.value : this.effectiveAt,
    performedOn: performedOn.present ? performedOn.value : this.performedOn,
    performedOnSource:
        performedOnSource.present
            ? performedOnSource.value
            : this.performedOnSource,
    revision: revision ?? this.revision,
    planningOrigin: planningOrigin ?? this.planningOrigin,
    resolutionOrigin:
        resolutionOrigin.present
            ? resolutionOrigin.value
            : this.resolutionOrigin,
    appliedMissedPolicy:
        appliedMissedPolicy.present
            ? appliedMissedPolicy.value
            : this.appliedMissedPolicy,
    appliedMissedConsequence:
        appliedMissedConsequence.present
            ? appliedMissedConsequence.value
            : this.appliedMissedConsequence,
    checkboxValue:
        checkboxValue.present ? checkboxValue.value : this.checkboxValue,
    numberValue: numberValue.present ? numberValue.value : this.numberValue,
    note: note ?? this.note,
  );
  TaskEntry copyWithCompanion(TaskEntriesCompanion data) {
    return TaskEntry(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      taskDefinitionVersionId:
          data.taskDefinitionVersionId.present
              ? data.taskDefinitionVersionId.value
              : this.taskDefinitionVersionId,
      scheduledDate:
          data.scheduledDate.present
              ? data.scheduledDate.value
              : this.scheduledDate,
      originalScheduledDate:
          data.originalScheduledDate.present
              ? data.originalScheduledDate.value
              : this.originalScheduledDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      respondedAt:
          data.respondedAt.present ? data.respondedAt.value : this.respondedAt,
      finalizedAt:
          data.finalizedAt.present ? data.finalizedAt.value : this.finalizedAt,
      effectiveAt:
          data.effectiveAt.present ? data.effectiveAt.value : this.effectiveAt,
      performedOn:
          data.performedOn.present ? data.performedOn.value : this.performedOn,
      performedOnSource:
          data.performedOnSource.present
              ? data.performedOnSource.value
              : this.performedOnSource,
      revision: data.revision.present ? data.revision.value : this.revision,
      planningOrigin:
          data.planningOrigin.present
              ? data.planningOrigin.value
              : this.planningOrigin,
      resolutionOrigin:
          data.resolutionOrigin.present
              ? data.resolutionOrigin.value
              : this.resolutionOrigin,
      appliedMissedPolicy:
          data.appliedMissedPolicy.present
              ? data.appliedMissedPolicy.value
              : this.appliedMissedPolicy,
      appliedMissedConsequence:
          data.appliedMissedConsequence.present
              ? data.appliedMissedConsequence.value
              : this.appliedMissedConsequence,
      checkboxValue:
          data.checkboxValue.present
              ? data.checkboxValue.value
              : this.checkboxValue,
      numberValue:
          data.numberValue.present ? data.numberValue.value : this.numberValue,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntry(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('taskDefinitionVersionId: $taskDefinitionVersionId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('originalScheduledDate: $originalScheduledDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('finalizedAt: $finalizedAt, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('performedOn: $performedOn, ')
          ..write('performedOnSource: $performedOnSource, ')
          ..write('revision: $revision, ')
          ..write('planningOrigin: $planningOrigin, ')
          ..write('resolutionOrigin: $resolutionOrigin, ')
          ..write('appliedMissedPolicy: $appliedMissedPolicy, ')
          ..write('appliedMissedConsequence: $appliedMissedConsequence, ')
          ..write('checkboxValue: $checkboxValue, ')
          ..write('numberValue: $numberValue, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    taskId,
    taskDefinitionVersionId,
    scheduledDate,
    originalScheduledDate,
    createdAt,
    status,
    updatedAt,
    respondedAt,
    finalizedAt,
    effectiveAt,
    performedOn,
    performedOnSource,
    revision,
    planningOrigin,
    resolutionOrigin,
    appliedMissedPolicy,
    appliedMissedConsequence,
    checkboxValue,
    numberValue,
    note,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntry &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.taskDefinitionVersionId == this.taskDefinitionVersionId &&
          other.scheduledDate == this.scheduledDate &&
          other.originalScheduledDate == this.originalScheduledDate &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.respondedAt == this.respondedAt &&
          other.finalizedAt == this.finalizedAt &&
          other.effectiveAt == this.effectiveAt &&
          other.performedOn == this.performedOn &&
          other.performedOnSource == this.performedOnSource &&
          other.revision == this.revision &&
          other.planningOrigin == this.planningOrigin &&
          other.resolutionOrigin == this.resolutionOrigin &&
          other.appliedMissedPolicy == this.appliedMissedPolicy &&
          other.appliedMissedConsequence == this.appliedMissedConsequence &&
          other.checkboxValue == this.checkboxValue &&
          other.numberValue == this.numberValue &&
          other.note == this.note);
}

class TaskEntriesCompanion extends UpdateCompanion<TaskEntry> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String?> taskDefinitionVersionId;
  final Value<DateTime> scheduledDate;
  final Value<DateTime?> originalScheduledDate;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> respondedAt;
  final Value<DateTime?> finalizedAt;
  final Value<DateTime?> effectiveAt;
  final Value<DateTime?> performedOn;
  final Value<String?> performedOnSource;
  final Value<int> revision;
  final Value<String> planningOrigin;
  final Value<String?> resolutionOrigin;
  final Value<String?> appliedMissedPolicy;
  final Value<String?> appliedMissedConsequence;
  final Value<bool?> checkboxValue;
  final Value<double?> numberValue;
  final Value<String> note;
  final Value<int> rowid;
  const TaskEntriesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.taskDefinitionVersionId = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.originalScheduledDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.respondedAt = const Value.absent(),
    this.finalizedAt = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.performedOn = const Value.absent(),
    this.performedOnSource = const Value.absent(),
    this.revision = const Value.absent(),
    this.planningOrigin = const Value.absent(),
    this.resolutionOrigin = const Value.absent(),
    this.appliedMissedPolicy = const Value.absent(),
    this.appliedMissedConsequence = const Value.absent(),
    this.checkboxValue = const Value.absent(),
    this.numberValue = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEntriesCompanion.insert({
    required String id,
    required String taskId,
    this.taskDefinitionVersionId = const Value.absent(),
    required DateTime scheduledDate,
    this.originalScheduledDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime updatedAt,
    this.respondedAt = const Value.absent(),
    this.finalizedAt = const Value.absent(),
    this.effectiveAt = const Value.absent(),
    this.performedOn = const Value.absent(),
    this.performedOnSource = const Value.absent(),
    this.revision = const Value.absent(),
    this.planningOrigin = const Value.absent(),
    this.resolutionOrigin = const Value.absent(),
    this.appliedMissedPolicy = const Value.absent(),
    this.appliedMissedConsequence = const Value.absent(),
    this.checkboxValue = const Value.absent(),
    this.numberValue = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       scheduledDate = Value(scheduledDate),
       updatedAt = Value(updatedAt);
  static Insertable<TaskEntry> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? taskDefinitionVersionId,
    Expression<DateTime>? scheduledDate,
    Expression<DateTime>? originalScheduledDate,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? respondedAt,
    Expression<DateTime>? finalizedAt,
    Expression<DateTime>? effectiveAt,
    Expression<DateTime>? performedOn,
    Expression<String>? performedOnSource,
    Expression<int>? revision,
    Expression<String>? planningOrigin,
    Expression<String>? resolutionOrigin,
    Expression<String>? appliedMissedPolicy,
    Expression<String>? appliedMissedConsequence,
    Expression<bool>? checkboxValue,
    Expression<double>? numberValue,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (taskDefinitionVersionId != null)
        'task_definition_version_id': taskDefinitionVersionId,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (originalScheduledDate != null)
        'original_scheduled_date': originalScheduledDate,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (respondedAt != null) 'responded_at': respondedAt,
      if (finalizedAt != null) 'finalized_at': finalizedAt,
      if (effectiveAt != null) 'effective_at': effectiveAt,
      if (performedOn != null) 'performed_on': performedOn,
      if (performedOnSource != null) 'performed_on_source': performedOnSource,
      if (revision != null) 'revision': revision,
      if (planningOrigin != null) 'planning_origin': planningOrigin,
      if (resolutionOrigin != null) 'resolution_origin': resolutionOrigin,
      if (appliedMissedPolicy != null)
        'applied_missed_policy': appliedMissedPolicy,
      if (appliedMissedConsequence != null)
        'applied_missed_consequence': appliedMissedConsequence,
      if (checkboxValue != null) 'checkbox_value': checkboxValue,
      if (numberValue != null) 'number_value': numberValue,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String?>? taskDefinitionVersionId,
    Value<DateTime>? scheduledDate,
    Value<DateTime?>? originalScheduledDate,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? respondedAt,
    Value<DateTime?>? finalizedAt,
    Value<DateTime?>? effectiveAt,
    Value<DateTime?>? performedOn,
    Value<String?>? performedOnSource,
    Value<int>? revision,
    Value<String>? planningOrigin,
    Value<String?>? resolutionOrigin,
    Value<String?>? appliedMissedPolicy,
    Value<String?>? appliedMissedConsequence,
    Value<bool?>? checkboxValue,
    Value<double?>? numberValue,
    Value<String>? note,
    Value<int>? rowid,
  }) {
    return TaskEntriesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      taskDefinitionVersionId:
          taskDefinitionVersionId ?? this.taskDefinitionVersionId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      originalScheduledDate:
          originalScheduledDate ?? this.originalScheduledDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      respondedAt: respondedAt ?? this.respondedAt,
      finalizedAt: finalizedAt ?? this.finalizedAt,
      effectiveAt: effectiveAt ?? this.effectiveAt,
      performedOn: performedOn ?? this.performedOn,
      performedOnSource: performedOnSource ?? this.performedOnSource,
      revision: revision ?? this.revision,
      planningOrigin: planningOrigin ?? this.planningOrigin,
      resolutionOrigin: resolutionOrigin ?? this.resolutionOrigin,
      appliedMissedPolicy: appliedMissedPolicy ?? this.appliedMissedPolicy,
      appliedMissedConsequence:
          appliedMissedConsequence ?? this.appliedMissedConsequence,
      checkboxValue: checkboxValue ?? this.checkboxValue,
      numberValue: numberValue ?? this.numberValue,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (taskDefinitionVersionId.present) {
      map['task_definition_version_id'] = Variable<String>(
        taskDefinitionVersionId.value,
      );
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (originalScheduledDate.present) {
      map['original_scheduled_date'] = Variable<DateTime>(
        originalScheduledDate.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (respondedAt.present) {
      map['responded_at'] = Variable<DateTime>(respondedAt.value);
    }
    if (finalizedAt.present) {
      map['finalized_at'] = Variable<DateTime>(finalizedAt.value);
    }
    if (effectiveAt.present) {
      map['effective_at'] = Variable<DateTime>(effectiveAt.value);
    }
    if (performedOn.present) {
      map['performed_on'] = Variable<DateTime>(performedOn.value);
    }
    if (performedOnSource.present) {
      map['performed_on_source'] = Variable<String>(performedOnSource.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (planningOrigin.present) {
      map['planning_origin'] = Variable<String>(planningOrigin.value);
    }
    if (resolutionOrigin.present) {
      map['resolution_origin'] = Variable<String>(resolutionOrigin.value);
    }
    if (appliedMissedPolicy.present) {
      map['applied_missed_policy'] = Variable<String>(
        appliedMissedPolicy.value,
      );
    }
    if (appliedMissedConsequence.present) {
      map['applied_missed_consequence'] = Variable<String>(
        appliedMissedConsequence.value,
      );
    }
    if (checkboxValue.present) {
      map['checkbox_value'] = Variable<bool>(checkboxValue.value);
    }
    if (numberValue.present) {
      map['number_value'] = Variable<double>(numberValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntriesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('taskDefinitionVersionId: $taskDefinitionVersionId, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('originalScheduledDate: $originalScheduledDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('respondedAt: $respondedAt, ')
          ..write('finalizedAt: $finalizedAt, ')
          ..write('effectiveAt: $effectiveAt, ')
          ..write('performedOn: $performedOn, ')
          ..write('performedOnSource: $performedOnSource, ')
          ..write('revision: $revision, ')
          ..write('planningOrigin: $planningOrigin, ')
          ..write('resolutionOrigin: $resolutionOrigin, ')
          ..write('appliedMissedPolicy: $appliedMissedPolicy, ')
          ..write('appliedMissedConsequence: $appliedMissedConsequence, ')
          ..write('checkboxValue: $checkboxValue, ')
          ..write('numberValue: $numberValue, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskEntryValuesTable extends TaskEntryValues
    with TableInfo<$TaskEntryValuesTable, TaskEntryValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEntryValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberValueMeta = const VerificationMeta(
    'numberValue',
  );
  @override
  late final GeneratedColumn<double> numberValue = GeneratedColumn<double>(
    'number_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _normalizedNumberValueMeta =
      const VerificationMeta('normalizedNumberValue');
  @override
  late final GeneratedColumn<double> normalizedNumberValue =
      GeneratedColumn<double>(
        'normalized_number_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _unitKeyMeta = const VerificationMeta(
    'unitKey',
  );
  @override
  late final GeneratedColumn<String> unitKey = GeneratedColumn<String>(
    'unit_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _unitLabelMeta = const VerificationMeta(
    'unitLabel',
  );
  @override
  late final GeneratedColumn<String> unitLabel = GeneratedColumn<String>(
    'unit_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMinutesMeta = const VerificationMeta(
    'timeMinutes',
  );
  @override
  late final GeneratedColumn<int> timeMinutes = GeneratedColumn<int>(
    'time_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayOffsetMeta = const VerificationMeta(
    'dayOffset',
  );
  @override
  late final GeneratedColumn<int> dayOffset = GeneratedColumn<int>(
    'day_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entryId,
    valueType,
    numberValue,
    normalizedNumberValue,
    unitKey,
    unitLabel,
    durationSeconds,
    timeMinutes,
    dayOffset,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_entry_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEntryValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('number_value')) {
      context.handle(
        _numberValueMeta,
        numberValue.isAcceptableOrUnknown(
          data['number_value']!,
          _numberValueMeta,
        ),
      );
    }
    if (data.containsKey('normalized_number_value')) {
      context.handle(
        _normalizedNumberValueMeta,
        normalizedNumberValue.isAcceptableOrUnknown(
          data['normalized_number_value']!,
          _normalizedNumberValueMeta,
        ),
      );
    }
    if (data.containsKey('unit_key')) {
      context.handle(
        _unitKeyMeta,
        unitKey.isAcceptableOrUnknown(data['unit_key']!, _unitKeyMeta),
      );
    }
    if (data.containsKey('unit_label')) {
      context.handle(
        _unitLabelMeta,
        unitLabel.isAcceptableOrUnknown(data['unit_label']!, _unitLabelMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('time_minutes')) {
      context.handle(
        _timeMinutesMeta,
        timeMinutes.isAcceptableOrUnknown(
          data['time_minutes']!,
          _timeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('day_offset')) {
      context.handle(
        _dayOffsetMeta,
        dayOffset.isAcceptableOrUnknown(data['day_offset']!, _dayOffsetMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entryId},
  ];
  @override
  TaskEntryValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEntryValue(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      entryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entry_id'],
          )!,
      valueType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value_type'],
          )!,
      numberValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}number_value'],
      ),
      normalizedNumberValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}normalized_number_value'],
      ),
      unitKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit_key'],
          )!,
      unitLabel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}unit_label'],
          )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      timeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_minutes'],
      ),
      dayOffset:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}day_offset'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TaskEntryValuesTable createAlias(String alias) {
    return $TaskEntryValuesTable(attachedDatabase, alias);
  }
}

class TaskEntryValue extends DataClass implements Insertable<TaskEntryValue> {
  final String id;
  final String entryId;
  final String valueType;
  final double? numberValue;
  final double? normalizedNumberValue;
  final String unitKey;
  final String unitLabel;
  final int? durationSeconds;
  final int? timeMinutes;
  final int dayOffset;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskEntryValue({
    required this.id,
    required this.entryId,
    required this.valueType,
    this.numberValue,
    this.normalizedNumberValue,
    required this.unitKey,
    required this.unitLabel,
    this.durationSeconds,
    this.timeMinutes,
    required this.dayOffset,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_id'] = Variable<String>(entryId);
    map['value_type'] = Variable<String>(valueType);
    if (!nullToAbsent || numberValue != null) {
      map['number_value'] = Variable<double>(numberValue);
    }
    if (!nullToAbsent || normalizedNumberValue != null) {
      map['normalized_number_value'] = Variable<double>(normalizedNumberValue);
    }
    map['unit_key'] = Variable<String>(unitKey);
    map['unit_label'] = Variable<String>(unitLabel);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || timeMinutes != null) {
      map['time_minutes'] = Variable<int>(timeMinutes);
    }
    map['day_offset'] = Variable<int>(dayOffset);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskEntryValuesCompanion toCompanion(bool nullToAbsent) {
    return TaskEntryValuesCompanion(
      id: Value(id),
      entryId: Value(entryId),
      valueType: Value(valueType),
      numberValue:
          numberValue == null && nullToAbsent
              ? const Value.absent()
              : Value(numberValue),
      normalizedNumberValue:
          normalizedNumberValue == null && nullToAbsent
              ? const Value.absent()
              : Value(normalizedNumberValue),
      unitKey: Value(unitKey),
      unitLabel: Value(unitLabel),
      durationSeconds:
          durationSeconds == null && nullToAbsent
              ? const Value.absent()
              : Value(durationSeconds),
      timeMinutes:
          timeMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(timeMinutes),
      dayOffset: Value(dayOffset),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskEntryValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEntryValue(
      id: serializer.fromJson<String>(json['id']),
      entryId: serializer.fromJson<String>(json['entryId']),
      valueType: serializer.fromJson<String>(json['valueType']),
      numberValue: serializer.fromJson<double?>(json['numberValue']),
      normalizedNumberValue: serializer.fromJson<double?>(
        json['normalizedNumberValue'],
      ),
      unitKey: serializer.fromJson<String>(json['unitKey']),
      unitLabel: serializer.fromJson<String>(json['unitLabel']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      timeMinutes: serializer.fromJson<int?>(json['timeMinutes']),
      dayOffset: serializer.fromJson<int>(json['dayOffset']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryId': serializer.toJson<String>(entryId),
      'valueType': serializer.toJson<String>(valueType),
      'numberValue': serializer.toJson<double?>(numberValue),
      'normalizedNumberValue': serializer.toJson<double?>(
        normalizedNumberValue,
      ),
      'unitKey': serializer.toJson<String>(unitKey),
      'unitLabel': serializer.toJson<String>(unitLabel),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'timeMinutes': serializer.toJson<int?>(timeMinutes),
      'dayOffset': serializer.toJson<int>(dayOffset),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskEntryValue copyWith({
    String? id,
    String? entryId,
    String? valueType,
    Value<double?> numberValue = const Value.absent(),
    Value<double?> normalizedNumberValue = const Value.absent(),
    String? unitKey,
    String? unitLabel,
    Value<int?> durationSeconds = const Value.absent(),
    Value<int?> timeMinutes = const Value.absent(),
    int? dayOffset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskEntryValue(
    id: id ?? this.id,
    entryId: entryId ?? this.entryId,
    valueType: valueType ?? this.valueType,
    numberValue: numberValue.present ? numberValue.value : this.numberValue,
    normalizedNumberValue:
        normalizedNumberValue.present
            ? normalizedNumberValue.value
            : this.normalizedNumberValue,
    unitKey: unitKey ?? this.unitKey,
    unitLabel: unitLabel ?? this.unitLabel,
    durationSeconds:
        durationSeconds.present ? durationSeconds.value : this.durationSeconds,
    timeMinutes: timeMinutes.present ? timeMinutes.value : this.timeMinutes,
    dayOffset: dayOffset ?? this.dayOffset,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskEntryValue copyWithCompanion(TaskEntryValuesCompanion data) {
    return TaskEntryValue(
      id: data.id.present ? data.id.value : this.id,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      numberValue:
          data.numberValue.present ? data.numberValue.value : this.numberValue,
      normalizedNumberValue:
          data.normalizedNumberValue.present
              ? data.normalizedNumberValue.value
              : this.normalizedNumberValue,
      unitKey: data.unitKey.present ? data.unitKey.value : this.unitKey,
      unitLabel: data.unitLabel.present ? data.unitLabel.value : this.unitLabel,
      durationSeconds:
          data.durationSeconds.present
              ? data.durationSeconds.value
              : this.durationSeconds,
      timeMinutes:
          data.timeMinutes.present ? data.timeMinutes.value : this.timeMinutes,
      dayOffset: data.dayOffset.present ? data.dayOffset.value : this.dayOffset,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntryValue(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('valueType: $valueType, ')
          ..write('numberValue: $numberValue, ')
          ..write('normalizedNumberValue: $normalizedNumberValue, ')
          ..write('unitKey: $unitKey, ')
          ..write('unitLabel: $unitLabel, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('timeMinutes: $timeMinutes, ')
          ..write('dayOffset: $dayOffset, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entryId,
    valueType,
    numberValue,
    normalizedNumberValue,
    unitKey,
    unitLabel,
    durationSeconds,
    timeMinutes,
    dayOffset,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEntryValue &&
          other.id == this.id &&
          other.entryId == this.entryId &&
          other.valueType == this.valueType &&
          other.numberValue == this.numberValue &&
          other.normalizedNumberValue == this.normalizedNumberValue &&
          other.unitKey == this.unitKey &&
          other.unitLabel == this.unitLabel &&
          other.durationSeconds == this.durationSeconds &&
          other.timeMinutes == this.timeMinutes &&
          other.dayOffset == this.dayOffset &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskEntryValuesCompanion extends UpdateCompanion<TaskEntryValue> {
  final Value<String> id;
  final Value<String> entryId;
  final Value<String> valueType;
  final Value<double?> numberValue;
  final Value<double?> normalizedNumberValue;
  final Value<String> unitKey;
  final Value<String> unitLabel;
  final Value<int?> durationSeconds;
  final Value<int?> timeMinutes;
  final Value<int> dayOffset;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskEntryValuesCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.valueType = const Value.absent(),
    this.numberValue = const Value.absent(),
    this.normalizedNumberValue = const Value.absent(),
    this.unitKey = const Value.absent(),
    this.unitLabel = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.timeMinutes = const Value.absent(),
    this.dayOffset = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskEntryValuesCompanion.insert({
    required String id,
    required String entryId,
    required String valueType,
    this.numberValue = const Value.absent(),
    this.normalizedNumberValue = const Value.absent(),
    this.unitKey = const Value.absent(),
    this.unitLabel = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.timeMinutes = const Value.absent(),
    this.dayOffset = const Value.absent(),
    this.createdAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       valueType = Value(valueType),
       updatedAt = Value(updatedAt);
  static Insertable<TaskEntryValue> custom({
    Expression<String>? id,
    Expression<String>? entryId,
    Expression<String>? valueType,
    Expression<double>? numberValue,
    Expression<double>? normalizedNumberValue,
    Expression<String>? unitKey,
    Expression<String>? unitLabel,
    Expression<int>? durationSeconds,
    Expression<int>? timeMinutes,
    Expression<int>? dayOffset,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (valueType != null) 'value_type': valueType,
      if (numberValue != null) 'number_value': numberValue,
      if (normalizedNumberValue != null)
        'normalized_number_value': normalizedNumberValue,
      if (unitKey != null) 'unit_key': unitKey,
      if (unitLabel != null) 'unit_label': unitLabel,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (timeMinutes != null) 'time_minutes': timeMinutes,
      if (dayOffset != null) 'day_offset': dayOffset,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskEntryValuesCompanion copyWith({
    Value<String>? id,
    Value<String>? entryId,
    Value<String>? valueType,
    Value<double?>? numberValue,
    Value<double?>? normalizedNumberValue,
    Value<String>? unitKey,
    Value<String>? unitLabel,
    Value<int?>? durationSeconds,
    Value<int?>? timeMinutes,
    Value<int>? dayOffset,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskEntryValuesCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      valueType: valueType ?? this.valueType,
      numberValue: numberValue ?? this.numberValue,
      normalizedNumberValue:
          normalizedNumberValue ?? this.normalizedNumberValue,
      unitKey: unitKey ?? this.unitKey,
      unitLabel: unitLabel ?? this.unitLabel,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      timeMinutes: timeMinutes ?? this.timeMinutes,
      dayOffset: dayOffset ?? this.dayOffset,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (numberValue.present) {
      map['number_value'] = Variable<double>(numberValue.value);
    }
    if (normalizedNumberValue.present) {
      map['normalized_number_value'] = Variable<double>(
        normalizedNumberValue.value,
      );
    }
    if (unitKey.present) {
      map['unit_key'] = Variable<String>(unitKey.value);
    }
    if (unitLabel.present) {
      map['unit_label'] = Variable<String>(unitLabel.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (timeMinutes.present) {
      map['time_minutes'] = Variable<int>(timeMinutes.value);
    }
    if (dayOffset.present) {
      map['day_offset'] = Variable<int>(dayOffset.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEntryValuesCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('valueType: $valueType, ')
          ..write('numberValue: $numberValue, ')
          ..write('normalizedNumberValue: $normalizedNumberValue, ')
          ..write('unitKey: $unitKey, ')
          ..write('unitLabel: $unitLabel, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('timeMinutes: $timeMinutes, ')
          ..write('dayOffset: $dayOffset, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskValueBundlesTable extends TaskValueBundles
    with TableInfo<$TaskValueBundlesTable, TaskValueBundle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskValueBundlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trashedAt = GeneratedColumn<DateTime>(
    'trashed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purgeAtMeta = const VerificationMeta(
    'purgeAt',
  );
  @override
  late final GeneratedColumn<DateTime> purgeAt = GeneratedColumn<DateTime>(
    'purge_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lifecycleRevisionMeta = const VerificationMeta(
    'lifecycleRevision',
  );
  @override
  late final GeneratedColumn<int> lifecycleRevision = GeneratedColumn<int>(
    'lifecycle_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lifecycleUpdatedAtMeta =
      const VerificationMeta('lifecycleUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lifecycleUpdatedAt =
      GeneratedColumn<DateTime>(
        'lifecycle_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    projectId,
    isActive,
    trashedAt,
    purgeAt,
    lifecycleRevision,
    lifecycleUpdatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_value_bundles';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskValueBundle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    }
    if (data.containsKey('purge_at')) {
      context.handle(
        _purgeAtMeta,
        purgeAt.isAcceptableOrUnknown(data['purge_at']!, _purgeAtMeta),
      );
    }
    if (data.containsKey('lifecycle_revision')) {
      context.handle(
        _lifecycleRevisionMeta,
        lifecycleRevision.isAcceptableOrUnknown(
          data['lifecycle_revision']!,
          _lifecycleRevisionMeta,
        ),
      );
    }
    if (data.containsKey('lifecycle_updated_at')) {
      context.handle(
        _lifecycleUpdatedAtMeta,
        lifecycleUpdatedAt.isAcceptableOrUnknown(
          data['lifecycle_updated_at']!,
          _lifecycleUpdatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskValueBundle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskValueBundle(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trashed_at'],
      ),
      purgeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purge_at'],
      ),
      lifecycleRevision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}lifecycle_revision'],
          )!,
      lifecycleUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lifecycle_updated_at'],
      ),
    );
  }

  @override
  $TaskValueBundlesTable createAlias(String alias) {
    return $TaskValueBundlesTable(attachedDatabase, alias);
  }
}

class TaskValueBundle extends DataClass implements Insertable<TaskValueBundle> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? projectId;
  final bool isActive;
  final DateTime? trashedAt;
  final DateTime? purgeAt;
  final int lifecycleRevision;
  final DateTime? lifecycleUpdatedAt;
  const TaskValueBundle({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.projectId,
    required this.isActive,
    this.trashedAt,
    this.purgeAt,
    required this.lifecycleRevision,
    this.lifecycleUpdatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || trashedAt != null) {
      map['trashed_at'] = Variable<DateTime>(trashedAt);
    }
    if (!nullToAbsent || purgeAt != null) {
      map['purge_at'] = Variable<DateTime>(purgeAt);
    }
    map['lifecycle_revision'] = Variable<int>(lifecycleRevision);
    if (!nullToAbsent || lifecycleUpdatedAt != null) {
      map['lifecycle_updated_at'] = Variable<DateTime>(lifecycleUpdatedAt);
    }
    return map;
  }

  TaskValueBundlesCompanion toCompanion(bool nullToAbsent) {
    return TaskValueBundlesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      projectId:
          projectId == null && nullToAbsent
              ? const Value.absent()
              : Value(projectId),
      isActive: Value(isActive),
      trashedAt:
          trashedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(trashedAt),
      purgeAt:
          purgeAt == null && nullToAbsent
              ? const Value.absent()
              : Value(purgeAt),
      lifecycleRevision: Value(lifecycleRevision),
      lifecycleUpdatedAt:
          lifecycleUpdatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lifecycleUpdatedAt),
    );
  }

  factory TaskValueBundle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskValueBundle(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      trashedAt: serializer.fromJson<DateTime?>(json['trashedAt']),
      purgeAt: serializer.fromJson<DateTime?>(json['purgeAt']),
      lifecycleRevision: serializer.fromJson<int>(json['lifecycleRevision']),
      lifecycleUpdatedAt: serializer.fromJson<DateTime?>(
        json['lifecycleUpdatedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'projectId': serializer.toJson<String?>(projectId),
      'isActive': serializer.toJson<bool>(isActive),
      'trashedAt': serializer.toJson<DateTime?>(trashedAt),
      'purgeAt': serializer.toJson<DateTime?>(purgeAt),
      'lifecycleRevision': serializer.toJson<int>(lifecycleRevision),
      'lifecycleUpdatedAt': serializer.toJson<DateTime?>(lifecycleUpdatedAt),
    };
  }

  TaskValueBundle copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> projectId = const Value.absent(),
    bool? isActive,
    Value<DateTime?> trashedAt = const Value.absent(),
    Value<DateTime?> purgeAt = const Value.absent(),
    int? lifecycleRevision,
    Value<DateTime?> lifecycleUpdatedAt = const Value.absent(),
  }) => TaskValueBundle(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    projectId: projectId.present ? projectId.value : this.projectId,
    isActive: isActive ?? this.isActive,
    trashedAt: trashedAt.present ? trashedAt.value : this.trashedAt,
    purgeAt: purgeAt.present ? purgeAt.value : this.purgeAt,
    lifecycleRevision: lifecycleRevision ?? this.lifecycleRevision,
    lifecycleUpdatedAt:
        lifecycleUpdatedAt.present
            ? lifecycleUpdatedAt.value
            : this.lifecycleUpdatedAt,
  );
  TaskValueBundle copyWithCompanion(TaskValueBundlesCompanion data) {
    return TaskValueBundle(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      purgeAt: data.purgeAt.present ? data.purgeAt.value : this.purgeAt,
      lifecycleRevision:
          data.lifecycleRevision.present
              ? data.lifecycleRevision.value
              : this.lifecycleRevision,
      lifecycleUpdatedAt:
          data.lifecycleUpdatedAt.present
              ? data.lifecycleUpdatedAt.value
              : this.lifecycleUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskValueBundle(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('isActive: $isActive, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('purgeAt: $purgeAt, ')
          ..write('lifecycleRevision: $lifecycleRevision, ')
          ..write('lifecycleUpdatedAt: $lifecycleUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    projectId,
    isActive,
    trashedAt,
    purgeAt,
    lifecycleRevision,
    lifecycleUpdatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskValueBundle &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.projectId == this.projectId &&
          other.isActive == this.isActive &&
          other.trashedAt == this.trashedAt &&
          other.purgeAt == this.purgeAt &&
          other.lifecycleRevision == this.lifecycleRevision &&
          other.lifecycleUpdatedAt == this.lifecycleUpdatedAt);
}

class TaskValueBundlesCompanion extends UpdateCompanion<TaskValueBundle> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> projectId;
  final Value<bool> isActive;
  final Value<DateTime?> trashedAt;
  final Value<DateTime?> purgeAt;
  final Value<int> lifecycleRevision;
  final Value<DateTime?> lifecycleUpdatedAt;
  final Value<int> rowid;
  const TaskValueBundlesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.projectId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.purgeAt = const Value.absent(),
    this.lifecycleRevision = const Value.absent(),
    this.lifecycleUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskValueBundlesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    required DateTime updatedAt,
    this.projectId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.purgeAt = const Value.absent(),
    this.lifecycleRevision = const Value.absent(),
    this.lifecycleUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<TaskValueBundle> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? projectId,
    Expression<bool>? isActive,
    Expression<DateTime>? trashedAt,
    Expression<DateTime>? purgeAt,
    Expression<int>? lifecycleRevision,
    Expression<DateTime>? lifecycleUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (projectId != null) 'project_id': projectId,
      if (isActive != null) 'is_active': isActive,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (purgeAt != null) 'purge_at': purgeAt,
      if (lifecycleRevision != null) 'lifecycle_revision': lifecycleRevision,
      if (lifecycleUpdatedAt != null)
        'lifecycle_updated_at': lifecycleUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskValueBundlesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? projectId,
    Value<bool>? isActive,
    Value<DateTime?>? trashedAt,
    Value<DateTime?>? purgeAt,
    Value<int>? lifecycleRevision,
    Value<DateTime?>? lifecycleUpdatedAt,
    Value<int>? rowid,
  }) {
    return TaskValueBundlesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectId: projectId ?? this.projectId,
      isActive: isActive ?? this.isActive,
      trashedAt: trashedAt ?? this.trashedAt,
      purgeAt: purgeAt ?? this.purgeAt,
      lifecycleRevision: lifecycleRevision ?? this.lifecycleRevision,
      lifecycleUpdatedAt: lifecycleUpdatedAt ?? this.lifecycleUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<DateTime>(trashedAt.value);
    }
    if (purgeAt.present) {
      map['purge_at'] = Variable<DateTime>(purgeAt.value);
    }
    if (lifecycleRevision.present) {
      map['lifecycle_revision'] = Variable<int>(lifecycleRevision.value);
    }
    if (lifecycleUpdatedAt.present) {
      map['lifecycle_updated_at'] = Variable<DateTime>(
        lifecycleUpdatedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskValueBundlesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('projectId: $projectId, ')
          ..write('isActive: $isActive, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('purgeAt: $purgeAt, ')
          ..write('lifecycleRevision: $lifecycleRevision, ')
          ..write('lifecycleUpdatedAt: $lifecycleUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskValueBundleVersionsTable extends TaskValueBundleVersions
    with TableInfo<$TaskValueBundleVersionsTable, TaskValueBundleVersion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskValueBundleVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bundleIdMeta = const VerificationMeta(
    'bundleId',
  );
  @override
  late final GeneratedColumn<String> bundleId = GeneratedColumn<String>(
    'bundle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_value_bundles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _versionNumberMeta = const VerificationMeta(
    'versionNumber',
  );
  @override
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>(
    'version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousVersionIdMeta = const VerificationMeta(
    'previousVersionId',
  );
  @override
  late final GeneratedColumn<String> previousVersionId =
      GeneratedColumn<String>(
        'previous_version_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validToMeta = const VerificationMeta(
    'validTo',
  );
  @override
  late final GeneratedColumn<DateTime> validTo = GeneratedColumn<DateTime>(
    'valid_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _bundleTypeMeta = const VerificationMeta(
    'bundleType',
  );
  @override
  late final GeneratedColumn<String> bundleType = GeneratedColumn<String>(
    'bundle_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstTaskIdMeta = const VerificationMeta(
    'firstTaskId',
  );
  @override
  late final GeneratedColumn<String> firstTaskId = GeneratedColumn<String>(
    'first_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secondTaskIdMeta = const VerificationMeta(
    'secondTaskId',
  );
  @override
  late final GeneratedColumn<String> secondTaskId = GeneratedColumn<String>(
    'second_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstRoleLabelMeta = const VerificationMeta(
    'firstRoleLabel',
  );
  @override
  late final GeneratedColumn<String> firstRoleLabel = GeneratedColumn<String>(
    'first_role_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _secondRoleLabelMeta = const VerificationMeta(
    'secondRoleLabel',
  );
  @override
  late final GeneratedColumn<String> secondRoleLabel = GeneratedColumn<String>(
    'second_role_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _resultLabelMeta = const VerificationMeta(
    'resultLabel',
  );
  @override
  late final GeneratedColumn<String> resultLabel = GeneratedColumn<String>(
    'result_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('first_minus_second'),
  );
  static const VerificationMeta _displayModeMeta = const VerificationMeta(
    'displayMode',
  );
  @override
  late final GeneratedColumn<String> displayMode = GeneratedColumn<String>(
    'display_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('combined_card'),
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskGoalType.none),
  );
  static const VerificationMeta _goalValueMeta = const VerificationMeta(
    'goalValue',
  );
  @override
  late final GeneratedColumn<int> goalValue = GeneratedColumn<int>(
    'goal_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _goalWindowDaysMeta = const VerificationMeta(
    'goalWindowDays',
  );
  @override
  late final GeneratedColumn<int> goalWindowDays = GeneratedColumn<int>(
    'goal_window_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstTaskDayOffsetMeta =
      const VerificationMeta('firstTaskDayOffset');
  @override
  late final GeneratedColumn<int> firstTaskDayOffset = GeneratedColumn<int>(
    'first_task_day_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _secondTaskDayOffsetMeta =
      const VerificationMeta('secondTaskDayOffset');
  @override
  late final GeneratedColumn<int> secondTaskDayOffset = GeneratedColumn<int>(
    'second_task_day_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bundleId,
    versionNumber,
    previousVersionId,
    validFrom,
    validTo,
    cancelledAt,
    createdAt,
    updatedAt,
    name,
    description,
    bundleType,
    firstTaskId,
    secondTaskId,
    firstRoleLabel,
    secondRoleLabel,
    resultLabel,
    direction,
    displayMode,
    goalType,
    goalValue,
    goalWindowDays,
    firstTaskDayOffset,
    secondTaskDayOffset,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_value_bundle_versions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskValueBundleVersion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bundle_id')) {
      context.handle(
        _bundleIdMeta,
        bundleId.isAcceptableOrUnknown(data['bundle_id']!, _bundleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bundleIdMeta);
    }
    if (data.containsKey('version_number')) {
      context.handle(
        _versionNumberMeta,
        versionNumber.isAcceptableOrUnknown(
          data['version_number']!,
          _versionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionNumberMeta);
    }
    if (data.containsKey('previous_version_id')) {
      context.handle(
        _previousVersionIdMeta,
        previousVersionId.isAcceptableOrUnknown(
          data['previous_version_id']!,
          _previousVersionIdMeta,
        ),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_to')) {
      context.handle(
        _validToMeta,
        validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
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
    if (data.containsKey('bundle_type')) {
      context.handle(
        _bundleTypeMeta,
        bundleType.isAcceptableOrUnknown(data['bundle_type']!, _bundleTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_bundleTypeMeta);
    }
    if (data.containsKey('first_task_id')) {
      context.handle(
        _firstTaskIdMeta,
        firstTaskId.isAcceptableOrUnknown(
          data['first_task_id']!,
          _firstTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstTaskIdMeta);
    }
    if (data.containsKey('second_task_id')) {
      context.handle(
        _secondTaskIdMeta,
        secondTaskId.isAcceptableOrUnknown(
          data['second_task_id']!,
          _secondTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secondTaskIdMeta);
    }
    if (data.containsKey('first_role_label')) {
      context.handle(
        _firstRoleLabelMeta,
        firstRoleLabel.isAcceptableOrUnknown(
          data['first_role_label']!,
          _firstRoleLabelMeta,
        ),
      );
    }
    if (data.containsKey('second_role_label')) {
      context.handle(
        _secondRoleLabelMeta,
        secondRoleLabel.isAcceptableOrUnknown(
          data['second_role_label']!,
          _secondRoleLabelMeta,
        ),
      );
    }
    if (data.containsKey('result_label')) {
      context.handle(
        _resultLabelMeta,
        resultLabel.isAcceptableOrUnknown(
          data['result_label']!,
          _resultLabelMeta,
        ),
      );
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    }
    if (data.containsKey('display_mode')) {
      context.handle(
        _displayModeMeta,
        displayMode.isAcceptableOrUnknown(
          data['display_mode']!,
          _displayModeMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('goal_value')) {
      context.handle(
        _goalValueMeta,
        goalValue.isAcceptableOrUnknown(data['goal_value']!, _goalValueMeta),
      );
    }
    if (data.containsKey('goal_window_days')) {
      context.handle(
        _goalWindowDaysMeta,
        goalWindowDays.isAcceptableOrUnknown(
          data['goal_window_days']!,
          _goalWindowDaysMeta,
        ),
      );
    }
    if (data.containsKey('first_task_day_offset')) {
      context.handle(
        _firstTaskDayOffsetMeta,
        firstTaskDayOffset.isAcceptableOrUnknown(
          data['first_task_day_offset']!,
          _firstTaskDayOffsetMeta,
        ),
      );
    }
    if (data.containsKey('second_task_day_offset')) {
      context.handle(
        _secondTaskDayOffsetMeta,
        secondTaskDayOffset.isAcceptableOrUnknown(
          data['second_task_day_offset']!,
          _secondTaskDayOffsetMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {bundleId, versionNumber},
  ];
  @override
  TaskValueBundleVersion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskValueBundleVersion(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      bundleId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bundle_id'],
          )!,
      versionNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}version_number'],
          )!,
      previousVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_version_id'],
      ),
      validFrom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}valid_from'],
          )!,
      validTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_to'],
      ),
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      bundleType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bundle_type'],
          )!,
      firstTaskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}first_task_id'],
          )!,
      secondTaskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}second_task_id'],
          )!,
      firstRoleLabel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}first_role_label'],
          )!,
      secondRoleLabel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}second_role_label'],
          )!,
      resultLabel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}result_label'],
          )!,
      direction:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}direction'],
          )!,
      displayMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}display_mode'],
          )!,
      goalType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}goal_type'],
          )!,
      goalValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}goal_value'],
          )!,
      goalWindowDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_window_days'],
      ),
      firstTaskDayOffset:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}first_task_day_offset'],
          )!,
      secondTaskDayOffset:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}second_task_day_offset'],
          )!,
    );
  }

  @override
  $TaskValueBundleVersionsTable createAlias(String alias) {
    return $TaskValueBundleVersionsTable(attachedDatabase, alias);
  }
}

class TaskValueBundleVersion extends DataClass
    implements Insertable<TaskValueBundleVersion> {
  final String id;
  final String bundleId;
  final int versionNumber;
  final String? previousVersionId;
  final DateTime validFrom;
  final DateTime? validTo;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String name;
  final String description;
  final String bundleType;
  final String firstTaskId;
  final String secondTaskId;
  final String firstRoleLabel;
  final String secondRoleLabel;
  final String resultLabel;
  final String direction;
  final String displayMode;
  final String goalType;
  final int goalValue;
  final int? goalWindowDays;
  final int firstTaskDayOffset;
  final int secondTaskDayOffset;
  const TaskValueBundleVersion({
    required this.id,
    required this.bundleId,
    required this.versionNumber,
    this.previousVersionId,
    required this.validFrom,
    this.validTo,
    this.cancelledAt,
    required this.createdAt,
    this.updatedAt,
    required this.name,
    required this.description,
    required this.bundleType,
    required this.firstTaskId,
    required this.secondTaskId,
    required this.firstRoleLabel,
    required this.secondRoleLabel,
    required this.resultLabel,
    required this.direction,
    required this.displayMode,
    required this.goalType,
    required this.goalValue,
    this.goalWindowDays,
    required this.firstTaskDayOffset,
    required this.secondTaskDayOffset,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bundle_id'] = Variable<String>(bundleId);
    map['version_number'] = Variable<int>(versionNumber);
    if (!nullToAbsent || previousVersionId != null) {
      map['previous_version_id'] = Variable<String>(previousVersionId);
    }
    map['valid_from'] = Variable<DateTime>(validFrom);
    if (!nullToAbsent || validTo != null) {
      map['valid_to'] = Variable<DateTime>(validTo);
    }
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['bundle_type'] = Variable<String>(bundleType);
    map['first_task_id'] = Variable<String>(firstTaskId);
    map['second_task_id'] = Variable<String>(secondTaskId);
    map['first_role_label'] = Variable<String>(firstRoleLabel);
    map['second_role_label'] = Variable<String>(secondRoleLabel);
    map['result_label'] = Variable<String>(resultLabel);
    map['direction'] = Variable<String>(direction);
    map['display_mode'] = Variable<String>(displayMode);
    map['goal_type'] = Variable<String>(goalType);
    map['goal_value'] = Variable<int>(goalValue);
    if (!nullToAbsent || goalWindowDays != null) {
      map['goal_window_days'] = Variable<int>(goalWindowDays);
    }
    map['first_task_day_offset'] = Variable<int>(firstTaskDayOffset);
    map['second_task_day_offset'] = Variable<int>(secondTaskDayOffset);
    return map;
  }

  TaskValueBundleVersionsCompanion toCompanion(bool nullToAbsent) {
    return TaskValueBundleVersionsCompanion(
      id: Value(id),
      bundleId: Value(bundleId),
      versionNumber: Value(versionNumber),
      previousVersionId:
          previousVersionId == null && nullToAbsent
              ? const Value.absent()
              : Value(previousVersionId),
      validFrom: Value(validFrom),
      validTo:
          validTo == null && nullToAbsent
              ? const Value.absent()
              : Value(validTo),
      cancelledAt:
          cancelledAt == null && nullToAbsent
              ? const Value.absent()
              : Value(cancelledAt),
      createdAt: Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
      name: Value(name),
      description: Value(description),
      bundleType: Value(bundleType),
      firstTaskId: Value(firstTaskId),
      secondTaskId: Value(secondTaskId),
      firstRoleLabel: Value(firstRoleLabel),
      secondRoleLabel: Value(secondRoleLabel),
      resultLabel: Value(resultLabel),
      direction: Value(direction),
      displayMode: Value(displayMode),
      goalType: Value(goalType),
      goalValue: Value(goalValue),
      goalWindowDays:
          goalWindowDays == null && nullToAbsent
              ? const Value.absent()
              : Value(goalWindowDays),
      firstTaskDayOffset: Value(firstTaskDayOffset),
      secondTaskDayOffset: Value(secondTaskDayOffset),
    );
  }

  factory TaskValueBundleVersion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskValueBundleVersion(
      id: serializer.fromJson<String>(json['id']),
      bundleId: serializer.fromJson<String>(json['bundleId']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      previousVersionId: serializer.fromJson<String?>(
        json['previousVersionId'],
      ),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      validTo: serializer.fromJson<DateTime?>(json['validTo']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      bundleType: serializer.fromJson<String>(json['bundleType']),
      firstTaskId: serializer.fromJson<String>(json['firstTaskId']),
      secondTaskId: serializer.fromJson<String>(json['secondTaskId']),
      firstRoleLabel: serializer.fromJson<String>(json['firstRoleLabel']),
      secondRoleLabel: serializer.fromJson<String>(json['secondRoleLabel']),
      resultLabel: serializer.fromJson<String>(json['resultLabel']),
      direction: serializer.fromJson<String>(json['direction']),
      displayMode: serializer.fromJson<String>(json['displayMode']),
      goalType: serializer.fromJson<String>(json['goalType']),
      goalValue: serializer.fromJson<int>(json['goalValue']),
      goalWindowDays: serializer.fromJson<int?>(json['goalWindowDays']),
      firstTaskDayOffset: serializer.fromJson<int>(json['firstTaskDayOffset']),
      secondTaskDayOffset: serializer.fromJson<int>(
        json['secondTaskDayOffset'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bundleId': serializer.toJson<String>(bundleId),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'previousVersionId': serializer.toJson<String?>(previousVersionId),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'validTo': serializer.toJson<DateTime?>(validTo),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'bundleType': serializer.toJson<String>(bundleType),
      'firstTaskId': serializer.toJson<String>(firstTaskId),
      'secondTaskId': serializer.toJson<String>(secondTaskId),
      'firstRoleLabel': serializer.toJson<String>(firstRoleLabel),
      'secondRoleLabel': serializer.toJson<String>(secondRoleLabel),
      'resultLabel': serializer.toJson<String>(resultLabel),
      'direction': serializer.toJson<String>(direction),
      'displayMode': serializer.toJson<String>(displayMode),
      'goalType': serializer.toJson<String>(goalType),
      'goalValue': serializer.toJson<int>(goalValue),
      'goalWindowDays': serializer.toJson<int?>(goalWindowDays),
      'firstTaskDayOffset': serializer.toJson<int>(firstTaskDayOffset),
      'secondTaskDayOffset': serializer.toJson<int>(secondTaskDayOffset),
    };
  }

  TaskValueBundleVersion copyWith({
    String? id,
    String? bundleId,
    int? versionNumber,
    Value<String?> previousVersionId = const Value.absent(),
    DateTime? validFrom,
    Value<DateTime?> validTo = const Value.absent(),
    Value<DateTime?> cancelledAt = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    String? name,
    String? description,
    String? bundleType,
    String? firstTaskId,
    String? secondTaskId,
    String? firstRoleLabel,
    String? secondRoleLabel,
    String? resultLabel,
    String? direction,
    String? displayMode,
    String? goalType,
    int? goalValue,
    Value<int?> goalWindowDays = const Value.absent(),
    int? firstTaskDayOffset,
    int? secondTaskDayOffset,
  }) => TaskValueBundleVersion(
    id: id ?? this.id,
    bundleId: bundleId ?? this.bundleId,
    versionNumber: versionNumber ?? this.versionNumber,
    previousVersionId:
        previousVersionId.present
            ? previousVersionId.value
            : this.previousVersionId,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo.present ? validTo.value : this.validTo,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    name: name ?? this.name,
    description: description ?? this.description,
    bundleType: bundleType ?? this.bundleType,
    firstTaskId: firstTaskId ?? this.firstTaskId,
    secondTaskId: secondTaskId ?? this.secondTaskId,
    firstRoleLabel: firstRoleLabel ?? this.firstRoleLabel,
    secondRoleLabel: secondRoleLabel ?? this.secondRoleLabel,
    resultLabel: resultLabel ?? this.resultLabel,
    direction: direction ?? this.direction,
    displayMode: displayMode ?? this.displayMode,
    goalType: goalType ?? this.goalType,
    goalValue: goalValue ?? this.goalValue,
    goalWindowDays:
        goalWindowDays.present ? goalWindowDays.value : this.goalWindowDays,
    firstTaskDayOffset: firstTaskDayOffset ?? this.firstTaskDayOffset,
    secondTaskDayOffset: secondTaskDayOffset ?? this.secondTaskDayOffset,
  );
  TaskValueBundleVersion copyWithCompanion(
    TaskValueBundleVersionsCompanion data,
  ) {
    return TaskValueBundleVersion(
      id: data.id.present ? data.id.value : this.id,
      bundleId: data.bundleId.present ? data.bundleId.value : this.bundleId,
      versionNumber:
          data.versionNumber.present
              ? data.versionNumber.value
              : this.versionNumber,
      previousVersionId:
          data.previousVersionId.present
              ? data.previousVersionId.value
              : this.previousVersionId,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      cancelledAt:
          data.cancelledAt.present ? data.cancelledAt.value : this.cancelledAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      bundleType:
          data.bundleType.present ? data.bundleType.value : this.bundleType,
      firstTaskId:
          data.firstTaskId.present ? data.firstTaskId.value : this.firstTaskId,
      secondTaskId:
          data.secondTaskId.present
              ? data.secondTaskId.value
              : this.secondTaskId,
      firstRoleLabel:
          data.firstRoleLabel.present
              ? data.firstRoleLabel.value
              : this.firstRoleLabel,
      secondRoleLabel:
          data.secondRoleLabel.present
              ? data.secondRoleLabel.value
              : this.secondRoleLabel,
      resultLabel:
          data.resultLabel.present ? data.resultLabel.value : this.resultLabel,
      direction: data.direction.present ? data.direction.value : this.direction,
      displayMode:
          data.displayMode.present ? data.displayMode.value : this.displayMode,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      goalValue: data.goalValue.present ? data.goalValue.value : this.goalValue,
      goalWindowDays:
          data.goalWindowDays.present
              ? data.goalWindowDays.value
              : this.goalWindowDays,
      firstTaskDayOffset:
          data.firstTaskDayOffset.present
              ? data.firstTaskDayOffset.value
              : this.firstTaskDayOffset,
      secondTaskDayOffset:
          data.secondTaskDayOffset.present
              ? data.secondTaskDayOffset.value
              : this.secondTaskDayOffset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskValueBundleVersion(')
          ..write('id: $id, ')
          ..write('bundleId: $bundleId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('bundleType: $bundleType, ')
          ..write('firstTaskId: $firstTaskId, ')
          ..write('secondTaskId: $secondTaskId, ')
          ..write('firstRoleLabel: $firstRoleLabel, ')
          ..write('secondRoleLabel: $secondRoleLabel, ')
          ..write('resultLabel: $resultLabel, ')
          ..write('direction: $direction, ')
          ..write('displayMode: $displayMode, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('goalWindowDays: $goalWindowDays, ')
          ..write('firstTaskDayOffset: $firstTaskDayOffset, ')
          ..write('secondTaskDayOffset: $secondTaskDayOffset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    bundleId,
    versionNumber,
    previousVersionId,
    validFrom,
    validTo,
    cancelledAt,
    createdAt,
    updatedAt,
    name,
    description,
    bundleType,
    firstTaskId,
    secondTaskId,
    firstRoleLabel,
    secondRoleLabel,
    resultLabel,
    direction,
    displayMode,
    goalType,
    goalValue,
    goalWindowDays,
    firstTaskDayOffset,
    secondTaskDayOffset,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskValueBundleVersion &&
          other.id == this.id &&
          other.bundleId == this.bundleId &&
          other.versionNumber == this.versionNumber &&
          other.previousVersionId == this.previousVersionId &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.cancelledAt == this.cancelledAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.name == this.name &&
          other.description == this.description &&
          other.bundleType == this.bundleType &&
          other.firstTaskId == this.firstTaskId &&
          other.secondTaskId == this.secondTaskId &&
          other.firstRoleLabel == this.firstRoleLabel &&
          other.secondRoleLabel == this.secondRoleLabel &&
          other.resultLabel == this.resultLabel &&
          other.direction == this.direction &&
          other.displayMode == this.displayMode &&
          other.goalType == this.goalType &&
          other.goalValue == this.goalValue &&
          other.goalWindowDays == this.goalWindowDays &&
          other.firstTaskDayOffset == this.firstTaskDayOffset &&
          other.secondTaskDayOffset == this.secondTaskDayOffset);
}

class TaskValueBundleVersionsCompanion
    extends UpdateCompanion<TaskValueBundleVersion> {
  final Value<String> id;
  final Value<String> bundleId;
  final Value<int> versionNumber;
  final Value<String?> previousVersionId;
  final Value<DateTime> validFrom;
  final Value<DateTime?> validTo;
  final Value<DateTime?> cancelledAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<String> name;
  final Value<String> description;
  final Value<String> bundleType;
  final Value<String> firstTaskId;
  final Value<String> secondTaskId;
  final Value<String> firstRoleLabel;
  final Value<String> secondRoleLabel;
  final Value<String> resultLabel;
  final Value<String> direction;
  final Value<String> displayMode;
  final Value<String> goalType;
  final Value<int> goalValue;
  final Value<int?> goalWindowDays;
  final Value<int> firstTaskDayOffset;
  final Value<int> secondTaskDayOffset;
  final Value<int> rowid;
  const TaskValueBundleVersionsCompanion({
    this.id = const Value.absent(),
    this.bundleId = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.previousVersionId = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.bundleType = const Value.absent(),
    this.firstTaskId = const Value.absent(),
    this.secondTaskId = const Value.absent(),
    this.firstRoleLabel = const Value.absent(),
    this.secondRoleLabel = const Value.absent(),
    this.resultLabel = const Value.absent(),
    this.direction = const Value.absent(),
    this.displayMode = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.goalWindowDays = const Value.absent(),
    this.firstTaskDayOffset = const Value.absent(),
    this.secondTaskDayOffset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskValueBundleVersionsCompanion.insert({
    required String id,
    required String bundleId,
    required int versionNumber,
    this.previousVersionId = const Value.absent(),
    required DateTime validFrom,
    this.validTo = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    required String bundleType,
    required String firstTaskId,
    required String secondTaskId,
    this.firstRoleLabel = const Value.absent(),
    this.secondRoleLabel = const Value.absent(),
    this.resultLabel = const Value.absent(),
    this.direction = const Value.absent(),
    this.displayMode = const Value.absent(),
    this.goalType = const Value.absent(),
    this.goalValue = const Value.absent(),
    this.goalWindowDays = const Value.absent(),
    this.firstTaskDayOffset = const Value.absent(),
    this.secondTaskDayOffset = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bundleId = Value(bundleId),
       versionNumber = Value(versionNumber),
       validFrom = Value(validFrom),
       bundleType = Value(bundleType),
       firstTaskId = Value(firstTaskId),
       secondTaskId = Value(secondTaskId);
  static Insertable<TaskValueBundleVersion> custom({
    Expression<String>? id,
    Expression<String>? bundleId,
    Expression<int>? versionNumber,
    Expression<String>? previousVersionId,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validTo,
    Expression<DateTime>? cancelledAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? bundleType,
    Expression<String>? firstTaskId,
    Expression<String>? secondTaskId,
    Expression<String>? firstRoleLabel,
    Expression<String>? secondRoleLabel,
    Expression<String>? resultLabel,
    Expression<String>? direction,
    Expression<String>? displayMode,
    Expression<String>? goalType,
    Expression<int>? goalValue,
    Expression<int>? goalWindowDays,
    Expression<int>? firstTaskDayOffset,
    Expression<int>? secondTaskDayOffset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bundleId != null) 'bundle_id': bundleId,
      if (versionNumber != null) 'version_number': versionNumber,
      if (previousVersionId != null) 'previous_version_id': previousVersionId,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (bundleType != null) 'bundle_type': bundleType,
      if (firstTaskId != null) 'first_task_id': firstTaskId,
      if (secondTaskId != null) 'second_task_id': secondTaskId,
      if (firstRoleLabel != null) 'first_role_label': firstRoleLabel,
      if (secondRoleLabel != null) 'second_role_label': secondRoleLabel,
      if (resultLabel != null) 'result_label': resultLabel,
      if (direction != null) 'direction': direction,
      if (displayMode != null) 'display_mode': displayMode,
      if (goalType != null) 'goal_type': goalType,
      if (goalValue != null) 'goal_value': goalValue,
      if (goalWindowDays != null) 'goal_window_days': goalWindowDays,
      if (firstTaskDayOffset != null)
        'first_task_day_offset': firstTaskDayOffset,
      if (secondTaskDayOffset != null)
        'second_task_day_offset': secondTaskDayOffset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskValueBundleVersionsCompanion copyWith({
    Value<String>? id,
    Value<String>? bundleId,
    Value<int>? versionNumber,
    Value<String?>? previousVersionId,
    Value<DateTime>? validFrom,
    Value<DateTime?>? validTo,
    Value<DateTime?>? cancelledAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<String>? name,
    Value<String>? description,
    Value<String>? bundleType,
    Value<String>? firstTaskId,
    Value<String>? secondTaskId,
    Value<String>? firstRoleLabel,
    Value<String>? secondRoleLabel,
    Value<String>? resultLabel,
    Value<String>? direction,
    Value<String>? displayMode,
    Value<String>? goalType,
    Value<int>? goalValue,
    Value<int?>? goalWindowDays,
    Value<int>? firstTaskDayOffset,
    Value<int>? secondTaskDayOffset,
    Value<int>? rowid,
  }) {
    return TaskValueBundleVersionsCompanion(
      id: id ?? this.id,
      bundleId: bundleId ?? this.bundleId,
      versionNumber: versionNumber ?? this.versionNumber,
      previousVersionId: previousVersionId ?? this.previousVersionId,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      bundleType: bundleType ?? this.bundleType,
      firstTaskId: firstTaskId ?? this.firstTaskId,
      secondTaskId: secondTaskId ?? this.secondTaskId,
      firstRoleLabel: firstRoleLabel ?? this.firstRoleLabel,
      secondRoleLabel: secondRoleLabel ?? this.secondRoleLabel,
      resultLabel: resultLabel ?? this.resultLabel,
      direction: direction ?? this.direction,
      displayMode: displayMode ?? this.displayMode,
      goalType: goalType ?? this.goalType,
      goalValue: goalValue ?? this.goalValue,
      goalWindowDays: goalWindowDays ?? this.goalWindowDays,
      firstTaskDayOffset: firstTaskDayOffset ?? this.firstTaskDayOffset,
      secondTaskDayOffset: secondTaskDayOffset ?? this.secondTaskDayOffset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bundleId.present) {
      map['bundle_id'] = Variable<String>(bundleId.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (previousVersionId.present) {
      map['previous_version_id'] = Variable<String>(previousVersionId.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<DateTime>(validTo.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (bundleType.present) {
      map['bundle_type'] = Variable<String>(bundleType.value);
    }
    if (firstTaskId.present) {
      map['first_task_id'] = Variable<String>(firstTaskId.value);
    }
    if (secondTaskId.present) {
      map['second_task_id'] = Variable<String>(secondTaskId.value);
    }
    if (firstRoleLabel.present) {
      map['first_role_label'] = Variable<String>(firstRoleLabel.value);
    }
    if (secondRoleLabel.present) {
      map['second_role_label'] = Variable<String>(secondRoleLabel.value);
    }
    if (resultLabel.present) {
      map['result_label'] = Variable<String>(resultLabel.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (displayMode.present) {
      map['display_mode'] = Variable<String>(displayMode.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (goalValue.present) {
      map['goal_value'] = Variable<int>(goalValue.value);
    }
    if (goalWindowDays.present) {
      map['goal_window_days'] = Variable<int>(goalWindowDays.value);
    }
    if (firstTaskDayOffset.present) {
      map['first_task_day_offset'] = Variable<int>(firstTaskDayOffset.value);
    }
    if (secondTaskDayOffset.present) {
      map['second_task_day_offset'] = Variable<int>(secondTaskDayOffset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskValueBundleVersionsCompanion(')
          ..write('id: $id, ')
          ..write('bundleId: $bundleId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('previousVersionId: $previousVersionId, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('bundleType: $bundleType, ')
          ..write('firstTaskId: $firstTaskId, ')
          ..write('secondTaskId: $secondTaskId, ')
          ..write('firstRoleLabel: $firstRoleLabel, ')
          ..write('secondRoleLabel: $secondRoleLabel, ')
          ..write('resultLabel: $resultLabel, ')
          ..write('direction: $direction, ')
          ..write('displayMode: $displayMode, ')
          ..write('goalType: $goalType, ')
          ..write('goalValue: $goalValue, ')
          ..write('goalWindowDays: $goalWindowDays, ')
          ..write('firstTaskDayOffset: $firstTaskDayOffset, ')
          ..write('secondTaskDayOffset: $secondTaskDayOffset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCardMetricPreferencesTable extends TaskCardMetricPreferences
    with TableInfo<$TaskCardMetricPreferencesTable, TaskCardMetricPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCardMetricPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bundleIdMeta = const VerificationMeta(
    'bundleId',
  );
  @override
  late final GeneratedColumn<String> bundleId = GeneratedColumn<String>(
    'bundle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_value_bundles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isResetMeta = const VerificationMeta(
    'isReset',
  );
  @override
  late final GeneratedColumn<bool> isReset = GeneratedColumn<bool>(
    'is_reset',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reset" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    bundleId,
    configJson,
    isReset,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_card_metric_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCardMetricPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('bundle_id')) {
      context.handle(
        _bundleIdMeta,
        bundleId.isAcceptableOrUnknown(data['bundle_id']!, _bundleIdMeta),
      );
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('is_reset')) {
      context.handle(
        _isResetMeta,
        isReset.isAcceptableOrUnknown(data['is_reset']!, _isResetMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {taskId},
    {bundleId},
  ];
  @override
  TaskCardMetricPreference map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCardMetricPreference(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      bundleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bundle_id'],
      ),
      configJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}config_json'],
          )!,
      isReset:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_reset'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TaskCardMetricPreferencesTable createAlias(String alias) {
    return $TaskCardMetricPreferencesTable(attachedDatabase, alias);
  }
}

class TaskCardMetricPreference extends DataClass
    implements Insertable<TaskCardMetricPreference> {
  final String id;
  final String? taskId;
  final String? bundleId;
  final String configJson;
  final bool isReset;
  final DateTime updatedAt;
  const TaskCardMetricPreference({
    required this.id,
    this.taskId,
    this.bundleId,
    required this.configJson,
    required this.isReset,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || bundleId != null) {
      map['bundle_id'] = Variable<String>(bundleId);
    }
    map['config_json'] = Variable<String>(configJson);
    map['is_reset'] = Variable<bool>(isReset);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskCardMetricPreferencesCompanion toCompanion(bool nullToAbsent) {
    return TaskCardMetricPreferencesCompanion(
      id: Value(id),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      bundleId:
          bundleId == null && nullToAbsent
              ? const Value.absent()
              : Value(bundleId),
      configJson: Value(configJson),
      isReset: Value(isReset),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskCardMetricPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCardMetricPreference(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      bundleId: serializer.fromJson<String?>(json['bundleId']),
      configJson: serializer.fromJson<String>(json['configJson']),
      isReset: serializer.fromJson<bool>(json['isReset']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'bundleId': serializer.toJson<String?>(bundleId),
      'configJson': serializer.toJson<String>(configJson),
      'isReset': serializer.toJson<bool>(isReset),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskCardMetricPreference copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    Value<String?> bundleId = const Value.absent(),
    String? configJson,
    bool? isReset,
    DateTime? updatedAt,
  }) => TaskCardMetricPreference(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    bundleId: bundleId.present ? bundleId.value : this.bundleId,
    configJson: configJson ?? this.configJson,
    isReset: isReset ?? this.isReset,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskCardMetricPreference copyWithCompanion(
    TaskCardMetricPreferencesCompanion data,
  ) {
    return TaskCardMetricPreference(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      bundleId: data.bundleId.present ? data.bundleId.value : this.bundleId,
      configJson:
          data.configJson.present ? data.configJson.value : this.configJson,
      isReset: data.isReset.present ? data.isReset.value : this.isReset,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCardMetricPreference(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('bundleId: $bundleId, ')
          ..write('configJson: $configJson, ')
          ..write('isReset: $isReset, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, taskId, bundleId, configJson, isReset, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCardMetricPreference &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.bundleId == this.bundleId &&
          other.configJson == this.configJson &&
          other.isReset == this.isReset &&
          other.updatedAt == this.updatedAt);
}

class TaskCardMetricPreferencesCompanion
    extends UpdateCompanion<TaskCardMetricPreference> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String?> bundleId;
  final Value<String> configJson;
  final Value<bool> isReset;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskCardMetricPreferencesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.bundleId = const Value.absent(),
    this.configJson = const Value.absent(),
    this.isReset = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCardMetricPreferencesCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    this.bundleId = const Value.absent(),
    required String configJson,
    this.isReset = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       configJson = Value(configJson),
       updatedAt = Value(updatedAt);
  static Insertable<TaskCardMetricPreference> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? bundleId,
    Expression<String>? configJson,
    Expression<bool>? isReset,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (bundleId != null) 'bundle_id': bundleId,
      if (configJson != null) 'config_json': configJson,
      if (isReset != null) 'is_reset': isReset,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCardMetricPreferencesCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<String?>? bundleId,
    Value<String>? configJson,
    Value<bool>? isReset,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskCardMetricPreferencesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      bundleId: bundleId ?? this.bundleId,
      configJson: configJson ?? this.configJson,
      isReset: isReset ?? this.isReset,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (bundleId.present) {
      map['bundle_id'] = Variable<String>(bundleId.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (isReset.present) {
      map['is_reset'] = Variable<bool>(isReset.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCardMetricPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('bundleId: $bundleId, ')
          ..write('configJson: $configJson, ')
          ..write('isReset: $isReset, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskPendingDefinitionChangesTable extends TaskPendingDefinitionChanges
    with
        TableInfo<
          $TaskPendingDefinitionChangesTable,
          TaskPendingDefinitionChange
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskPendingDefinitionChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _groupKeyMeta = const VerificationMeta(
    'groupKey',
  );
  @override
  late final GeneratedColumn<String> groupKey = GeneratedColumn<String>(
    'group_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>(
        'effective_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskPendingDefinitionChangeState.pending),
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    groupKey,
    effectiveDate,
    payloadJson,
    payloadVersion,
    state,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_pending_definition_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskPendingDefinitionChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('group_key')) {
      context.handle(
        _groupKeyMeta,
        groupKey.isAcceptableOrUnknown(data['group_key']!, _groupKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_groupKeyMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskPendingDefinitionChange map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskPendingDefinitionChange(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_id'],
          )!,
      groupKey:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}group_key'],
          )!,
      effectiveDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}effective_date'],
          )!,
      payloadJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payload_json'],
          )!,
      payloadVersion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}payload_version'],
          )!,
      state:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}state'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TaskPendingDefinitionChangesTable createAlias(String alias) {
    return $TaskPendingDefinitionChangesTable(attachedDatabase, alias);
  }
}

class TaskPendingDefinitionChange extends DataClass
    implements Insertable<TaskPendingDefinitionChange> {
  final String id;
  final String taskId;
  final String groupKey;
  final DateTime effectiveDate;
  final String payloadJson;
  final int payloadVersion;
  final String state;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskPendingDefinitionChange({
    required this.id,
    required this.taskId,
    required this.groupKey,
    required this.effectiveDate,
    required this.payloadJson,
    required this.payloadVersion,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['group_key'] = Variable<String>(groupKey);
    map['effective_date'] = Variable<DateTime>(effectiveDate);
    map['payload_json'] = Variable<String>(payloadJson);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['state'] = Variable<String>(state);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskPendingDefinitionChangesCompanion toCompanion(bool nullToAbsent) {
    return TaskPendingDefinitionChangesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      groupKey: Value(groupKey),
      effectiveDate: Value(effectiveDate),
      payloadJson: Value(payloadJson),
      payloadVersion: Value(payloadVersion),
      state: Value(state),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskPendingDefinitionChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskPendingDefinitionChange(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      groupKey: serializer.fromJson<String>(json['groupKey']),
      effectiveDate: serializer.fromJson<DateTime>(json['effectiveDate']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      state: serializer.fromJson<String>(json['state']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'groupKey': serializer.toJson<String>(groupKey),
      'effectiveDate': serializer.toJson<DateTime>(effectiveDate),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'state': serializer.toJson<String>(state),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskPendingDefinitionChange copyWith({
    String? id,
    String? taskId,
    String? groupKey,
    DateTime? effectiveDate,
    String? payloadJson,
    int? payloadVersion,
    String? state,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskPendingDefinitionChange(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    groupKey: groupKey ?? this.groupKey,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    payloadJson: payloadJson ?? this.payloadJson,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    state: state ?? this.state,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskPendingDefinitionChange copyWithCompanion(
    TaskPendingDefinitionChangesCompanion data,
  ) {
    return TaskPendingDefinitionChange(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      groupKey: data.groupKey.present ? data.groupKey.value : this.groupKey,
      effectiveDate:
          data.effectiveDate.present
              ? data.effectiveDate.value
              : this.effectiveDate,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      payloadVersion:
          data.payloadVersion.present
              ? data.payloadVersion.value
              : this.payloadVersion,
      state: data.state.present ? data.state.value : this.state,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskPendingDefinitionChange(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('groupKey: $groupKey, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    groupKey,
    effectiveDate,
    payloadJson,
    payloadVersion,
    state,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskPendingDefinitionChange &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.groupKey == this.groupKey &&
          other.effectiveDate == this.effectiveDate &&
          other.payloadJson == this.payloadJson &&
          other.payloadVersion == this.payloadVersion &&
          other.state == this.state &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskPendingDefinitionChangesCompanion
    extends UpdateCompanion<TaskPendingDefinitionChange> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> groupKey;
  final Value<DateTime> effectiveDate;
  final Value<String> payloadJson;
  final Value<int> payloadVersion;
  final Value<String> state;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskPendingDefinitionChangesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.groupKey = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskPendingDefinitionChangesCompanion.insert({
    required String id,
    required String taskId,
    required String groupKey,
    required DateTime effectiveDate,
    required String payloadJson,
    this.payloadVersion = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       groupKey = Value(groupKey),
       effectiveDate = Value(effectiveDate),
       payloadJson = Value(payloadJson);
  static Insertable<TaskPendingDefinitionChange> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? groupKey,
    Expression<DateTime>? effectiveDate,
    Expression<String>? payloadJson,
    Expression<int>? payloadVersion,
    Expression<String>? state,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (groupKey != null) 'group_key': groupKey,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (state != null) 'state': state,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskPendingDefinitionChangesCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? groupKey,
    Value<DateTime>? effectiveDate,
    Value<String>? payloadJson,
    Value<int>? payloadVersion,
    Value<String>? state,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskPendingDefinitionChangesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      groupKey: groupKey ?? this.groupKey,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      payloadJson: payloadJson ?? this.payloadJson,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (groupKey.present) {
      map['group_key'] = Variable<String>(groupKey.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskPendingDefinitionChangesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('groupKey: $groupKey, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskProjectAssignmentChangesTable extends TaskProjectAssignmentChanges
    with
        TableInfo<
          $TaskProjectAssignmentChangesTable,
          TaskProjectAssignmentChange
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskProjectAssignmentChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bundleIdMeta = const VerificationMeta(
    'bundleId',
  );
  @override
  late final GeneratedColumn<String> bundleId = GeneratedColumn<String>(
    'bundle_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_value_bundles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetProjectIdMeta = const VerificationMeta(
    'targetProjectId',
  );
  @override
  late final GeneratedColumn<String> targetProjectId = GeneratedColumn<String>(
    'target_project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _previousProjectIdMeta = const VerificationMeta(
    'previousProjectId',
  );
  @override
  late final GeneratedColumn<String> previousProjectId =
      GeneratedColumn<String>(
        'previous_project_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>(
        'effective_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskProjectAssignmentState.pending),
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(ProjectAssignmentOrigin.user),
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    bundleId,
    targetProjectId,
    previousProjectId,
    scope,
    effectiveDate,
    sequence,
    state,
    origin,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_project_assignment_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskProjectAssignmentChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('bundle_id')) {
      context.handle(
        _bundleIdMeta,
        bundleId.isAcceptableOrUnknown(data['bundle_id']!, _bundleIdMeta),
      );
    }
    if (data.containsKey('target_project_id')) {
      context.handle(
        _targetProjectIdMeta,
        targetProjectId.isAcceptableOrUnknown(
          data['target_project_id']!,
          _targetProjectIdMeta,
        ),
      );
    }
    if (data.containsKey('previous_project_id')) {
      context.handle(
        _previousProjectIdMeta,
        previousProjectId.isAcceptableOrUnknown(
          data['previous_project_id']!,
          _previousProjectIdMeta,
        ),
      );
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskProjectAssignmentChange map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskProjectAssignmentChange(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      bundleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bundle_id'],
      ),
      targetProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_project_id'],
      ),
      previousProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_project_id'],
      ),
      scope:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}scope'],
          )!,
      effectiveDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}effective_date'],
          )!,
      sequence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sequence'],
          )!,
      state:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}state'],
          )!,
      origin:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}origin'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TaskProjectAssignmentChangesTable createAlias(String alias) {
    return $TaskProjectAssignmentChangesTable(attachedDatabase, alias);
  }
}

class TaskProjectAssignmentChange extends DataClass
    implements Insertable<TaskProjectAssignmentChange> {
  final String id;
  final String? taskId;
  final String? bundleId;
  final String? targetProjectId;
  final String? previousProjectId;
  final String scope;
  final DateTime effectiveDate;
  final int sequence;
  final String state;
  final String origin;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskProjectAssignmentChange({
    required this.id,
    this.taskId,
    this.bundleId,
    this.targetProjectId,
    this.previousProjectId,
    required this.scope,
    required this.effectiveDate,
    required this.sequence,
    required this.state,
    required this.origin,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || bundleId != null) {
      map['bundle_id'] = Variable<String>(bundleId);
    }
    if (!nullToAbsent || targetProjectId != null) {
      map['target_project_id'] = Variable<String>(targetProjectId);
    }
    if (!nullToAbsent || previousProjectId != null) {
      map['previous_project_id'] = Variable<String>(previousProjectId);
    }
    map['scope'] = Variable<String>(scope);
    map['effective_date'] = Variable<DateTime>(effectiveDate);
    map['sequence'] = Variable<int>(sequence);
    map['state'] = Variable<String>(state);
    map['origin'] = Variable<String>(origin);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskProjectAssignmentChangesCompanion toCompanion(bool nullToAbsent) {
    return TaskProjectAssignmentChangesCompanion(
      id: Value(id),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      bundleId:
          bundleId == null && nullToAbsent
              ? const Value.absent()
              : Value(bundleId),
      targetProjectId:
          targetProjectId == null && nullToAbsent
              ? const Value.absent()
              : Value(targetProjectId),
      previousProjectId:
          previousProjectId == null && nullToAbsent
              ? const Value.absent()
              : Value(previousProjectId),
      scope: Value(scope),
      effectiveDate: Value(effectiveDate),
      sequence: Value(sequence),
      state: Value(state),
      origin: Value(origin),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskProjectAssignmentChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskProjectAssignmentChange(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      bundleId: serializer.fromJson<String?>(json['bundleId']),
      targetProjectId: serializer.fromJson<String?>(json['targetProjectId']),
      previousProjectId: serializer.fromJson<String?>(
        json['previousProjectId'],
      ),
      scope: serializer.fromJson<String>(json['scope']),
      effectiveDate: serializer.fromJson<DateTime>(json['effectiveDate']),
      sequence: serializer.fromJson<int>(json['sequence']),
      state: serializer.fromJson<String>(json['state']),
      origin: serializer.fromJson<String>(json['origin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'bundleId': serializer.toJson<String?>(bundleId),
      'targetProjectId': serializer.toJson<String?>(targetProjectId),
      'previousProjectId': serializer.toJson<String?>(previousProjectId),
      'scope': serializer.toJson<String>(scope),
      'effectiveDate': serializer.toJson<DateTime>(effectiveDate),
      'sequence': serializer.toJson<int>(sequence),
      'state': serializer.toJson<String>(state),
      'origin': serializer.toJson<String>(origin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskProjectAssignmentChange copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    Value<String?> bundleId = const Value.absent(),
    Value<String?> targetProjectId = const Value.absent(),
    Value<String?> previousProjectId = const Value.absent(),
    String? scope,
    DateTime? effectiveDate,
    int? sequence,
    String? state,
    String? origin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskProjectAssignmentChange(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    bundleId: bundleId.present ? bundleId.value : this.bundleId,
    targetProjectId:
        targetProjectId.present ? targetProjectId.value : this.targetProjectId,
    previousProjectId:
        previousProjectId.present
            ? previousProjectId.value
            : this.previousProjectId,
    scope: scope ?? this.scope,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    sequence: sequence ?? this.sequence,
    state: state ?? this.state,
    origin: origin ?? this.origin,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskProjectAssignmentChange copyWithCompanion(
    TaskProjectAssignmentChangesCompanion data,
  ) {
    return TaskProjectAssignmentChange(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      bundleId: data.bundleId.present ? data.bundleId.value : this.bundleId,
      targetProjectId:
          data.targetProjectId.present
              ? data.targetProjectId.value
              : this.targetProjectId,
      previousProjectId:
          data.previousProjectId.present
              ? data.previousProjectId.value
              : this.previousProjectId,
      scope: data.scope.present ? data.scope.value : this.scope,
      effectiveDate:
          data.effectiveDate.present
              ? data.effectiveDate.value
              : this.effectiveDate,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      state: data.state.present ? data.state.value : this.state,
      origin: data.origin.present ? data.origin.value : this.origin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskProjectAssignmentChange(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('bundleId: $bundleId, ')
          ..write('targetProjectId: $targetProjectId, ')
          ..write('previousProjectId: $previousProjectId, ')
          ..write('scope: $scope, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('sequence: $sequence, ')
          ..write('state: $state, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    bundleId,
    targetProjectId,
    previousProjectId,
    scope,
    effectiveDate,
    sequence,
    state,
    origin,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskProjectAssignmentChange &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.bundleId == this.bundleId &&
          other.targetProjectId == this.targetProjectId &&
          other.previousProjectId == this.previousProjectId &&
          other.scope == this.scope &&
          other.effectiveDate == this.effectiveDate &&
          other.sequence == this.sequence &&
          other.state == this.state &&
          other.origin == this.origin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskProjectAssignmentChangesCompanion
    extends UpdateCompanion<TaskProjectAssignmentChange> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String?> bundleId;
  final Value<String?> targetProjectId;
  final Value<String?> previousProjectId;
  final Value<String> scope;
  final Value<DateTime> effectiveDate;
  final Value<int> sequence;
  final Value<String> state;
  final Value<String> origin;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskProjectAssignmentChangesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.bundleId = const Value.absent(),
    this.targetProjectId = const Value.absent(),
    this.previousProjectId = const Value.absent(),
    this.scope = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.sequence = const Value.absent(),
    this.state = const Value.absent(),
    this.origin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskProjectAssignmentChangesCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    this.bundleId = const Value.absent(),
    this.targetProjectId = const Value.absent(),
    this.previousProjectId = const Value.absent(),
    required String scope,
    required DateTime effectiveDate,
    required int sequence,
    this.state = const Value.absent(),
    this.origin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scope = Value(scope),
       effectiveDate = Value(effectiveDate),
       sequence = Value(sequence);
  static Insertable<TaskProjectAssignmentChange> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? bundleId,
    Expression<String>? targetProjectId,
    Expression<String>? previousProjectId,
    Expression<String>? scope,
    Expression<DateTime>? effectiveDate,
    Expression<int>? sequence,
    Expression<String>? state,
    Expression<String>? origin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (bundleId != null) 'bundle_id': bundleId,
      if (targetProjectId != null) 'target_project_id': targetProjectId,
      if (previousProjectId != null) 'previous_project_id': previousProjectId,
      if (scope != null) 'scope': scope,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (sequence != null) 'sequence': sequence,
      if (state != null) 'state': state,
      if (origin != null) 'origin': origin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskProjectAssignmentChangesCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<String?>? bundleId,
    Value<String?>? targetProjectId,
    Value<String?>? previousProjectId,
    Value<String>? scope,
    Value<DateTime>? effectiveDate,
    Value<int>? sequence,
    Value<String>? state,
    Value<String>? origin,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskProjectAssignmentChangesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      bundleId: bundleId ?? this.bundleId,
      targetProjectId: targetProjectId ?? this.targetProjectId,
      previousProjectId: previousProjectId ?? this.previousProjectId,
      scope: scope ?? this.scope,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      sequence: sequence ?? this.sequence,
      state: state ?? this.state,
      origin: origin ?? this.origin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (bundleId.present) {
      map['bundle_id'] = Variable<String>(bundleId.value);
    }
    if (targetProjectId.present) {
      map['target_project_id'] = Variable<String>(targetProjectId.value);
    }
    if (previousProjectId.present) {
      map['previous_project_id'] = Variable<String>(previousProjectId.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskProjectAssignmentChangesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('bundleId: $bundleId, ')
          ..write('targetProjectId: $targetProjectId, ')
          ..write('previousProjectId: $previousProjectId, ')
          ..write('scope: $scope, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('sequence: $sequence, ')
          ..write('state: $state, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCorrectionOperationsTable extends TaskCorrectionOperations
    with TableInfo<$TaskCorrectionOperationsTable, TaskCorrectionOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCorrectionOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(TaskCorrectionOperationState.applied),
  );
  static const VerificationMeta _payloadVersionMeta = const VerificationMeta(
    'payloadVersion',
  );
  @override
  late final GeneratedColumn<int> payloadVersion = GeneratedColumn<int>(
    'payload_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    type,
    state,
    payloadVersion,
    reason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_correction_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCorrectionOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('payload_version')) {
      context.handle(
        _payloadVersionMeta,
        payloadVersion.isAcceptableOrUnknown(
          data['payload_version']!,
          _payloadVersionMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCorrectionOperation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCorrectionOperation(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      state:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}state'],
          )!,
      payloadVersion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}payload_version'],
          )!,
      reason:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}reason'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TaskCorrectionOperationsTable createAlias(String alias) {
    return $TaskCorrectionOperationsTable(attachedDatabase, alias);
  }
}

class TaskCorrectionOperation extends DataClass
    implements Insertable<TaskCorrectionOperation> {
  final String id;
  final String taskId;
  final String type;
  final String state;
  final int payloadVersion;
  final String reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskCorrectionOperation({
    required this.id,
    required this.taskId,
    required this.type,
    required this.state,
    required this.payloadVersion,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['type'] = Variable<String>(type);
    map['state'] = Variable<String>(state);
    map['payload_version'] = Variable<int>(payloadVersion);
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskCorrectionOperationsCompanion toCompanion(bool nullToAbsent) {
    return TaskCorrectionOperationsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      type: Value(type),
      state: Value(state),
      payloadVersion: Value(payloadVersion),
      reason: Value(reason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskCorrectionOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCorrectionOperation(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      state: serializer.fromJson<String>(json['state']),
      payloadVersion: serializer.fromJson<int>(json['payloadVersion']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(type),
      'state': serializer.toJson<String>(state),
      'payloadVersion': serializer.toJson<int>(payloadVersion),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskCorrectionOperation copyWith({
    String? id,
    String? taskId,
    String? type,
    String? state,
    int? payloadVersion,
    String? reason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskCorrectionOperation(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    type: type ?? this.type,
    state: state ?? this.state,
    payloadVersion: payloadVersion ?? this.payloadVersion,
    reason: reason ?? this.reason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskCorrectionOperation copyWithCompanion(
    TaskCorrectionOperationsCompanion data,
  ) {
    return TaskCorrectionOperation(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      state: data.state.present ? data.state.value : this.state,
      payloadVersion:
          data.payloadVersion.present
              ? data.payloadVersion.value
              : this.payloadVersion,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCorrectionOperation(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('state: $state, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    type,
    state,
    payloadVersion,
    reason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCorrectionOperation &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.state == this.state &&
          other.payloadVersion == this.payloadVersion &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskCorrectionOperationsCompanion
    extends UpdateCompanion<TaskCorrectionOperation> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> type;
  final Value<String> state;
  final Value<int> payloadVersion;
  final Value<String> reason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskCorrectionOperationsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.state = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCorrectionOperationsCompanion.insert({
    required String id,
    required String taskId,
    required String type,
    this.state = const Value.absent(),
    this.payloadVersion = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       type = Value(type);
  static Insertable<TaskCorrectionOperation> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<String>? state,
    Expression<int>? payloadVersion,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (state != null) 'state': state,
      if (payloadVersion != null) 'payload_version': payloadVersion,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCorrectionOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? type,
    Value<String>? state,
    Value<int>? payloadVersion,
    Value<String>? reason,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskCorrectionOperationsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      state: state ?? this.state,
      payloadVersion: payloadVersion ?? this.payloadVersion,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (payloadVersion.present) {
      map['payload_version'] = Variable<int>(payloadVersion.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCorrectionOperationsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('state: $state, ')
          ..write('payloadVersion: $payloadVersion, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCorrectionItemsTable extends TaskCorrectionItems
    with TableInfo<$TaskCorrectionItemsTable, TaskCorrectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCorrectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_correction_operations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _beforeJsonMeta = const VerificationMeta(
    'beforeJson',
  );
  @override
  late final GeneratedColumn<String> beforeJson = GeneratedColumn<String>(
    'before_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _afterJsonMeta = const VerificationMeta(
    'afterJson',
  );
  @override
  late final GeneratedColumn<String> afterJson = GeneratedColumn<String>(
    'after_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedRevisionMeta = const VerificationMeta(
    'expectedRevision',
  );
  @override
  late final GeneratedColumn<int> expectedRevision = GeneratedColumn<int>(
    'expected_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operationId,
    entryId,
    beforeJson,
    afterJson,
    expectedRevision,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_correction_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCorrectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('before_json')) {
      context.handle(
        _beforeJsonMeta,
        beforeJson.isAcceptableOrUnknown(data['before_json']!, _beforeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_beforeJsonMeta);
    }
    if (data.containsKey('after_json')) {
      context.handle(
        _afterJsonMeta,
        afterJson.isAcceptableOrUnknown(data['after_json']!, _afterJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_afterJsonMeta);
    }
    if (data.containsKey('expected_revision')) {
      context.handle(
        _expectedRevisionMeta,
        expectedRevision.isAcceptableOrUnknown(
          data['expected_revision']!,
          _expectedRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedRevisionMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {operationId, entryId},
  ];
  @override
  TaskCorrectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCorrectionItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      operationId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}operation_id'],
          )!,
      entryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entry_id'],
          )!,
      beforeJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}before_json'],
          )!,
      afterJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}after_json'],
          )!,
      expectedRevision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}expected_revision'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $TaskCorrectionItemsTable createAlias(String alias) {
    return $TaskCorrectionItemsTable(attachedDatabase, alias);
  }
}

class TaskCorrectionItem extends DataClass
    implements Insertable<TaskCorrectionItem> {
  final String id;
  final String operationId;
  final String entryId;
  final String beforeJson;
  final String afterJson;
  final int expectedRevision;
  final DateTime createdAt;
  const TaskCorrectionItem({
    required this.id,
    required this.operationId,
    required this.entryId,
    required this.beforeJson,
    required this.afterJson,
    required this.expectedRevision,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation_id'] = Variable<String>(operationId);
    map['entry_id'] = Variable<String>(entryId);
    map['before_json'] = Variable<String>(beforeJson);
    map['after_json'] = Variable<String>(afterJson);
    map['expected_revision'] = Variable<int>(expectedRevision);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskCorrectionItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskCorrectionItemsCompanion(
      id: Value(id),
      operationId: Value(operationId),
      entryId: Value(entryId),
      beforeJson: Value(beforeJson),
      afterJson: Value(afterJson),
      expectedRevision: Value(expectedRevision),
      createdAt: Value(createdAt),
    );
  }

  factory TaskCorrectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCorrectionItem(
      id: serializer.fromJson<String>(json['id']),
      operationId: serializer.fromJson<String>(json['operationId']),
      entryId: serializer.fromJson<String>(json['entryId']),
      beforeJson: serializer.fromJson<String>(json['beforeJson']),
      afterJson: serializer.fromJson<String>(json['afterJson']),
      expectedRevision: serializer.fromJson<int>(json['expectedRevision']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operationId': serializer.toJson<String>(operationId),
      'entryId': serializer.toJson<String>(entryId),
      'beforeJson': serializer.toJson<String>(beforeJson),
      'afterJson': serializer.toJson<String>(afterJson),
      'expectedRevision': serializer.toJson<int>(expectedRevision),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskCorrectionItem copyWith({
    String? id,
    String? operationId,
    String? entryId,
    String? beforeJson,
    String? afterJson,
    int? expectedRevision,
    DateTime? createdAt,
  }) => TaskCorrectionItem(
    id: id ?? this.id,
    operationId: operationId ?? this.operationId,
    entryId: entryId ?? this.entryId,
    beforeJson: beforeJson ?? this.beforeJson,
    afterJson: afterJson ?? this.afterJson,
    expectedRevision: expectedRevision ?? this.expectedRevision,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskCorrectionItem copyWithCompanion(TaskCorrectionItemsCompanion data) {
    return TaskCorrectionItem(
      id: data.id.present ? data.id.value : this.id,
      operationId:
          data.operationId.present ? data.operationId.value : this.operationId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      beforeJson:
          data.beforeJson.present ? data.beforeJson.value : this.beforeJson,
      afterJson: data.afterJson.present ? data.afterJson.value : this.afterJson,
      expectedRevision:
          data.expectedRevision.present
              ? data.expectedRevision.value
              : this.expectedRevision,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCorrectionItem(')
          ..write('id: $id, ')
          ..write('operationId: $operationId, ')
          ..write('entryId: $entryId, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('expectedRevision: $expectedRevision, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operationId,
    entryId,
    beforeJson,
    afterJson,
    expectedRevision,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCorrectionItem &&
          other.id == this.id &&
          other.operationId == this.operationId &&
          other.entryId == this.entryId &&
          other.beforeJson == this.beforeJson &&
          other.afterJson == this.afterJson &&
          other.expectedRevision == this.expectedRevision &&
          other.createdAt == this.createdAt);
}

class TaskCorrectionItemsCompanion extends UpdateCompanion<TaskCorrectionItem> {
  final Value<String> id;
  final Value<String> operationId;
  final Value<String> entryId;
  final Value<String> beforeJson;
  final Value<String> afterJson;
  final Value<int> expectedRevision;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskCorrectionItemsCompanion({
    this.id = const Value.absent(),
    this.operationId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.beforeJson = const Value.absent(),
    this.afterJson = const Value.absent(),
    this.expectedRevision = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCorrectionItemsCompanion.insert({
    required String id,
    required String operationId,
    required String entryId,
    required String beforeJson,
    required String afterJson,
    required int expectedRevision,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       operationId = Value(operationId),
       entryId = Value(entryId),
       beforeJson = Value(beforeJson),
       afterJson = Value(afterJson),
       expectedRevision = Value(expectedRevision);
  static Insertable<TaskCorrectionItem> custom({
    Expression<String>? id,
    Expression<String>? operationId,
    Expression<String>? entryId,
    Expression<String>? beforeJson,
    Expression<String>? afterJson,
    Expression<int>? expectedRevision,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationId != null) 'operation_id': operationId,
      if (entryId != null) 'entry_id': entryId,
      if (beforeJson != null) 'before_json': beforeJson,
      if (afterJson != null) 'after_json': afterJson,
      if (expectedRevision != null) 'expected_revision': expectedRevision,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCorrectionItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? operationId,
    Value<String>? entryId,
    Value<String>? beforeJson,
    Value<String>? afterJson,
    Value<int>? expectedRevision,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TaskCorrectionItemsCompanion(
      id: id ?? this.id,
      operationId: operationId ?? this.operationId,
      entryId: entryId ?? this.entryId,
      beforeJson: beforeJson ?? this.beforeJson,
      afterJson: afterJson ?? this.afterJson,
      expectedRevision: expectedRevision ?? this.expectedRevision,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (beforeJson.present) {
      map['before_json'] = Variable<String>(beforeJson.value);
    }
    if (afterJson.present) {
      map['after_json'] = Variable<String>(afterJson.value);
    }
    if (expectedRevision.present) {
      map['expected_revision'] = Variable<int>(expectedRevision.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCorrectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('operationId: $operationId, ')
          ..write('entryId: $entryId, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('expectedRevision: $expectedRevision, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskPlanningInterruptionsTable extends TaskPlanningInterruptions
    with TableInfo<$TaskPlanningInterruptionsTable, TaskPlanningInterruption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskPlanningInterruptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aufgaben (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromDayMeta = const VerificationMeta(
    'fromDay',
  );
  @override
  late final GeneratedColumn<String> fromDay = GeneratedColumn<String>(
    'from_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _untilDayExclusiveMeta = const VerificationMeta(
    'untilDayExclusive',
  );
  @override
  late final GeneratedColumn<String> untilDayExclusive =
      GeneratedColumn<String>(
        'until_day_exclusive',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    reason,
    fromDay,
    untilDayExclusive,
    createdAt,
    updatedAt,
    revision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_planning_interruptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskPlanningInterruption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('from_day')) {
      context.handle(
        _fromDayMeta,
        fromDay.isAcceptableOrUnknown(data['from_day']!, _fromDayMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDayMeta);
    }
    if (data.containsKey('until_day_exclusive')) {
      context.handle(
        _untilDayExclusiveMeta,
        untilDayExclusive.isAcceptableOrUnknown(
          data['until_day_exclusive']!,
          _untilDayExclusiveMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskPlanningInterruption map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskPlanningInterruption(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      taskId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}task_id'],
          )!,
      reason:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}reason'],
          )!,
      fromDay:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}from_day'],
          )!,
      untilDayExclusive: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}until_day_exclusive'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      revision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}revision'],
          )!,
    );
  }

  @override
  $TaskPlanningInterruptionsTable createAlias(String alias) {
    return $TaskPlanningInterruptionsTable(attachedDatabase, alias);
  }
}

class TaskPlanningInterruption extends DataClass
    implements Insertable<TaskPlanningInterruption> {
  final String id;
  final String taskId;
  final String reason;
  final String fromDay;
  final String? untilDayExclusive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int revision;
  const TaskPlanningInterruption({
    required this.id,
    required this.taskId,
    required this.reason,
    required this.fromDay,
    this.untilDayExclusive,
    required this.createdAt,
    required this.updatedAt,
    required this.revision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['reason'] = Variable<String>(reason);
    map['from_day'] = Variable<String>(fromDay);
    if (!nullToAbsent || untilDayExclusive != null) {
      map['until_day_exclusive'] = Variable<String>(untilDayExclusive);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['revision'] = Variable<int>(revision);
    return map;
  }

  TaskPlanningInterruptionsCompanion toCompanion(bool nullToAbsent) {
    return TaskPlanningInterruptionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      reason: Value(reason),
      fromDay: Value(fromDay),
      untilDayExclusive:
          untilDayExclusive == null && nullToAbsent
              ? const Value.absent()
              : Value(untilDayExclusive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      revision: Value(revision),
    );
  }

  factory TaskPlanningInterruption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskPlanningInterruption(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      reason: serializer.fromJson<String>(json['reason']),
      fromDay: serializer.fromJson<String>(json['fromDay']),
      untilDayExclusive: serializer.fromJson<String?>(
        json['untilDayExclusive'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      revision: serializer.fromJson<int>(json['revision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'reason': serializer.toJson<String>(reason),
      'fromDay': serializer.toJson<String>(fromDay),
      'untilDayExclusive': serializer.toJson<String?>(untilDayExclusive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'revision': serializer.toJson<int>(revision),
    };
  }

  TaskPlanningInterruption copyWith({
    String? id,
    String? taskId,
    String? reason,
    String? fromDay,
    Value<String?> untilDayExclusive = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? revision,
  }) => TaskPlanningInterruption(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    reason: reason ?? this.reason,
    fromDay: fromDay ?? this.fromDay,
    untilDayExclusive:
        untilDayExclusive.present
            ? untilDayExclusive.value
            : this.untilDayExclusive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    revision: revision ?? this.revision,
  );
  TaskPlanningInterruption copyWithCompanion(
    TaskPlanningInterruptionsCompanion data,
  ) {
    return TaskPlanningInterruption(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      reason: data.reason.present ? data.reason.value : this.reason,
      fromDay: data.fromDay.present ? data.fromDay.value : this.fromDay,
      untilDayExclusive:
          data.untilDayExclusive.present
              ? data.untilDayExclusive.value
              : this.untilDayExclusive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      revision: data.revision.present ? data.revision.value : this.revision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskPlanningInterruption(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reason: $reason, ')
          ..write('fromDay: $fromDay, ')
          ..write('untilDayExclusive: $untilDayExclusive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('revision: $revision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    reason,
    fromDay,
    untilDayExclusive,
    createdAt,
    updatedAt,
    revision,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskPlanningInterruption &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.reason == this.reason &&
          other.fromDay == this.fromDay &&
          other.untilDayExclusive == this.untilDayExclusive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.revision == this.revision);
}

class TaskPlanningInterruptionsCompanion
    extends UpdateCompanion<TaskPlanningInterruption> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> reason;
  final Value<String> fromDay;
  final Value<String?> untilDayExclusive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> revision;
  final Value<int> rowid;
  const TaskPlanningInterruptionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.reason = const Value.absent(),
    this.fromDay = const Value.absent(),
    this.untilDayExclusive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskPlanningInterruptionsCompanion.insert({
    required String id,
    required String taskId,
    required String reason,
    required String fromDay,
    this.untilDayExclusive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       reason = Value(reason),
       fromDay = Value(fromDay);
  static Insertable<TaskPlanningInterruption> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? reason,
    Expression<String>? fromDay,
    Expression<String>? untilDayExclusive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? revision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (reason != null) 'reason': reason,
      if (fromDay != null) 'from_day': fromDay,
      if (untilDayExclusive != null) 'until_day_exclusive': untilDayExclusive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (revision != null) 'revision': revision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskPlanningInterruptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? reason,
    Value<String>? fromDay,
    Value<String?>? untilDayExclusive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? revision,
    Value<int>? rowid,
  }) {
    return TaskPlanningInterruptionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reason: reason ?? this.reason,
      fromDay: fromDay ?? this.fromDay,
      untilDayExclusive: untilDayExclusive ?? this.untilDayExclusive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      revision: revision ?? this.revision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (fromDay.present) {
      map['from_day'] = Variable<String>(fromDay.value);
    }
    if (untilDayExclusive.present) {
      map['until_day_exclusive'] = Variable<String>(untilDayExclusive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskPlanningInterruptionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reason: $reason, ')
          ..write('fromDay: $fromDay, ')
          ..write('untilDayExclusive: $untilDayExclusive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('revision: $revision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityDeletionMarkersTable extends EntityDeletionMarkers
    with TableInfo<$EntityDeletionMarkersTable, EntityDeletionMarker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityDeletionMarkersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [entityType, entityId, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_deletion_markers';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityDeletionMarker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityType, entityId};
  @override
  EntityDeletionMarker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityDeletionMarker(
      entityType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_type'],
          )!,
      entityId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}entity_id'],
          )!,
      deletedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}deleted_at'],
          )!,
    );
  }

  @override
  $EntityDeletionMarkersTable createAlias(String alias) {
    return $EntityDeletionMarkersTable(attachedDatabase, alias);
  }
}

class EntityDeletionMarker extends DataClass
    implements Insertable<EntityDeletionMarker> {
  final String entityType;
  final String entityId;
  final DateTime deletedAt;
  const EntityDeletionMarker({
    required this.entityType,
    required this.entityId,
    required this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    return map;
  }

  EntityDeletionMarkersCompanion toCompanion(bool nullToAbsent) {
    return EntityDeletionMarkersCompanion(
      entityType: Value(entityType),
      entityId: Value(entityId),
      deletedAt: Value(deletedAt),
    );
  }

  factory EntityDeletionMarker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityDeletionMarker(
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
    };
  }

  EntityDeletionMarker copyWith({
    String? entityType,
    String? entityId,
    DateTime? deletedAt,
  }) => EntityDeletionMarker(
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    deletedAt: deletedAt ?? this.deletedAt,
  );
  EntityDeletionMarker copyWithCompanion(EntityDeletionMarkersCompanion data) {
    return EntityDeletionMarker(
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityDeletionMarker(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityType, entityId, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityDeletionMarker &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.deletedAt == this.deletedAt);
}

class EntityDeletionMarkersCompanion
    extends UpdateCompanion<EntityDeletionMarker> {
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<DateTime> deletedAt;
  final Value<int> rowid;
  const EntityDeletionMarkersCompanion({
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityDeletionMarkersCompanion.insert({
    required String entityType,
    required String entityId,
    required DateTime deletedAt,
    this.rowid = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       deletedAt = Value(deletedAt);
  static Insertable<EntityDeletionMarker> custom({
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityDeletionMarkersCompanion copyWith({
    Value<String>? entityType,
    Value<String>? entityId,
    Value<DateTime>? deletedAt,
    Value<int>? rowid,
  }) {
    return EntityDeletionMarkersCompanion(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityDeletionMarkersCompanion(')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectDeletionBatchesTable extends ProjectDeletionBatches
    with TableInfo<$ProjectDeletionBatchesTable, ProjectDeletionBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectDeletionBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectRevisionMeta = const VerificationMeta(
    'projectRevision',
  );
  @override
  late final GeneratedColumn<int> projectRevision = GeneratedColumn<int>(
    'project_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    mode,
    deletedAt,
    projectRevision,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_deletion_batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectDeletionBatch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    if (data.containsKey('project_revision')) {
      context.handle(
        _projectRevisionMeta,
        projectRevision.isAcceptableOrUnknown(
          data['project_revision']!,
          _projectRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_projectRevisionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectDeletionBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectDeletionBatch(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      mode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mode'],
          )!,
      deletedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}deleted_at'],
          )!,
      projectRevision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}project_revision'],
          )!,
    );
  }

  @override
  $ProjectDeletionBatchesTable createAlias(String alias) {
    return $ProjectDeletionBatchesTable(attachedDatabase, alias);
  }
}

class ProjectDeletionBatch extends DataClass
    implements Insertable<ProjectDeletionBatch> {
  final String id;
  final String projectId;
  final String mode;
  final DateTime deletedAt;
  final int projectRevision;
  const ProjectDeletionBatch({
    required this.id,
    required this.projectId,
    required this.mode,
    required this.deletedAt,
    required this.projectRevision,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['mode'] = Variable<String>(mode);
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    map['project_revision'] = Variable<int>(projectRevision);
    return map;
  }

  ProjectDeletionBatchesCompanion toCompanion(bool nullToAbsent) {
    return ProjectDeletionBatchesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      mode: Value(mode),
      deletedAt: Value(deletedAt),
      projectRevision: Value(projectRevision),
    );
  }

  factory ProjectDeletionBatch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectDeletionBatch(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      mode: serializer.fromJson<String>(json['mode']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
      projectRevision: serializer.fromJson<int>(json['projectRevision']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'mode': serializer.toJson<String>(mode),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
      'projectRevision': serializer.toJson<int>(projectRevision),
    };
  }

  ProjectDeletionBatch copyWith({
    String? id,
    String? projectId,
    String? mode,
    DateTime? deletedAt,
    int? projectRevision,
  }) => ProjectDeletionBatch(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    mode: mode ?? this.mode,
    deletedAt: deletedAt ?? this.deletedAt,
    projectRevision: projectRevision ?? this.projectRevision,
  );
  ProjectDeletionBatch copyWithCompanion(ProjectDeletionBatchesCompanion data) {
    return ProjectDeletionBatch(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      mode: data.mode.present ? data.mode.value : this.mode,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      projectRevision:
          data.projectRevision.present
              ? data.projectRevision.value
              : this.projectRevision,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectDeletionBatch(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('mode: $mode, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('projectRevision: $projectRevision')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, mode, deletedAt, projectRevision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectDeletionBatch &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.mode == this.mode &&
          other.deletedAt == this.deletedAt &&
          other.projectRevision == this.projectRevision);
}

class ProjectDeletionBatchesCompanion
    extends UpdateCompanion<ProjectDeletionBatch> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> mode;
  final Value<DateTime> deletedAt;
  final Value<int> projectRevision;
  final Value<int> rowid;
  const ProjectDeletionBatchesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.mode = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.projectRevision = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectDeletionBatchesCompanion.insert({
    required String id,
    required String projectId,
    required String mode,
    required DateTime deletedAt,
    required int projectRevision,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       mode = Value(mode),
       deletedAt = Value(deletedAt),
       projectRevision = Value(projectRevision);
  static Insertable<ProjectDeletionBatch> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? mode,
    Expression<DateTime>? deletedAt,
    Expression<int>? projectRevision,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (mode != null) 'mode': mode,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (projectRevision != null) 'project_revision': projectRevision,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectDeletionBatchesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? mode,
    Value<DateTime>? deletedAt,
    Value<int>? projectRevision,
    Value<int>? rowid,
  }) {
    return ProjectDeletionBatchesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      mode: mode ?? this.mode,
      deletedAt: deletedAt ?? this.deletedAt,
      projectRevision: projectRevision ?? this.projectRevision,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (projectRevision.present) {
      map['project_revision'] = Variable<int>(projectRevision.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectDeletionBatchesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('mode: $mode, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('projectRevision: $projectRevision, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectDeletionBatchItemsTable extends ProjectDeletionBatchItems
    with TableInfo<$ProjectDeletionBatchItemsTable, ProjectDeletionBatchItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectDeletionBatchItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES project_deletion_batches (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _objectTypeMeta = const VerificationMeta(
    'objectType',
  );
  @override
  late final GeneratedColumn<String> objectType = GeneratedColumn<String>(
    'object_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _objectIdMeta = const VerificationMeta(
    'objectId',
  );
  @override
  late final GeneratedColumn<String> objectId = GeneratedColumn<String>(
    'object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifecycleRevisionMeta = const VerificationMeta(
    'lifecycleRevision',
  );
  @override
  late final GeneratedColumn<int> lifecycleRevision = GeneratedColumn<int>(
    'lifecycle_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<DateTime> trashedAt = GeneratedColumn<DateTime>(
    'trashed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    batchId,
    objectType,
    objectId,
    lifecycleRevision,
    trashedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_deletion_batch_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectDeletionBatchItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('object_type')) {
      context.handle(
        _objectTypeMeta,
        objectType.isAcceptableOrUnknown(data['object_type']!, _objectTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_objectTypeMeta);
    }
    if (data.containsKey('object_id')) {
      context.handle(
        _objectIdMeta,
        objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_objectIdMeta);
    }
    if (data.containsKey('lifecycle_revision')) {
      context.handle(
        _lifecycleRevisionMeta,
        lifecycleRevision.isAcceptableOrUnknown(
          data['lifecycle_revision']!,
          _lifecycleRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lifecycleRevisionMeta);
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_trashedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {batchId, objectType, objectId};
  @override
  ProjectDeletionBatchItem map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectDeletionBatchItem(
      batchId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}batch_id'],
          )!,
      objectType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}object_type'],
          )!,
      objectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}object_id'],
          )!,
      lifecycleRevision:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}lifecycle_revision'],
          )!,
      trashedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}trashed_at'],
          )!,
    );
  }

  @override
  $ProjectDeletionBatchItemsTable createAlias(String alias) {
    return $ProjectDeletionBatchItemsTable(attachedDatabase, alias);
  }
}

class ProjectDeletionBatchItem extends DataClass
    implements Insertable<ProjectDeletionBatchItem> {
  final String batchId;
  final String objectType;
  final String objectId;
  final int lifecycleRevision;
  final DateTime trashedAt;
  const ProjectDeletionBatchItem({
    required this.batchId,
    required this.objectType,
    required this.objectId,
    required this.lifecycleRevision,
    required this.trashedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['batch_id'] = Variable<String>(batchId);
    map['object_type'] = Variable<String>(objectType);
    map['object_id'] = Variable<String>(objectId);
    map['lifecycle_revision'] = Variable<int>(lifecycleRevision);
    map['trashed_at'] = Variable<DateTime>(trashedAt);
    return map;
  }

  ProjectDeletionBatchItemsCompanion toCompanion(bool nullToAbsent) {
    return ProjectDeletionBatchItemsCompanion(
      batchId: Value(batchId),
      objectType: Value(objectType),
      objectId: Value(objectId),
      lifecycleRevision: Value(lifecycleRevision),
      trashedAt: Value(trashedAt),
    );
  }

  factory ProjectDeletionBatchItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectDeletionBatchItem(
      batchId: serializer.fromJson<String>(json['batchId']),
      objectType: serializer.fromJson<String>(json['objectType']),
      objectId: serializer.fromJson<String>(json['objectId']),
      lifecycleRevision: serializer.fromJson<int>(json['lifecycleRevision']),
      trashedAt: serializer.fromJson<DateTime>(json['trashedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'batchId': serializer.toJson<String>(batchId),
      'objectType': serializer.toJson<String>(objectType),
      'objectId': serializer.toJson<String>(objectId),
      'lifecycleRevision': serializer.toJson<int>(lifecycleRevision),
      'trashedAt': serializer.toJson<DateTime>(trashedAt),
    };
  }

  ProjectDeletionBatchItem copyWith({
    String? batchId,
    String? objectType,
    String? objectId,
    int? lifecycleRevision,
    DateTime? trashedAt,
  }) => ProjectDeletionBatchItem(
    batchId: batchId ?? this.batchId,
    objectType: objectType ?? this.objectType,
    objectId: objectId ?? this.objectId,
    lifecycleRevision: lifecycleRevision ?? this.lifecycleRevision,
    trashedAt: trashedAt ?? this.trashedAt,
  );
  ProjectDeletionBatchItem copyWithCompanion(
    ProjectDeletionBatchItemsCompanion data,
  ) {
    return ProjectDeletionBatchItem(
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      objectType:
          data.objectType.present ? data.objectType.value : this.objectType,
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      lifecycleRevision:
          data.lifecycleRevision.present
              ? data.lifecycleRevision.value
              : this.lifecycleRevision,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectDeletionBatchItem(')
          ..write('batchId: $batchId, ')
          ..write('objectType: $objectType, ')
          ..write('objectId: $objectId, ')
          ..write('lifecycleRevision: $lifecycleRevision, ')
          ..write('trashedAt: $trashedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(batchId, objectType, objectId, lifecycleRevision, trashedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectDeletionBatchItem &&
          other.batchId == this.batchId &&
          other.objectType == this.objectType &&
          other.objectId == this.objectId &&
          other.lifecycleRevision == this.lifecycleRevision &&
          other.trashedAt == this.trashedAt);
}

class ProjectDeletionBatchItemsCompanion
    extends UpdateCompanion<ProjectDeletionBatchItem> {
  final Value<String> batchId;
  final Value<String> objectType;
  final Value<String> objectId;
  final Value<int> lifecycleRevision;
  final Value<DateTime> trashedAt;
  final Value<int> rowid;
  const ProjectDeletionBatchItemsCompanion({
    this.batchId = const Value.absent(),
    this.objectType = const Value.absent(),
    this.objectId = const Value.absent(),
    this.lifecycleRevision = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectDeletionBatchItemsCompanion.insert({
    required String batchId,
    required String objectType,
    required String objectId,
    required int lifecycleRevision,
    required DateTime trashedAt,
    this.rowid = const Value.absent(),
  }) : batchId = Value(batchId),
       objectType = Value(objectType),
       objectId = Value(objectId),
       lifecycleRevision = Value(lifecycleRevision),
       trashedAt = Value(trashedAt);
  static Insertable<ProjectDeletionBatchItem> custom({
    Expression<String>? batchId,
    Expression<String>? objectType,
    Expression<String>? objectId,
    Expression<int>? lifecycleRevision,
    Expression<DateTime>? trashedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (batchId != null) 'batch_id': batchId,
      if (objectType != null) 'object_type': objectType,
      if (objectId != null) 'object_id': objectId,
      if (lifecycleRevision != null) 'lifecycle_revision': lifecycleRevision,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectDeletionBatchItemsCompanion copyWith({
    Value<String>? batchId,
    Value<String>? objectType,
    Value<String>? objectId,
    Value<int>? lifecycleRevision,
    Value<DateTime>? trashedAt,
    Value<int>? rowid,
  }) {
    return ProjectDeletionBatchItemsCompanion(
      batchId: batchId ?? this.batchId,
      objectType: objectType ?? this.objectType,
      objectId: objectId ?? this.objectId,
      lifecycleRevision: lifecycleRevision ?? this.lifecycleRevision,
      trashedAt: trashedAt ?? this.trashedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (objectType.present) {
      map['object_type'] = Variable<String>(objectType.value);
    }
    if (objectId.present) {
      map['object_id'] = Variable<String>(objectId.value);
    }
    if (lifecycleRevision.present) {
      map['lifecycle_revision'] = Variable<int>(lifecycleRevision.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<DateTime>(trashedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectDeletionBatchItemsCompanion(')
          ..write('batchId: $batchId, ')
          ..write('objectType: $objectType, ')
          ..write('objectId: $objectId, ')
          ..write('lifecycleRevision: $lifecycleRevision, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $AufgabenTable aufgaben = $AufgabenTable(this);
  late final $TaskDefinitionVersionsTable taskDefinitionVersions =
      $TaskDefinitionVersionsTable(this);
  late final $TaskEntriesTable taskEntries = $TaskEntriesTable(this);
  late final $TaskEntryValuesTable taskEntryValues = $TaskEntryValuesTable(
    this,
  );
  late final $TaskValueBundlesTable taskValueBundles = $TaskValueBundlesTable(
    this,
  );
  late final $TaskValueBundleVersionsTable taskValueBundleVersions =
      $TaskValueBundleVersionsTable(this);
  late final $TaskCardMetricPreferencesTable taskCardMetricPreferences =
      $TaskCardMetricPreferencesTable(this);
  late final $TaskPendingDefinitionChangesTable taskPendingDefinitionChanges =
      $TaskPendingDefinitionChangesTable(this);
  late final $TaskProjectAssignmentChangesTable taskProjectAssignmentChanges =
      $TaskProjectAssignmentChangesTable(this);
  late final $TaskCorrectionOperationsTable taskCorrectionOperations =
      $TaskCorrectionOperationsTable(this);
  late final $TaskCorrectionItemsTable taskCorrectionItems =
      $TaskCorrectionItemsTable(this);
  late final $TaskPlanningInterruptionsTable taskPlanningInterruptions =
      $TaskPlanningInterruptionsTable(this);
  late final $EntityDeletionMarkersTable entityDeletionMarkers =
      $EntityDeletionMarkersTable(this);
  late final $ProjectDeletionBatchesTable projectDeletionBatches =
      $ProjectDeletionBatchesTable(this);
  late final $ProjectDeletionBatchItemsTable projectDeletionBatchItems =
      $ProjectDeletionBatchItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    aufgaben,
    taskDefinitionVersions,
    taskEntries,
    taskEntryValues,
    taskValueBundles,
    taskValueBundleVersions,
    taskCardMetricPreferences,
    taskPendingDefinitionChanges,
    taskProjectAssignmentChanges,
    taskCorrectionOperations,
    taskCorrectionItems,
    taskPlanningInterruptions,
    entityDeletionMarkers,
    projectDeletionBatches,
    projectDeletionBatchItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('aufgaben', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_definition_versions', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_definition_versions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_entries', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_entry_values', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_value_bundles', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_value_bundles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_value_bundle_versions', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_card_metric_preferences', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_value_bundles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_card_metric_preferences', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_pending_definition_changes', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_project_assignment_changes', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_value_bundles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_project_assignment_changes', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_project_assignment_changes', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_project_assignment_changes', kind: UpdateKind.update),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_correction_operations', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_correction_operations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_correction_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'task_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('task_correction_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'aufgaben',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('task_planning_interruptions', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'project_deletion_batches',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('project_deletion_batch_items', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      Value<String> description,
      Value<String> colorHex,
      Value<int> sortOrder,
      Value<DateTime?> archivedAt,
      Value<DateTime?> trashedAt,
      Value<DateTime?> purgeAt,
      Value<DateTime?> deletedAt,
      Value<int> revision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> colorHex,
      Value<int> sortOrder,
      Value<DateTime?> archivedAt,
      Value<DateTime?> trashedAt,
      Value<DateTime?> purgeAt,
      Value<DateTime?> deletedAt,
      Value<int> revision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AufgabenTable, List<Aufgabe>> _aufgabenRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.aufgaben,
    aliasName: $_aliasNameGenerator(db.projects.id, db.aufgaben.projectId),
  );

  $$AufgabenTableProcessedTableManager get aufgabenRefs {
    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_aufgabenRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskValueBundlesTable, List<TaskValueBundle>>
  _taskValueBundlesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskValueBundles,
    aliasName: $_aliasNameGenerator(
      db.projects.id,
      db.taskValueBundles.projectId,
    ),
  );

  $$TaskValueBundlesTableProcessedTableManager get taskValueBundlesRefs {
    final manager = $$TaskValueBundlesTableTableManager(
      $_db,
      $_db.taskValueBundles,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskValueBundlesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskProjectAssignmentChangesTable,
    List<TaskProjectAssignmentChange>
  >
  _targetProjectAssignmentChangesTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskProjectAssignmentChanges,
        aliasName: $_aliasNameGenerator(
          db.projects.id,
          db.taskProjectAssignmentChanges.targetProjectId,
        ),
      );

  $$TaskProjectAssignmentChangesTableProcessedTableManager
  get targetProjectAssignmentChanges {
    final manager = $$TaskProjectAssignmentChangesTableTableManager(
      $_db,
      $_db.taskProjectAssignmentChanges,
    ).filter(
      (f) => f.targetProjectId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(
      _targetProjectAssignmentChangesTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskProjectAssignmentChangesTable,
    List<TaskProjectAssignmentChange>
  >
  _previousProjectAssignmentChangesTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskProjectAssignmentChanges,
        aliasName: $_aliasNameGenerator(
          db.projects.id,
          db.taskProjectAssignmentChanges.previousProjectId,
        ),
      );

  $$TaskProjectAssignmentChangesTableProcessedTableManager
  get previousProjectAssignmentChanges {
    final manager = $$TaskProjectAssignmentChangesTableTableManager(
      $_db,
      $_db.taskProjectAssignmentChanges,
    ).filter(
      (f) => f.previousProjectId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(
      _previousProjectAssignmentChangesTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProjectDeletionBatchesTable,
    List<ProjectDeletionBatch>
  >
  _projectDeletionBatchesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectDeletionBatches,
        aliasName: $_aliasNameGenerator(
          db.projects.id,
          db.projectDeletionBatches.projectId,
        ),
      );

  $$ProjectDeletionBatchesTableProcessedTableManager
  get projectDeletionBatchesRefs {
    final manager = $$ProjectDeletionBatchesTableTableManager(
      $_db,
      $_db.projectDeletionBatches,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectDeletionBatchesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purgeAt => $composableBuilder(
    column: $table.purgeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> aufgabenRefs(
    Expression<bool> Function($$AufgabenTableFilterComposer f) f,
  ) {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskValueBundlesRefs(
    Expression<bool> Function($$TaskValueBundlesTableFilterComposer f) f,
  ) {
    final $$TaskValueBundlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableFilterComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> targetProjectAssignmentChanges(
    Expression<bool> Function(
      $$TaskProjectAssignmentChangesTableFilterComposer f,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.targetProjectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableFilterComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> previousProjectAssignmentChanges(
    Expression<bool> Function(
      $$TaskProjectAssignmentChangesTableFilterComposer f,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.previousProjectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableFilterComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> projectDeletionBatchesRefs(
    Expression<bool> Function($$ProjectDeletionBatchesTableFilterComposer f) f,
  ) {
    final $$ProjectDeletionBatchesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectDeletionBatches,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchesTableFilterComposer(
                $db: $db,
                $table: $db.projectDeletionBatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purgeAt => $composableBuilder(
    column: $table.purgeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get purgeAt =>
      $composableBuilder(column: $table.purgeAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> aufgabenRefs<T extends Object>(
    Expression<T> Function($$AufgabenTableAnnotationComposer a) f,
  ) {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskValueBundlesRefs<T extends Object>(
    Expression<T> Function($$TaskValueBundlesTableAnnotationComposer a) f,
  ) {
    final $$TaskValueBundlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> targetProjectAssignmentChanges<T extends Object>(
    Expression<T> Function(
      $$TaskProjectAssignmentChangesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.targetProjectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> previousProjectAssignmentChanges<T extends Object>(
    Expression<T> Function(
      $$TaskProjectAssignmentChangesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.previousProjectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> projectDeletionBatchesRefs<T extends Object>(
    Expression<T> Function($$ProjectDeletionBatchesTableAnnotationComposer a) f,
  ) {
    final $$ProjectDeletionBatchesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectDeletionBatches,
          getReferencedColumn: (t) => t.projectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectDeletionBatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({
            bool aufgabenRefs,
            bool taskValueBundlesRefs,
            bool targetProjectAssignmentChanges,
            bool previousProjectAssignmentChanges,
            bool projectDeletionBatchesRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime?> purgeAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                description: description,
                colorHex: colorHex,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                trashedAt: trashedAt,
                purgeAt: purgeAt,
                deletedAt: deletedAt,
                revision: revision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime?> purgeAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                description: description,
                colorHex: colorHex,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                trashedAt: trashedAt,
                purgeAt: purgeAt,
                deletedAt: deletedAt,
                revision: revision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ProjectsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            aufgabenRefs = false,
            taskValueBundlesRefs = false,
            targetProjectAssignmentChanges = false,
            previousProjectAssignmentChanges = false,
            projectDeletionBatchesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (aufgabenRefs) db.aufgaben,
                if (taskValueBundlesRefs) db.taskValueBundles,
                if (targetProjectAssignmentChanges)
                  db.taskProjectAssignmentChanges,
                if (previousProjectAssignmentChanges)
                  db.taskProjectAssignmentChanges,
                if (projectDeletionBatchesRefs) db.projectDeletionBatches,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aufgabenRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable, Aufgabe>(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._aufgabenRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).aufgabenRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.projectId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (taskValueBundlesRefs)
                    await $_getPrefetchedData<
                      Project,
                      $ProjectsTable,
                      TaskValueBundle
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._taskValueBundlesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskValueBundlesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.projectId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (targetProjectAssignmentChanges)
                    await $_getPrefetchedData<
                      Project,
                      $ProjectsTable,
                      TaskProjectAssignmentChange
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._targetProjectAssignmentChangesTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).targetProjectAssignmentChanges,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.targetProjectId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (previousProjectAssignmentChanges)
                    await $_getPrefetchedData<
                      Project,
                      $ProjectsTable,
                      TaskProjectAssignmentChange
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._previousProjectAssignmentChangesTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).previousProjectAssignmentChanges,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.previousProjectId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (projectDeletionBatchesRefs)
                    await $_getPrefetchedData<
                      Project,
                      $ProjectsTable,
                      ProjectDeletionBatch
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._projectDeletionBatchesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectDeletionBatchesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.projectId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({
        bool aufgabenRefs,
        bool taskValueBundlesRefs,
        bool targetProjectAssignmentChanges,
        bool previousProjectAssignmentChanges,
        bool projectDeletionBatchesRefs,
      })
    >;
typedef $$AufgabenTableCreateCompanionBuilder =
    AufgabenCompanion Function({
      required String id,
      Value<String?> projectId,
      required String name,
      Value<String> beschreibung,
      required String erfassungsmodus,
      Value<String> taskType,
      Value<String> questionText,
      Value<bool> successValue,
      Value<String> activeWeekdays,
      Value<String> recurrence,
      required DateTime startDate,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> endDate,
      Value<DateTime?> dueDate,
      Value<bool> isActive,
      Value<DateTime?> trashedAt,
      Value<DateTime?> purgeAt,
      Value<int> lifecycleRevision,
      Value<DateTime?> lifecycleUpdatedAt,
      Value<String> missedPolicy,
      Value<String> missedConsequence,
      Value<int> missedBufferDays,
      Value<String> postBufferBehavior,
      Value<int> maxCarryoverCount,
      Value<String> goalType,
      Value<int> goalValue,
      Value<int?> goalWindowDays,
      Value<String> goalPeriod,
      Value<String> goalPeriodAlignment,
      Value<String> valueType,
      Value<String> valueCommitment,
      Value<String> valueUnitKey,
      Value<String> valueUnitLabel,
      Value<int> rowid,
    });
typedef $$AufgabenTableUpdateCompanionBuilder =
    AufgabenCompanion Function({
      Value<String> id,
      Value<String?> projectId,
      Value<String> name,
      Value<String> beschreibung,
      Value<String> erfassungsmodus,
      Value<String> taskType,
      Value<String> questionText,
      Value<bool> successValue,
      Value<String> activeWeekdays,
      Value<String> recurrence,
      Value<DateTime> startDate,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> endDate,
      Value<DateTime?> dueDate,
      Value<bool> isActive,
      Value<DateTime?> trashedAt,
      Value<DateTime?> purgeAt,
      Value<int> lifecycleRevision,
      Value<DateTime?> lifecycleUpdatedAt,
      Value<String> missedPolicy,
      Value<String> missedConsequence,
      Value<int> missedBufferDays,
      Value<String> postBufferBehavior,
      Value<int> maxCarryoverCount,
      Value<String> goalType,
      Value<int> goalValue,
      Value<int?> goalWindowDays,
      Value<String> goalPeriod,
      Value<String> goalPeriodAlignment,
      Value<String> valueType,
      Value<String> valueCommitment,
      Value<String> valueUnitKey,
      Value<String> valueUnitLabel,
      Value<int> rowid,
    });

final class $$AufgabenTableReferences
    extends BaseReferences<_$AppDatabase, $AufgabenTable, Aufgabe> {
  $$AufgabenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.aufgaben.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TaskDefinitionVersionsTable,
    List<TaskDefinitionVersion>
  >
  _taskDefinitionVersionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskDefinitionVersions,
        aliasName: $_aliasNameGenerator(
          db.aufgaben.id,
          db.taskDefinitionVersions.taskId,
        ),
      );

  $$TaskDefinitionVersionsTableProcessedTableManager
  get taskDefinitionVersionsRefs {
    final manager = $$TaskDefinitionVersionsTableTableManager(
      $_db,
      $_db.taskDefinitionVersions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskDefinitionVersionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskEntriesTable, List<TaskEntry>>
  _taskEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntries,
    aliasName: $_aliasNameGenerator(db.aufgaben.id, db.taskEntries.taskId),
  );

  $$TaskEntriesTableProcessedTableManager get taskEntriesRefs {
    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskCardMetricPreferencesTable,
    List<TaskCardMetricPreference>
  >
  _taskCardMetricPreferencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskCardMetricPreferences,
        aliasName: $_aliasNameGenerator(
          db.aufgaben.id,
          db.taskCardMetricPreferences.taskId,
        ),
      );

  $$TaskCardMetricPreferencesTableProcessedTableManager
  get taskCardMetricPreferencesRefs {
    final manager = $$TaskCardMetricPreferencesTableTableManager(
      $_db,
      $_db.taskCardMetricPreferences,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCardMetricPreferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskPendingDefinitionChangesTable,
    List<TaskPendingDefinitionChange>
  >
  _taskPendingDefinitionChangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskPendingDefinitionChanges,
        aliasName: $_aliasNameGenerator(
          db.aufgaben.id,
          db.taskPendingDefinitionChanges.taskId,
        ),
      );

  $$TaskPendingDefinitionChangesTableProcessedTableManager
  get taskPendingDefinitionChangesRefs {
    final manager = $$TaskPendingDefinitionChangesTableTableManager(
      $_db,
      $_db.taskPendingDefinitionChanges,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskPendingDefinitionChangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskProjectAssignmentChangesTable,
    List<TaskProjectAssignmentChange>
  >
  _taskProjectAssignmentChangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskProjectAssignmentChanges,
        aliasName: $_aliasNameGenerator(
          db.aufgaben.id,
          db.taskProjectAssignmentChanges.taskId,
        ),
      );

  $$TaskProjectAssignmentChangesTableProcessedTableManager
  get taskProjectAssignmentChangesRefs {
    final manager = $$TaskProjectAssignmentChangesTableTableManager(
      $_db,
      $_db.taskProjectAssignmentChanges,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskProjectAssignmentChangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskCorrectionOperationsTable,
    List<TaskCorrectionOperation>
  >
  _taskCorrectionOperationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskCorrectionOperations,
        aliasName: $_aliasNameGenerator(
          db.aufgaben.id,
          db.taskCorrectionOperations.taskId,
        ),
      );

  $$TaskCorrectionOperationsTableProcessedTableManager
  get taskCorrectionOperationsRefs {
    final manager = $$TaskCorrectionOperationsTableTableManager(
      $_db,
      $_db.taskCorrectionOperations,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCorrectionOperationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskPlanningInterruptionsTable,
    List<TaskPlanningInterruption>
  >
  _taskPlanningInterruptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskPlanningInterruptions,
        aliasName: $_aliasNameGenerator(
          db.aufgaben.id,
          db.taskPlanningInterruptions.taskId,
        ),
      );

  $$TaskPlanningInterruptionsTableProcessedTableManager
  get taskPlanningInterruptionsRefs {
    final manager = $$TaskPlanningInterruptionsTableTableManager(
      $_db,
      $_db.taskPlanningInterruptions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskPlanningInterruptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AufgabenTableFilterComposer
    extends Composer<_$AppDatabase, $AufgabenTable> {
  $$AufgabenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get erfassungsmodus => $composableBuilder(
    column: $table.erfassungsmodus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get successValue => $composableBuilder(
    column: $table.successValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeWeekdays => $composableBuilder(
    column: $table.activeWeekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purgeAt => $composableBuilder(
    column: $table.purgeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lifecycleUpdatedAt => $composableBuilder(
    column: $table.lifecycleUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missedPolicy => $composableBuilder(
    column: $table.missedPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missedConsequence => $composableBuilder(
    column: $table.missedConsequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missedBufferDays => $composableBuilder(
    column: $table.missedBufferDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postBufferBehavior => $composableBuilder(
    column: $table.postBufferBehavior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxCarryoverCount => $composableBuilder(
    column: $table.maxCarryoverCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalPeriod => $composableBuilder(
    column: $table.goalPeriod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalPeriodAlignment => $composableBuilder(
    column: $table.goalPeriodAlignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueCommitment => $composableBuilder(
    column: $table.valueCommitment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueUnitKey => $composableBuilder(
    column: $table.valueUnitKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueUnitLabel => $composableBuilder(
    column: $table.valueUnitLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskDefinitionVersionsRefs(
    Expression<bool> Function($$TaskDefinitionVersionsTableFilterComposer f) f,
  ) {
    final $$TaskDefinitionVersionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskDefinitionVersions,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskDefinitionVersionsTableFilterComposer(
                $db: $db,
                $table: $db.taskDefinitionVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskEntriesRefs(
    Expression<bool> Function($$TaskEntriesTableFilterComposer f) f,
  ) {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskCardMetricPreferencesRefs(
    Expression<bool> Function($$TaskCardMetricPreferencesTableFilterComposer f)
    f,
  ) {
    final $$TaskCardMetricPreferencesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCardMetricPreferences,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCardMetricPreferencesTableFilterComposer(
                $db: $db,
                $table: $db.taskCardMetricPreferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskPendingDefinitionChangesRefs(
    Expression<bool> Function(
      $$TaskPendingDefinitionChangesTableFilterComposer f,
    )
    f,
  ) {
    final $$TaskPendingDefinitionChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskPendingDefinitionChanges,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskPendingDefinitionChangesTableFilterComposer(
                $db: $db,
                $table: $db.taskPendingDefinitionChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskProjectAssignmentChangesRefs(
    Expression<bool> Function(
      $$TaskProjectAssignmentChangesTableFilterComposer f,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableFilterComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskCorrectionOperationsRefs(
    Expression<bool> Function($$TaskCorrectionOperationsTableFilterComposer f)
    f,
  ) {
    final $$TaskCorrectionOperationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCorrectionOperations,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionOperationsTableFilterComposer(
                $db: $db,
                $table: $db.taskCorrectionOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskPlanningInterruptionsRefs(
    Expression<bool> Function($$TaskPlanningInterruptionsTableFilterComposer f)
    f,
  ) {
    final $$TaskPlanningInterruptionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskPlanningInterruptions,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskPlanningInterruptionsTableFilterComposer(
                $db: $db,
                $table: $db.taskPlanningInterruptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AufgabenTableOrderingComposer
    extends Composer<_$AppDatabase, $AufgabenTable> {
  $$AufgabenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get erfassungsmodus => $composableBuilder(
    column: $table.erfassungsmodus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get successValue => $composableBuilder(
    column: $table.successValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeWeekdays => $composableBuilder(
    column: $table.activeWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purgeAt => $composableBuilder(
    column: $table.purgeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lifecycleUpdatedAt => $composableBuilder(
    column: $table.lifecycleUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missedPolicy => $composableBuilder(
    column: $table.missedPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missedConsequence => $composableBuilder(
    column: $table.missedConsequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missedBufferDays => $composableBuilder(
    column: $table.missedBufferDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postBufferBehavior => $composableBuilder(
    column: $table.postBufferBehavior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxCarryoverCount => $composableBuilder(
    column: $table.maxCarryoverCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalPeriod => $composableBuilder(
    column: $table.goalPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalPeriodAlignment => $composableBuilder(
    column: $table.goalPeriodAlignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueCommitment => $composableBuilder(
    column: $table.valueCommitment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueUnitKey => $composableBuilder(
    column: $table.valueUnitKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueUnitLabel => $composableBuilder(
    column: $table.valueUnitLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AufgabenTableAnnotationComposer
    extends Composer<_$AppDatabase, $AufgabenTable> {
  $$AufgabenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get beschreibung => $composableBuilder(
    column: $table.beschreibung,
    builder: (column) => column,
  );

  GeneratedColumn<String> get erfassungsmodus => $composableBuilder(
    column: $table.erfassungsmodus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get successValue => $composableBuilder(
    column: $table.successValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeWeekdays => $composableBuilder(
    column: $table.activeWeekdays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get purgeAt =>
      $composableBuilder(column: $table.purgeAt, builder: (column) => column);

  GeneratedColumn<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lifecycleUpdatedAt => $composableBuilder(
    column: $table.lifecycleUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missedPolicy => $composableBuilder(
    column: $table.missedPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missedConsequence => $composableBuilder(
    column: $table.missedConsequence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missedBufferDays => $composableBuilder(
    column: $table.missedBufferDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postBufferBehavior => $composableBuilder(
    column: $table.postBufferBehavior,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxCarryoverCount => $composableBuilder(
    column: $table.maxCarryoverCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get goalValue =>
      $composableBuilder(column: $table.goalValue, builder: (column) => column);

  GeneratedColumn<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalPeriod => $composableBuilder(
    column: $table.goalPeriod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalPeriodAlignment => $composableBuilder(
    column: $table.goalPeriodAlignment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<String> get valueCommitment => $composableBuilder(
    column: $table.valueCommitment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueUnitKey => $composableBuilder(
    column: $table.valueUnitKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueUnitLabel => $composableBuilder(
    column: $table.valueUnitLabel,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskDefinitionVersionsRefs<T extends Object>(
    Expression<T> Function($$TaskDefinitionVersionsTableAnnotationComposer a) f,
  ) {
    final $$TaskDefinitionVersionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskDefinitionVersions,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskDefinitionVersionsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskDefinitionVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskCardMetricPreferencesRefs<T extends Object>(
    Expression<T> Function($$TaskCardMetricPreferencesTableAnnotationComposer a)
    f,
  ) {
    final $$TaskCardMetricPreferencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCardMetricPreferences,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCardMetricPreferencesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCardMetricPreferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskPendingDefinitionChangesRefs<T extends Object>(
    Expression<T> Function(
      $$TaskPendingDefinitionChangesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TaskPendingDefinitionChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskPendingDefinitionChanges,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskPendingDefinitionChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskPendingDefinitionChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskProjectAssignmentChangesRefs<T extends Object>(
    Expression<T> Function(
      $$TaskProjectAssignmentChangesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskCorrectionOperationsRefs<T extends Object>(
    Expression<T> Function($$TaskCorrectionOperationsTableAnnotationComposer a)
    f,
  ) {
    final $$TaskCorrectionOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCorrectionOperations,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionOperationsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCorrectionOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskPlanningInterruptionsRefs<T extends Object>(
    Expression<T> Function($$TaskPlanningInterruptionsTableAnnotationComposer a)
    f,
  ) {
    final $$TaskPlanningInterruptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskPlanningInterruptions,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskPlanningInterruptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskPlanningInterruptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AufgabenTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AufgabenTable,
          Aufgabe,
          $$AufgabenTableFilterComposer,
          $$AufgabenTableOrderingComposer,
          $$AufgabenTableAnnotationComposer,
          $$AufgabenTableCreateCompanionBuilder,
          $$AufgabenTableUpdateCompanionBuilder,
          (Aufgabe, $$AufgabenTableReferences),
          Aufgabe,
          PrefetchHooks Function({
            bool projectId,
            bool taskDefinitionVersionsRefs,
            bool taskEntriesRefs,
            bool taskCardMetricPreferencesRefs,
            bool taskPendingDefinitionChangesRefs,
            bool taskProjectAssignmentChangesRefs,
            bool taskCorrectionOperationsRefs,
            bool taskPlanningInterruptionsRefs,
          })
        > {
  $$AufgabenTableTableManager(_$AppDatabase db, $AufgabenTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AufgabenTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AufgabenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AufgabenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> beschreibung = const Value.absent(),
                Value<String> erfassungsmodus = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<bool> successValue = const Value.absent(),
                Value<String> activeWeekdays = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime?> purgeAt = const Value.absent(),
                Value<int> lifecycleRevision = const Value.absent(),
                Value<DateTime?> lifecycleUpdatedAt = const Value.absent(),
                Value<String> missedPolicy = const Value.absent(),
                Value<String> missedConsequence = const Value.absent(),
                Value<int> missedBufferDays = const Value.absent(),
                Value<String> postBufferBehavior = const Value.absent(),
                Value<int> maxCarryoverCount = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> goalValue = const Value.absent(),
                Value<int?> goalWindowDays = const Value.absent(),
                Value<String> goalPeriod = const Value.absent(),
                Value<String> goalPeriodAlignment = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> valueCommitment = const Value.absent(),
                Value<String> valueUnitKey = const Value.absent(),
                Value<String> valueUnitLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AufgabenCompanion(
                id: id,
                projectId: projectId,
                name: name,
                beschreibung: beschreibung,
                erfassungsmodus: erfassungsmodus,
                taskType: taskType,
                questionText: questionText,
                successValue: successValue,
                activeWeekdays: activeWeekdays,
                recurrence: recurrence,
                startDate: startDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                endDate: endDate,
                dueDate: dueDate,
                isActive: isActive,
                trashedAt: trashedAt,
                purgeAt: purgeAt,
                lifecycleRevision: lifecycleRevision,
                lifecycleUpdatedAt: lifecycleUpdatedAt,
                missedPolicy: missedPolicy,
                missedConsequence: missedConsequence,
                missedBufferDays: missedBufferDays,
                postBufferBehavior: postBufferBehavior,
                maxCarryoverCount: maxCarryoverCount,
                goalType: goalType,
                goalValue: goalValue,
                goalWindowDays: goalWindowDays,
                goalPeriod: goalPeriod,
                goalPeriodAlignment: goalPeriodAlignment,
                valueType: valueType,
                valueCommitment: valueCommitment,
                valueUnitKey: valueUnitKey,
                valueUnitLabel: valueUnitLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> projectId = const Value.absent(),
                required String name,
                Value<String> beschreibung = const Value.absent(),
                required String erfassungsmodus,
                Value<String> taskType = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<bool> successValue = const Value.absent(),
                Value<String> activeWeekdays = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                required DateTime startDate,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime?> purgeAt = const Value.absent(),
                Value<int> lifecycleRevision = const Value.absent(),
                Value<DateTime?> lifecycleUpdatedAt = const Value.absent(),
                Value<String> missedPolicy = const Value.absent(),
                Value<String> missedConsequence = const Value.absent(),
                Value<int> missedBufferDays = const Value.absent(),
                Value<String> postBufferBehavior = const Value.absent(),
                Value<int> maxCarryoverCount = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> goalValue = const Value.absent(),
                Value<int?> goalWindowDays = const Value.absent(),
                Value<String> goalPeriod = const Value.absent(),
                Value<String> goalPeriodAlignment = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> valueCommitment = const Value.absent(),
                Value<String> valueUnitKey = const Value.absent(),
                Value<String> valueUnitLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AufgabenCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                beschreibung: beschreibung,
                erfassungsmodus: erfassungsmodus,
                taskType: taskType,
                questionText: questionText,
                successValue: successValue,
                activeWeekdays: activeWeekdays,
                recurrence: recurrence,
                startDate: startDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                endDate: endDate,
                dueDate: dueDate,
                isActive: isActive,
                trashedAt: trashedAt,
                purgeAt: purgeAt,
                lifecycleRevision: lifecycleRevision,
                lifecycleUpdatedAt: lifecycleUpdatedAt,
                missedPolicy: missedPolicy,
                missedConsequence: missedConsequence,
                missedBufferDays: missedBufferDays,
                postBufferBehavior: postBufferBehavior,
                maxCarryoverCount: maxCarryoverCount,
                goalType: goalType,
                goalValue: goalValue,
                goalWindowDays: goalWindowDays,
                goalPeriod: goalPeriod,
                goalPeriodAlignment: goalPeriodAlignment,
                valueType: valueType,
                valueCommitment: valueCommitment,
                valueUnitKey: valueUnitKey,
                valueUnitLabel: valueUnitLabel,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AufgabenTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            projectId = false,
            taskDefinitionVersionsRefs = false,
            taskEntriesRefs = false,
            taskCardMetricPreferencesRefs = false,
            taskPendingDefinitionChangesRefs = false,
            taskProjectAssignmentChangesRefs = false,
            taskCorrectionOperationsRefs = false,
            taskPlanningInterruptionsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskDefinitionVersionsRefs) db.taskDefinitionVersions,
                if (taskEntriesRefs) db.taskEntries,
                if (taskCardMetricPreferencesRefs) db.taskCardMetricPreferences,
                if (taskPendingDefinitionChangesRefs)
                  db.taskPendingDefinitionChanges,
                if (taskProjectAssignmentChangesRefs)
                  db.taskProjectAssignmentChanges,
                if (taskCorrectionOperationsRefs) db.taskCorrectionOperations,
                if (taskPlanningInterruptionsRefs) db.taskPlanningInterruptions,
              ],
              addJoins: <
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
                if (projectId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$AufgabenTableReferences
                                ._projectIdTable(db),
                            referencedColumn:
                                $$AufgabenTableReferences
                                    ._projectIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskDefinitionVersionsRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskDefinitionVersion
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskDefinitionVersionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskDefinitionVersionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                  if (taskEntriesRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskEntriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskEntriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                  if (taskCardMetricPreferencesRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskCardMetricPreference
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskCardMetricPreferencesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCardMetricPreferencesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                  if (taskPendingDefinitionChangesRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskPendingDefinitionChange
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskPendingDefinitionChangesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskPendingDefinitionChangesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                  if (taskProjectAssignmentChangesRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskProjectAssignmentChange
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskProjectAssignmentChangesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskProjectAssignmentChangesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                  if (taskCorrectionOperationsRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskCorrectionOperation
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskCorrectionOperationsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCorrectionOperationsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                  if (taskPlanningInterruptionsRefs)
                    await $_getPrefetchedData<
                      Aufgabe,
                      $AufgabenTable,
                      TaskPlanningInterruption
                    >(
                      currentTable: table,
                      referencedTable: $$AufgabenTableReferences
                          ._taskPlanningInterruptionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AufgabenTableReferences(
                                db,
                                table,
                                p0,
                              ).taskPlanningInterruptionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AufgabenTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AufgabenTable,
      Aufgabe,
      $$AufgabenTableFilterComposer,
      $$AufgabenTableOrderingComposer,
      $$AufgabenTableAnnotationComposer,
      $$AufgabenTableCreateCompanionBuilder,
      $$AufgabenTableUpdateCompanionBuilder,
      (Aufgabe, $$AufgabenTableReferences),
      Aufgabe,
      PrefetchHooks Function({
        bool projectId,
        bool taskDefinitionVersionsRefs,
        bool taskEntriesRefs,
        bool taskCardMetricPreferencesRefs,
        bool taskPendingDefinitionChangesRefs,
        bool taskProjectAssignmentChangesRefs,
        bool taskCorrectionOperationsRefs,
        bool taskPlanningInterruptionsRefs,
      })
    >;
typedef $$TaskDefinitionVersionsTableCreateCompanionBuilder =
    TaskDefinitionVersionsCompanion Function({
      required String id,
      required String taskId,
      required int versionNumber,
      Value<String?> previousVersionId,
      required DateTime validFrom,
      required DateTime createdAt,
      Value<DateTime?> supersededAt,
      Value<String> name,
      Value<String> description,
      Value<String> questionText,
      Value<String?> projectId,
      required String taskType,
      required String captureMode,
      Value<bool> successValue,
      required String activeWeekdays,
      required String recurrence,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<DateTime?> dueDate,
      Value<String> missedPolicy,
      Value<String> missedConsequence,
      Value<int> missedBufferDays,
      Value<String> postBufferBehavior,
      Value<int> maxCarryoverCount,
      Value<String> goalType,
      Value<int> goalValue,
      Value<int?> goalWindowDays,
      Value<String> goalPeriod,
      Value<String> goalPeriodAlignment,
      Value<String> valueType,
      Value<String> valueCommitment,
      Value<String> valueUnitKey,
      Value<String> valueUnitLabel,
      Value<int> rowid,
    });
typedef $$TaskDefinitionVersionsTableUpdateCompanionBuilder =
    TaskDefinitionVersionsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<int> versionNumber,
      Value<String?> previousVersionId,
      Value<DateTime> validFrom,
      Value<DateTime> createdAt,
      Value<DateTime?> supersededAt,
      Value<String> name,
      Value<String> description,
      Value<String> questionText,
      Value<String?> projectId,
      Value<String> taskType,
      Value<String> captureMode,
      Value<bool> successValue,
      Value<String> activeWeekdays,
      Value<String> recurrence,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<DateTime?> dueDate,
      Value<String> missedPolicy,
      Value<String> missedConsequence,
      Value<int> missedBufferDays,
      Value<String> postBufferBehavior,
      Value<int> maxCarryoverCount,
      Value<String> goalType,
      Value<int> goalValue,
      Value<int?> goalWindowDays,
      Value<String> goalPeriod,
      Value<String> goalPeriodAlignment,
      Value<String> valueType,
      Value<String> valueCommitment,
      Value<String> valueUnitKey,
      Value<String> valueUnitLabel,
      Value<int> rowid,
    });

final class $$TaskDefinitionVersionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskDefinitionVersionsTable,
          TaskDefinitionVersion
        > {
  $$TaskDefinitionVersionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AufgabenTable _taskIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(db.taskDefinitionVersions.taskId, db.aufgaben.id),
      );

  $$AufgabenTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskEntriesTable, List<TaskEntry>>
  _taskEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntries,
    aliasName: $_aliasNameGenerator(
      db.taskDefinitionVersions.id,
      db.taskEntries.taskDefinitionVersionId,
    ),
  );

  $$TaskEntriesTableProcessedTableManager get taskEntriesRefs {
    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter(
      (f) =>
          f.taskDefinitionVersionId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_taskEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskDefinitionVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskDefinitionVersionsTable> {
  $$TaskDefinitionVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousVersionId => $composableBuilder(
    column: $table.previousVersionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get supersededAt => $composableBuilder(
    column: $table.supersededAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get captureMode => $composableBuilder(
    column: $table.captureMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get successValue => $composableBuilder(
    column: $table.successValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeWeekdays => $composableBuilder(
    column: $table.activeWeekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missedPolicy => $composableBuilder(
    column: $table.missedPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get missedConsequence => $composableBuilder(
    column: $table.missedConsequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get missedBufferDays => $composableBuilder(
    column: $table.missedBufferDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get postBufferBehavior => $composableBuilder(
    column: $table.postBufferBehavior,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxCarryoverCount => $composableBuilder(
    column: $table.maxCarryoverCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalPeriod => $composableBuilder(
    column: $table.goalPeriod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalPeriodAlignment => $composableBuilder(
    column: $table.goalPeriodAlignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueCommitment => $composableBuilder(
    column: $table.valueCommitment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueUnitKey => $composableBuilder(
    column: $table.valueUnitKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueUnitLabel => $composableBuilder(
    column: $table.valueUnitLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskEntriesRefs(
    Expression<bool> Function($$TaskEntriesTableFilterComposer f) f,
  ) {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.taskDefinitionVersionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskDefinitionVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskDefinitionVersionsTable> {
  $$TaskDefinitionVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousVersionId => $composableBuilder(
    column: $table.previousVersionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get supersededAt => $composableBuilder(
    column: $table.supersededAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskType => $composableBuilder(
    column: $table.taskType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get captureMode => $composableBuilder(
    column: $table.captureMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get successValue => $composableBuilder(
    column: $table.successValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeWeekdays => $composableBuilder(
    column: $table.activeWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missedPolicy => $composableBuilder(
    column: $table.missedPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get missedConsequence => $composableBuilder(
    column: $table.missedConsequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missedBufferDays => $composableBuilder(
    column: $table.missedBufferDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get postBufferBehavior => $composableBuilder(
    column: $table.postBufferBehavior,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxCarryoverCount => $composableBuilder(
    column: $table.maxCarryoverCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalPeriod => $composableBuilder(
    column: $table.goalPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalPeriodAlignment => $composableBuilder(
    column: $table.goalPeriodAlignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueCommitment => $composableBuilder(
    column: $table.valueCommitment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueUnitKey => $composableBuilder(
    column: $table.valueUnitKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueUnitLabel => $composableBuilder(
    column: $table.valueUnitLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskDefinitionVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskDefinitionVersionsTable> {
  $$TaskDefinitionVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousVersionId => $composableBuilder(
    column: $table.previousVersionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get supersededAt => $composableBuilder(
    column: $table.supersededAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get taskType =>
      $composableBuilder(column: $table.taskType, builder: (column) => column);

  GeneratedColumn<String> get captureMode => $composableBuilder(
    column: $table.captureMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get successValue => $composableBuilder(
    column: $table.successValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeWeekdays => $composableBuilder(
    column: $table.activeWeekdays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get missedPolicy => $composableBuilder(
    column: $table.missedPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get missedConsequence => $composableBuilder(
    column: $table.missedConsequence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get missedBufferDays => $composableBuilder(
    column: $table.missedBufferDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get postBufferBehavior => $composableBuilder(
    column: $table.postBufferBehavior,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxCarryoverCount => $composableBuilder(
    column: $table.maxCarryoverCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get goalValue =>
      $composableBuilder(column: $table.goalValue, builder: (column) => column);

  GeneratedColumn<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalPeriod => $composableBuilder(
    column: $table.goalPeriod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalPeriodAlignment => $composableBuilder(
    column: $table.goalPeriodAlignment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<String> get valueCommitment => $composableBuilder(
    column: $table.valueCommitment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueUnitKey => $composableBuilder(
    column: $table.valueUnitKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valueUnitLabel => $composableBuilder(
    column: $table.valueUnitLabel,
    builder: (column) => column,
  );

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskEntriesRefs<T extends Object>(
    Expression<T> Function($$TaskEntriesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.taskDefinitionVersionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskDefinitionVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskDefinitionVersionsTable,
          TaskDefinitionVersion,
          $$TaskDefinitionVersionsTableFilterComposer,
          $$TaskDefinitionVersionsTableOrderingComposer,
          $$TaskDefinitionVersionsTableAnnotationComposer,
          $$TaskDefinitionVersionsTableCreateCompanionBuilder,
          $$TaskDefinitionVersionsTableUpdateCompanionBuilder,
          (TaskDefinitionVersion, $$TaskDefinitionVersionsTableReferences),
          TaskDefinitionVersion,
          PrefetchHooks Function({bool taskId, bool taskEntriesRefs})
        > {
  $$TaskDefinitionVersionsTableTableManager(
    _$AppDatabase db,
    $TaskDefinitionVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskDefinitionVersionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskDefinitionVersionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskDefinitionVersionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<String?> previousVersionId = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> supersededAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String> taskType = const Value.absent(),
                Value<String> captureMode = const Value.absent(),
                Value<bool> successValue = const Value.absent(),
                Value<String> activeWeekdays = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String> missedPolicy = const Value.absent(),
                Value<String> missedConsequence = const Value.absent(),
                Value<int> missedBufferDays = const Value.absent(),
                Value<String> postBufferBehavior = const Value.absent(),
                Value<int> maxCarryoverCount = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> goalValue = const Value.absent(),
                Value<int?> goalWindowDays = const Value.absent(),
                Value<String> goalPeriod = const Value.absent(),
                Value<String> goalPeriodAlignment = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> valueCommitment = const Value.absent(),
                Value<String> valueUnitKey = const Value.absent(),
                Value<String> valueUnitLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskDefinitionVersionsCompanion(
                id: id,
                taskId: taskId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                validFrom: validFrom,
                createdAt: createdAt,
                supersededAt: supersededAt,
                name: name,
                description: description,
                questionText: questionText,
                projectId: projectId,
                taskType: taskType,
                captureMode: captureMode,
                successValue: successValue,
                activeWeekdays: activeWeekdays,
                recurrence: recurrence,
                startDate: startDate,
                endDate: endDate,
                dueDate: dueDate,
                missedPolicy: missedPolicy,
                missedConsequence: missedConsequence,
                missedBufferDays: missedBufferDays,
                postBufferBehavior: postBufferBehavior,
                maxCarryoverCount: maxCarryoverCount,
                goalType: goalType,
                goalValue: goalValue,
                goalWindowDays: goalWindowDays,
                goalPeriod: goalPeriod,
                goalPeriodAlignment: goalPeriodAlignment,
                valueType: valueType,
                valueCommitment: valueCommitment,
                valueUnitKey: valueUnitKey,
                valueUnitLabel: valueUnitLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required int versionNumber,
                Value<String?> previousVersionId = const Value.absent(),
                required DateTime validFrom,
                required DateTime createdAt,
                Value<DateTime?> supersededAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                required String taskType,
                required String captureMode,
                Value<bool> successValue = const Value.absent(),
                required String activeWeekdays,
                required String recurrence,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String> missedPolicy = const Value.absent(),
                Value<String> missedConsequence = const Value.absent(),
                Value<int> missedBufferDays = const Value.absent(),
                Value<String> postBufferBehavior = const Value.absent(),
                Value<int> maxCarryoverCount = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> goalValue = const Value.absent(),
                Value<int?> goalWindowDays = const Value.absent(),
                Value<String> goalPeriod = const Value.absent(),
                Value<String> goalPeriodAlignment = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<String> valueCommitment = const Value.absent(),
                Value<String> valueUnitKey = const Value.absent(),
                Value<String> valueUnitLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskDefinitionVersionsCompanion.insert(
                id: id,
                taskId: taskId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                validFrom: validFrom,
                createdAt: createdAt,
                supersededAt: supersededAt,
                name: name,
                description: description,
                questionText: questionText,
                projectId: projectId,
                taskType: taskType,
                captureMode: captureMode,
                successValue: successValue,
                activeWeekdays: activeWeekdays,
                recurrence: recurrence,
                startDate: startDate,
                endDate: endDate,
                dueDate: dueDate,
                missedPolicy: missedPolicy,
                missedConsequence: missedConsequence,
                missedBufferDays: missedBufferDays,
                postBufferBehavior: postBufferBehavior,
                maxCarryoverCount: maxCarryoverCount,
                goalType: goalType,
                goalValue: goalValue,
                goalWindowDays: goalWindowDays,
                goalPeriod: goalPeriod,
                goalPeriodAlignment: goalPeriodAlignment,
                valueType: valueType,
                valueCommitment: valueCommitment,
                valueUnitKey: valueUnitKey,
                valueUnitLabel: valueUnitLabel,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskDefinitionVersionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({taskId = false, taskEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskEntriesRefs) db.taskEntries],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$TaskDefinitionVersionsTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$TaskDefinitionVersionsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEntriesRefs)
                    await $_getPrefetchedData<
                      TaskDefinitionVersion,
                      $TaskDefinitionVersionsTable,
                      TaskEntry
                    >(
                      currentTable: table,
                      referencedTable: $$TaskDefinitionVersionsTableReferences
                          ._taskEntriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskDefinitionVersionsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskEntriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.taskDefinitionVersionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskDefinitionVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskDefinitionVersionsTable,
      TaskDefinitionVersion,
      $$TaskDefinitionVersionsTableFilterComposer,
      $$TaskDefinitionVersionsTableOrderingComposer,
      $$TaskDefinitionVersionsTableAnnotationComposer,
      $$TaskDefinitionVersionsTableCreateCompanionBuilder,
      $$TaskDefinitionVersionsTableUpdateCompanionBuilder,
      (TaskDefinitionVersion, $$TaskDefinitionVersionsTableReferences),
      TaskDefinitionVersion,
      PrefetchHooks Function({bool taskId, bool taskEntriesRefs})
    >;
typedef $$TaskEntriesTableCreateCompanionBuilder =
    TaskEntriesCompanion Function({
      required String id,
      required String taskId,
      Value<String?> taskDefinitionVersionId,
      required DateTime scheduledDate,
      Value<DateTime?> originalScheduledDate,
      Value<DateTime> createdAt,
      Value<String> status,
      required DateTime updatedAt,
      Value<DateTime?> respondedAt,
      Value<DateTime?> finalizedAt,
      Value<DateTime?> effectiveAt,
      Value<DateTime?> performedOn,
      Value<String?> performedOnSource,
      Value<int> revision,
      Value<String> planningOrigin,
      Value<String?> resolutionOrigin,
      Value<String?> appliedMissedPolicy,
      Value<String?> appliedMissedConsequence,
      Value<bool?> checkboxValue,
      Value<double?> numberValue,
      Value<String> note,
      Value<int> rowid,
    });
typedef $$TaskEntriesTableUpdateCompanionBuilder =
    TaskEntriesCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String?> taskDefinitionVersionId,
      Value<DateTime> scheduledDate,
      Value<DateTime?> originalScheduledDate,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<DateTime?> respondedAt,
      Value<DateTime?> finalizedAt,
      Value<DateTime?> effectiveAt,
      Value<DateTime?> performedOn,
      Value<String?> performedOnSource,
      Value<int> revision,
      Value<String> planningOrigin,
      Value<String?> resolutionOrigin,
      Value<String?> appliedMissedPolicy,
      Value<String?> appliedMissedConsequence,
      Value<bool?> checkboxValue,
      Value<double?> numberValue,
      Value<String> note,
      Value<int> rowid,
    });

final class $$TaskEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskEntriesTable, TaskEntry> {
  $$TaskEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AufgabenTable _taskIdTable(_$AppDatabase db) => db.aufgaben
      .createAlias($_aliasNameGenerator(db.taskEntries.taskId, db.aufgaben.id));

  $$AufgabenTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskDefinitionVersionsTable _taskDefinitionVersionIdTable(
    _$AppDatabase db,
  ) => db.taskDefinitionVersions.createAlias(
    $_aliasNameGenerator(
      db.taskEntries.taskDefinitionVersionId,
      db.taskDefinitionVersions.id,
    ),
  );

  $$TaskDefinitionVersionsTableProcessedTableManager?
  get taskDefinitionVersionId {
    final $_column = $_itemColumn<String>('task_definition_version_id');
    if ($_column == null) return null;
    final manager = $$TaskDefinitionVersionsTableTableManager(
      $_db,
      $_db.taskDefinitionVersions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _taskDefinitionVersionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskEntryValuesTable, List<TaskEntryValue>>
  _taskEntryValuesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskEntryValues,
    aliasName: $_aliasNameGenerator(
      db.taskEntries.id,
      db.taskEntryValues.entryId,
    ),
  );

  $$TaskEntryValuesTableProcessedTableManager get taskEntryValuesRefs {
    final manager = $$TaskEntryValuesTableTableManager(
      $_db,
      $_db.taskEntryValues,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskEntryValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskCorrectionItemsTable,
    List<TaskCorrectionItem>
  >
  _taskCorrectionItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskCorrectionItems,
        aliasName: $_aliasNameGenerator(
          db.taskEntries.id,
          db.taskCorrectionItems.entryId,
        ),
      );

  $$TaskCorrectionItemsTableProcessedTableManager get taskCorrectionItemsRefs {
    final manager = $$TaskCorrectionItemsTableTableManager(
      $_db,
      $_db.taskCorrectionItems,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCorrectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get originalScheduledDate => $composableBuilder(
    column: $table.originalScheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finalizedAt => $composableBuilder(
    column: $table.finalizedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedOn => $composableBuilder(
    column: $table.performedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get performedOnSource => $composableBuilder(
    column: $table.performedOnSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planningOrigin => $composableBuilder(
    column: $table.planningOrigin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolutionOrigin => $composableBuilder(
    column: $table.resolutionOrigin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appliedMissedPolicy => $composableBuilder(
    column: $table.appliedMissedPolicy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appliedMissedConsequence => $composableBuilder(
    column: $table.appliedMissedConsequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checkboxValue => $composableBuilder(
    column: $table.checkboxValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get numberValue => $composableBuilder(
    column: $table.numberValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskDefinitionVersionsTableFilterComposer get taskDefinitionVersionId {
    final $$TaskDefinitionVersionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.taskDefinitionVersionId,
          referencedTable: $db.taskDefinitionVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskDefinitionVersionsTableFilterComposer(
                $db: $db,
                $table: $db.taskDefinitionVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> taskEntryValuesRefs(
    Expression<bool> Function($$TaskEntryValuesTableFilterComposer f) f,
  ) {
    final $$TaskEntryValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntryValues,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntryValuesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntryValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskCorrectionItemsRefs(
    Expression<bool> Function($$TaskCorrectionItemsTableFilterComposer f) f,
  ) {
    final $$TaskCorrectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskCorrectionItems,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCorrectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.taskCorrectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get originalScheduledDate => $composableBuilder(
    column: $table.originalScheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finalizedAt => $composableBuilder(
    column: $table.finalizedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedOn => $composableBuilder(
    column: $table.performedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get performedOnSource => $composableBuilder(
    column: $table.performedOnSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planningOrigin => $composableBuilder(
    column: $table.planningOrigin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolutionOrigin => $composableBuilder(
    column: $table.resolutionOrigin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliedMissedPolicy => $composableBuilder(
    column: $table.appliedMissedPolicy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliedMissedConsequence => $composableBuilder(
    column: $table.appliedMissedConsequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checkboxValue => $composableBuilder(
    column: $table.checkboxValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get numberValue => $composableBuilder(
    column: $table.numberValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskDefinitionVersionsTableOrderingComposer get taskDefinitionVersionId {
    final $$TaskDefinitionVersionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.taskDefinitionVersionId,
          referencedTable: $db.taskDefinitionVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskDefinitionVersionsTableOrderingComposer(
                $db: $db,
                $table: $db.taskDefinitionVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$TaskEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskEntriesTable> {
  $$TaskEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get originalScheduledDate => $composableBuilder(
    column: $table.originalScheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get respondedAt => $composableBuilder(
    column: $table.respondedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finalizedAt => $composableBuilder(
    column: $table.finalizedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveAt => $composableBuilder(
    column: $table.effectiveAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get performedOn => $composableBuilder(
    column: $table.performedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get performedOnSource => $composableBuilder(
    column: $table.performedOnSource,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<String> get planningOrigin => $composableBuilder(
    column: $table.planningOrigin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolutionOrigin => $composableBuilder(
    column: $table.resolutionOrigin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appliedMissedPolicy => $composableBuilder(
    column: $table.appliedMissedPolicy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appliedMissedConsequence => $composableBuilder(
    column: $table.appliedMissedConsequence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get checkboxValue => $composableBuilder(
    column: $table.checkboxValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get numberValue => $composableBuilder(
    column: $table.numberValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskDefinitionVersionsTableAnnotationComposer get taskDefinitionVersionId {
    final $$TaskDefinitionVersionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.taskDefinitionVersionId,
          referencedTable: $db.taskDefinitionVersions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskDefinitionVersionsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskDefinitionVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> taskEntryValuesRefs<T extends Object>(
    Expression<T> Function($$TaskEntryValuesTableAnnotationComposer a) f,
  ) {
    final $$TaskEntryValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskEntryValues,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntryValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntryValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskCorrectionItemsRefs<T extends Object>(
    Expression<T> Function($$TaskCorrectionItemsTableAnnotationComposer a) f,
  ) {
    final $$TaskCorrectionItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCorrectionItems,
          getReferencedColumn: (t) => t.entryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCorrectionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskEntriesTable,
          TaskEntry,
          $$TaskEntriesTableFilterComposer,
          $$TaskEntriesTableOrderingComposer,
          $$TaskEntriesTableAnnotationComposer,
          $$TaskEntriesTableCreateCompanionBuilder,
          $$TaskEntriesTableUpdateCompanionBuilder,
          (TaskEntry, $$TaskEntriesTableReferences),
          TaskEntry,
          PrefetchHooks Function({
            bool taskId,
            bool taskDefinitionVersionId,
            bool taskEntryValuesRefs,
            bool taskCorrectionItemsRefs,
          })
        > {
  $$TaskEntriesTableTableManager(_$AppDatabase db, $TaskEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TaskEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$TaskEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String?> taskDefinitionVersionId = const Value.absent(),
                Value<DateTime> scheduledDate = const Value.absent(),
                Value<DateTime?> originalScheduledDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> respondedAt = const Value.absent(),
                Value<DateTime?> finalizedAt = const Value.absent(),
                Value<DateTime?> effectiveAt = const Value.absent(),
                Value<DateTime?> performedOn = const Value.absent(),
                Value<String?> performedOnSource = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> planningOrigin = const Value.absent(),
                Value<String?> resolutionOrigin = const Value.absent(),
                Value<String?> appliedMissedPolicy = const Value.absent(),
                Value<String?> appliedMissedConsequence = const Value.absent(),
                Value<bool?> checkboxValue = const Value.absent(),
                Value<double?> numberValue = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEntriesCompanion(
                id: id,
                taskId: taskId,
                taskDefinitionVersionId: taskDefinitionVersionId,
                scheduledDate: scheduledDate,
                originalScheduledDate: originalScheduledDate,
                createdAt: createdAt,
                status: status,
                updatedAt: updatedAt,
                respondedAt: respondedAt,
                finalizedAt: finalizedAt,
                effectiveAt: effectiveAt,
                performedOn: performedOn,
                performedOnSource: performedOnSource,
                revision: revision,
                planningOrigin: planningOrigin,
                resolutionOrigin: resolutionOrigin,
                appliedMissedPolicy: appliedMissedPolicy,
                appliedMissedConsequence: appliedMissedConsequence,
                checkboxValue: checkboxValue,
                numberValue: numberValue,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                Value<String?> taskDefinitionVersionId = const Value.absent(),
                required DateTime scheduledDate,
                Value<DateTime?> originalScheduledDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> respondedAt = const Value.absent(),
                Value<DateTime?> finalizedAt = const Value.absent(),
                Value<DateTime?> effectiveAt = const Value.absent(),
                Value<DateTime?> performedOn = const Value.absent(),
                Value<String?> performedOnSource = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<String> planningOrigin = const Value.absent(),
                Value<String?> resolutionOrigin = const Value.absent(),
                Value<String?> appliedMissedPolicy = const Value.absent(),
                Value<String?> appliedMissedConsequence = const Value.absent(),
                Value<bool?> checkboxValue = const Value.absent(),
                Value<double?> numberValue = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEntriesCompanion.insert(
                id: id,
                taskId: taskId,
                taskDefinitionVersionId: taskDefinitionVersionId,
                scheduledDate: scheduledDate,
                originalScheduledDate: originalScheduledDate,
                createdAt: createdAt,
                status: status,
                updatedAt: updatedAt,
                respondedAt: respondedAt,
                finalizedAt: finalizedAt,
                effectiveAt: effectiveAt,
                performedOn: performedOn,
                performedOnSource: performedOnSource,
                revision: revision,
                planningOrigin: planningOrigin,
                resolutionOrigin: resolutionOrigin,
                appliedMissedPolicy: appliedMissedPolicy,
                appliedMissedConsequence: appliedMissedConsequence,
                checkboxValue: checkboxValue,
                numberValue: numberValue,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskEntriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            taskId = false,
            taskDefinitionVersionId = false,
            taskEntryValuesRefs = false,
            taskCorrectionItemsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskEntryValuesRefs) db.taskEntryValues,
                if (taskCorrectionItemsRefs) db.taskCorrectionItems,
              ],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable: $$TaskEntriesTableReferences
                                ._taskIdTable(db),
                            referencedColumn:
                                $$TaskEntriesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (taskDefinitionVersionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskDefinitionVersionId,
                            referencedTable: $$TaskEntriesTableReferences
                                ._taskDefinitionVersionIdTable(db),
                            referencedColumn:
                                $$TaskEntriesTableReferences
                                    ._taskDefinitionVersionIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskEntryValuesRefs)
                    await $_getPrefetchedData<
                      TaskEntry,
                      $TaskEntriesTable,
                      TaskEntryValue
                    >(
                      currentTable: table,
                      referencedTable: $$TaskEntriesTableReferences
                          ._taskEntryValuesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskEntryValuesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.entryId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (taskCorrectionItemsRefs)
                    await $_getPrefetchedData<
                      TaskEntry,
                      $TaskEntriesTable,
                      TaskCorrectionItem
                    >(
                      currentTable: table,
                      referencedTable: $$TaskEntriesTableReferences
                          ._taskCorrectionItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCorrectionItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.entryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskEntriesTable,
      TaskEntry,
      $$TaskEntriesTableFilterComposer,
      $$TaskEntriesTableOrderingComposer,
      $$TaskEntriesTableAnnotationComposer,
      $$TaskEntriesTableCreateCompanionBuilder,
      $$TaskEntriesTableUpdateCompanionBuilder,
      (TaskEntry, $$TaskEntriesTableReferences),
      TaskEntry,
      PrefetchHooks Function({
        bool taskId,
        bool taskDefinitionVersionId,
        bool taskEntryValuesRefs,
        bool taskCorrectionItemsRefs,
      })
    >;
typedef $$TaskEntryValuesTableCreateCompanionBuilder =
    TaskEntryValuesCompanion Function({
      required String id,
      required String entryId,
      required String valueType,
      Value<double?> numberValue,
      Value<double?> normalizedNumberValue,
      Value<String> unitKey,
      Value<String> unitLabel,
      Value<int?> durationSeconds,
      Value<int?> timeMinutes,
      Value<int> dayOffset,
      Value<DateTime> createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TaskEntryValuesTableUpdateCompanionBuilder =
    TaskEntryValuesCompanion Function({
      Value<String> id,
      Value<String> entryId,
      Value<String> valueType,
      Value<double?> numberValue,
      Value<double?> normalizedNumberValue,
      Value<String> unitKey,
      Value<String> unitLabel,
      Value<int?> durationSeconds,
      Value<int?> timeMinutes,
      Value<int> dayOffset,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskEntryValuesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskEntryValuesTable, TaskEntryValue> {
  $$TaskEntryValuesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskEntriesTable _entryIdTable(_$AppDatabase db) =>
      db.taskEntries.createAlias(
        $_aliasNameGenerator(db.taskEntryValues.entryId, db.taskEntries.id),
      );

  $$TaskEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskEntryValuesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskEntryValuesTable> {
  $$TaskEntryValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get numberValue => $composableBuilder(
    column: $table.numberValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get normalizedNumberValue => $composableBuilder(
    column: $table.normalizedNumberValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitKey => $composableBuilder(
    column: $table.unitKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitLabel => $composableBuilder(
    column: $table.unitLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOffset => $composableBuilder(
    column: $table.dayOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskEntriesTableFilterComposer get entryId {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntryValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskEntryValuesTable> {
  $$TaskEntryValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get numberValue => $composableBuilder(
    column: $table.numberValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get normalizedNumberValue => $composableBuilder(
    column: $table.normalizedNumberValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitKey => $composableBuilder(
    column: $table.unitKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitLabel => $composableBuilder(
    column: $table.unitLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOffset => $composableBuilder(
    column: $table.dayOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskEntriesTableOrderingComposer get entryId {
    final $$TaskEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntryValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskEntryValuesTable> {
  $$TaskEntryValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<double> get numberValue => $composableBuilder(
    column: $table.numberValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get normalizedNumberValue => $composableBuilder(
    column: $table.normalizedNumberValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitKey =>
      $composableBuilder(column: $table.unitKey, builder: (column) => column);

  GeneratedColumn<String> get unitLabel =>
      $composableBuilder(column: $table.unitLabel, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeMinutes => $composableBuilder(
    column: $table.timeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOffset =>
      $composableBuilder(column: $table.dayOffset, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TaskEntriesTableAnnotationComposer get entryId {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskEntryValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskEntryValuesTable,
          TaskEntryValue,
          $$TaskEntryValuesTableFilterComposer,
          $$TaskEntryValuesTableOrderingComposer,
          $$TaskEntryValuesTableAnnotationComposer,
          $$TaskEntryValuesTableCreateCompanionBuilder,
          $$TaskEntryValuesTableUpdateCompanionBuilder,
          (TaskEntryValue, $$TaskEntryValuesTableReferences),
          TaskEntryValue,
          PrefetchHooks Function({bool entryId})
        > {
  $$TaskEntryValuesTableTableManager(
    _$AppDatabase db,
    $TaskEntryValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$TaskEntryValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TaskEntryValuesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskEntryValuesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<double?> numberValue = const Value.absent(),
                Value<double?> normalizedNumberValue = const Value.absent(),
                Value<String> unitKey = const Value.absent(),
                Value<String> unitLabel = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int?> timeMinutes = const Value.absent(),
                Value<int> dayOffset = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskEntryValuesCompanion(
                id: id,
                entryId: entryId,
                valueType: valueType,
                numberValue: numberValue,
                normalizedNumberValue: normalizedNumberValue,
                unitKey: unitKey,
                unitLabel: unitLabel,
                durationSeconds: durationSeconds,
                timeMinutes: timeMinutes,
                dayOffset: dayOffset,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entryId,
                required String valueType,
                Value<double?> numberValue = const Value.absent(),
                Value<double?> normalizedNumberValue = const Value.absent(),
                Value<String> unitKey = const Value.absent(),
                Value<String> unitLabel = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int?> timeMinutes = const Value.absent(),
                Value<int> dayOffset = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskEntryValuesCompanion.insert(
                id: id,
                entryId: entryId,
                valueType: valueType,
                numberValue: numberValue,
                normalizedNumberValue: normalizedNumberValue,
                unitKey: unitKey,
                unitLabel: unitLabel,
                durationSeconds: durationSeconds,
                timeMinutes: timeMinutes,
                dayOffset: dayOffset,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskEntryValuesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (entryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable: $$TaskEntryValuesTableReferences
                                ._entryIdTable(db),
                            referencedColumn:
                                $$TaskEntryValuesTableReferences
                                    ._entryIdTable(db)
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

typedef $$TaskEntryValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskEntryValuesTable,
      TaskEntryValue,
      $$TaskEntryValuesTableFilterComposer,
      $$TaskEntryValuesTableOrderingComposer,
      $$TaskEntryValuesTableAnnotationComposer,
      $$TaskEntryValuesTableCreateCompanionBuilder,
      $$TaskEntryValuesTableUpdateCompanionBuilder,
      (TaskEntryValue, $$TaskEntryValuesTableReferences),
      TaskEntryValue,
      PrefetchHooks Function({bool entryId})
    >;
typedef $$TaskValueBundlesTableCreateCompanionBuilder =
    TaskValueBundlesCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      required DateTime updatedAt,
      Value<String?> projectId,
      Value<bool> isActive,
      Value<DateTime?> trashedAt,
      Value<DateTime?> purgeAt,
      Value<int> lifecycleRevision,
      Value<DateTime?> lifecycleUpdatedAt,
      Value<int> rowid,
    });
typedef $$TaskValueBundlesTableUpdateCompanionBuilder =
    TaskValueBundlesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> projectId,
      Value<bool> isActive,
      Value<DateTime?> trashedAt,
      Value<DateTime?> purgeAt,
      Value<int> lifecycleRevision,
      Value<DateTime?> lifecycleUpdatedAt,
      Value<int> rowid,
    });

final class $$TaskValueBundlesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskValueBundlesTable, TaskValueBundle> {
  $$TaskValueBundlesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.taskValueBundles.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TaskValueBundleVersionsTable,
    List<TaskValueBundleVersion>
  >
  _taskValueBundleVersionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskValueBundleVersions,
        aliasName: $_aliasNameGenerator(
          db.taskValueBundles.id,
          db.taskValueBundleVersions.bundleId,
        ),
      );

  $$TaskValueBundleVersionsTableProcessedTableManager
  get taskValueBundleVersionsRefs {
    final manager = $$TaskValueBundleVersionsTableTableManager(
      $_db,
      $_db.taskValueBundleVersions,
    ).filter((f) => f.bundleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskValueBundleVersionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskCardMetricPreferencesTable,
    List<TaskCardMetricPreference>
  >
  _taskCardMetricPreferencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskCardMetricPreferences,
        aliasName: $_aliasNameGenerator(
          db.taskValueBundles.id,
          db.taskCardMetricPreferences.bundleId,
        ),
      );

  $$TaskCardMetricPreferencesTableProcessedTableManager
  get taskCardMetricPreferencesRefs {
    final manager = $$TaskCardMetricPreferencesTableTableManager(
      $_db,
      $_db.taskCardMetricPreferences,
    ).filter((f) => f.bundleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCardMetricPreferencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TaskProjectAssignmentChangesTable,
    List<TaskProjectAssignmentChange>
  >
  _taskProjectAssignmentChangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskProjectAssignmentChanges,
        aliasName: $_aliasNameGenerator(
          db.taskValueBundles.id,
          db.taskProjectAssignmentChanges.bundleId,
        ),
      );

  $$TaskProjectAssignmentChangesTableProcessedTableManager
  get taskProjectAssignmentChangesRefs {
    final manager = $$TaskProjectAssignmentChangesTableTableManager(
      $_db,
      $_db.taskProjectAssignmentChanges,
    ).filter((f) => f.bundleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskProjectAssignmentChangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskValueBundlesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskValueBundlesTable> {
  $$TaskValueBundlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purgeAt => $composableBuilder(
    column: $table.purgeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lifecycleUpdatedAt => $composableBuilder(
    column: $table.lifecycleUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskValueBundleVersionsRefs(
    Expression<bool> Function($$TaskValueBundleVersionsTableFilterComposer f) f,
  ) {
    final $$TaskValueBundleVersionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskValueBundleVersions,
          getReferencedColumn: (t) => t.bundleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskValueBundleVersionsTableFilterComposer(
                $db: $db,
                $table: $db.taskValueBundleVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskCardMetricPreferencesRefs(
    Expression<bool> Function($$TaskCardMetricPreferencesTableFilterComposer f)
    f,
  ) {
    final $$TaskCardMetricPreferencesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCardMetricPreferences,
          getReferencedColumn: (t) => t.bundleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCardMetricPreferencesTableFilterComposer(
                $db: $db,
                $table: $db.taskCardMetricPreferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> taskProjectAssignmentChangesRefs(
    Expression<bool> Function(
      $$TaskProjectAssignmentChangesTableFilterComposer f,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.bundleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableFilterComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskValueBundlesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskValueBundlesTable> {
  $$TaskValueBundlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purgeAt => $composableBuilder(
    column: $table.purgeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lifecycleUpdatedAt => $composableBuilder(
    column: $table.lifecycleUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskValueBundlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskValueBundlesTable> {
  $$TaskValueBundlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get purgeAt =>
      $composableBuilder(column: $table.purgeAt, builder: (column) => column);

  GeneratedColumn<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lifecycleUpdatedAt => $composableBuilder(
    column: $table.lifecycleUpdatedAt,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskValueBundleVersionsRefs<T extends Object>(
    Expression<T> Function($$TaskValueBundleVersionsTableAnnotationComposer a)
    f,
  ) {
    final $$TaskValueBundleVersionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskValueBundleVersions,
          getReferencedColumn: (t) => t.bundleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskValueBundleVersionsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskValueBundleVersions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskCardMetricPreferencesRefs<T extends Object>(
    Expression<T> Function($$TaskCardMetricPreferencesTableAnnotationComposer a)
    f,
  ) {
    final $$TaskCardMetricPreferencesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCardMetricPreferences,
          getReferencedColumn: (t) => t.bundleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCardMetricPreferencesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCardMetricPreferences,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> taskProjectAssignmentChangesRefs<T extends Object>(
    Expression<T> Function(
      $$TaskProjectAssignmentChangesTableAnnotationComposer a,
    )
    f,
  ) {
    final $$TaskProjectAssignmentChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskProjectAssignmentChanges,
          getReferencedColumn: (t) => t.bundleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskProjectAssignmentChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.taskProjectAssignmentChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskValueBundlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskValueBundlesTable,
          TaskValueBundle,
          $$TaskValueBundlesTableFilterComposer,
          $$TaskValueBundlesTableOrderingComposer,
          $$TaskValueBundlesTableAnnotationComposer,
          $$TaskValueBundlesTableCreateCompanionBuilder,
          $$TaskValueBundlesTableUpdateCompanionBuilder,
          (TaskValueBundle, $$TaskValueBundlesTableReferences),
          TaskValueBundle,
          PrefetchHooks Function({
            bool projectId,
            bool taskValueBundleVersionsRefs,
            bool taskCardMetricPreferencesRefs,
            bool taskProjectAssignmentChangesRefs,
          })
        > {
  $$TaskValueBundlesTableTableManager(
    _$AppDatabase db,
    $TaskValueBundlesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$TaskValueBundlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TaskValueBundlesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskValueBundlesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime?> purgeAt = const Value.absent(),
                Value<int> lifecycleRevision = const Value.absent(),
                Value<DateTime?> lifecycleUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskValueBundlesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                isActive: isActive,
                trashedAt: trashedAt,
                purgeAt: purgeAt,
                lifecycleRevision: lifecycleRevision,
                lifecycleUpdatedAt: lifecycleUpdatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                required DateTime updatedAt,
                Value<String?> projectId = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> trashedAt = const Value.absent(),
                Value<DateTime?> purgeAt = const Value.absent(),
                Value<int> lifecycleRevision = const Value.absent(),
                Value<DateTime?> lifecycleUpdatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskValueBundlesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                projectId: projectId,
                isActive: isActive,
                trashedAt: trashedAt,
                purgeAt: purgeAt,
                lifecycleRevision: lifecycleRevision,
                lifecycleUpdatedAt: lifecycleUpdatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskValueBundlesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            projectId = false,
            taskValueBundleVersionsRefs = false,
            taskCardMetricPreferencesRefs = false,
            taskProjectAssignmentChangesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskValueBundleVersionsRefs) db.taskValueBundleVersions,
                if (taskCardMetricPreferencesRefs) db.taskCardMetricPreferences,
                if (taskProjectAssignmentChangesRefs)
                  db.taskProjectAssignmentChanges,
              ],
              addJoins: <
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
                if (projectId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable: $$TaskValueBundlesTableReferences
                                ._projectIdTable(db),
                            referencedColumn:
                                $$TaskValueBundlesTableReferences
                                    ._projectIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskValueBundleVersionsRefs)
                    await $_getPrefetchedData<
                      TaskValueBundle,
                      $TaskValueBundlesTable,
                      TaskValueBundleVersion
                    >(
                      currentTable: table,
                      referencedTable: $$TaskValueBundlesTableReferences
                          ._taskValueBundleVersionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskValueBundlesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskValueBundleVersionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.bundleId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (taskCardMetricPreferencesRefs)
                    await $_getPrefetchedData<
                      TaskValueBundle,
                      $TaskValueBundlesTable,
                      TaskCardMetricPreference
                    >(
                      currentTable: table,
                      referencedTable: $$TaskValueBundlesTableReferences
                          ._taskCardMetricPreferencesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskValueBundlesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCardMetricPreferencesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.bundleId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (taskProjectAssignmentChangesRefs)
                    await $_getPrefetchedData<
                      TaskValueBundle,
                      $TaskValueBundlesTable,
                      TaskProjectAssignmentChange
                    >(
                      currentTable: table,
                      referencedTable: $$TaskValueBundlesTableReferences
                          ._taskProjectAssignmentChangesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskValueBundlesTableReferences(
                                db,
                                table,
                                p0,
                              ).taskProjectAssignmentChangesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.bundleId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskValueBundlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskValueBundlesTable,
      TaskValueBundle,
      $$TaskValueBundlesTableFilterComposer,
      $$TaskValueBundlesTableOrderingComposer,
      $$TaskValueBundlesTableAnnotationComposer,
      $$TaskValueBundlesTableCreateCompanionBuilder,
      $$TaskValueBundlesTableUpdateCompanionBuilder,
      (TaskValueBundle, $$TaskValueBundlesTableReferences),
      TaskValueBundle,
      PrefetchHooks Function({
        bool projectId,
        bool taskValueBundleVersionsRefs,
        bool taskCardMetricPreferencesRefs,
        bool taskProjectAssignmentChangesRefs,
      })
    >;
typedef $$TaskValueBundleVersionsTableCreateCompanionBuilder =
    TaskValueBundleVersionsCompanion Function({
      required String id,
      required String bundleId,
      required int versionNumber,
      Value<String?> previousVersionId,
      required DateTime validFrom,
      Value<DateTime?> validTo,
      Value<DateTime?> cancelledAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<String> name,
      Value<String> description,
      required String bundleType,
      required String firstTaskId,
      required String secondTaskId,
      Value<String> firstRoleLabel,
      Value<String> secondRoleLabel,
      Value<String> resultLabel,
      Value<String> direction,
      Value<String> displayMode,
      Value<String> goalType,
      Value<int> goalValue,
      Value<int?> goalWindowDays,
      Value<int> firstTaskDayOffset,
      Value<int> secondTaskDayOffset,
      Value<int> rowid,
    });
typedef $$TaskValueBundleVersionsTableUpdateCompanionBuilder =
    TaskValueBundleVersionsCompanion Function({
      Value<String> id,
      Value<String> bundleId,
      Value<int> versionNumber,
      Value<String?> previousVersionId,
      Value<DateTime> validFrom,
      Value<DateTime?> validTo,
      Value<DateTime?> cancelledAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<String> name,
      Value<String> description,
      Value<String> bundleType,
      Value<String> firstTaskId,
      Value<String> secondTaskId,
      Value<String> firstRoleLabel,
      Value<String> secondRoleLabel,
      Value<String> resultLabel,
      Value<String> direction,
      Value<String> displayMode,
      Value<String> goalType,
      Value<int> goalValue,
      Value<int?> goalWindowDays,
      Value<int> firstTaskDayOffset,
      Value<int> secondTaskDayOffset,
      Value<int> rowid,
    });

final class $$TaskValueBundleVersionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskValueBundleVersionsTable,
          TaskValueBundleVersion
        > {
  $$TaskValueBundleVersionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskValueBundlesTable _bundleIdTable(_$AppDatabase db) =>
      db.taskValueBundles.createAlias(
        $_aliasNameGenerator(
          db.taskValueBundleVersions.bundleId,
          db.taskValueBundles.id,
        ),
      );

  $$TaskValueBundlesTableProcessedTableManager get bundleId {
    final $_column = $_itemColumn<String>('bundle_id')!;

    final manager = $$TaskValueBundlesTableTableManager(
      $_db,
      $_db.taskValueBundles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bundleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskValueBundleVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskValueBundleVersionsTable> {
  $$TaskValueBundleVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousVersionId => $composableBuilder(
    column: $table.previousVersionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bundleType => $composableBuilder(
    column: $table.bundleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstTaskId => $composableBuilder(
    column: $table.firstTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondTaskId => $composableBuilder(
    column: $table.secondTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstRoleLabel => $composableBuilder(
    column: $table.firstRoleLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondRoleLabel => $composableBuilder(
    column: $table.secondRoleLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultLabel => $composableBuilder(
    column: $table.resultLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstTaskDayOffset => $composableBuilder(
    column: $table.firstTaskDayOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get secondTaskDayOffset => $composableBuilder(
    column: $table.secondTaskDayOffset,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskValueBundlesTableFilterComposer get bundleId {
    final $$TaskValueBundlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableFilterComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskValueBundleVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskValueBundleVersionsTable> {
  $$TaskValueBundleVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousVersionId => $composableBuilder(
    column: $table.previousVersionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bundleType => $composableBuilder(
    column: $table.bundleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstTaskId => $composableBuilder(
    column: $table.firstTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondTaskId => $composableBuilder(
    column: $table.secondTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstRoleLabel => $composableBuilder(
    column: $table.firstRoleLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondRoleLabel => $composableBuilder(
    column: $table.secondRoleLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultLabel => $composableBuilder(
    column: $table.resultLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalValue => $composableBuilder(
    column: $table.goalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstTaskDayOffset => $composableBuilder(
    column: $table.firstTaskDayOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get secondTaskDayOffset => $composableBuilder(
    column: $table.secondTaskDayOffset,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskValueBundlesTableOrderingComposer get bundleId {
    final $$TaskValueBundlesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableOrderingComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskValueBundleVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskValueBundleVersionsTable> {
  $$TaskValueBundleVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousVersionId => $composableBuilder(
    column: $table.previousVersionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bundleType => $composableBuilder(
    column: $table.bundleType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstTaskId => $composableBuilder(
    column: $table.firstTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondTaskId => $composableBuilder(
    column: $table.secondTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstRoleLabel => $composableBuilder(
    column: $table.firstRoleLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondRoleLabel => $composableBuilder(
    column: $table.secondRoleLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resultLabel => $composableBuilder(
    column: $table.resultLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get goalValue =>
      $composableBuilder(column: $table.goalValue, builder: (column) => column);

  GeneratedColumn<int> get goalWindowDays => $composableBuilder(
    column: $table.goalWindowDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstTaskDayOffset => $composableBuilder(
    column: $table.firstTaskDayOffset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get secondTaskDayOffset => $composableBuilder(
    column: $table.secondTaskDayOffset,
    builder: (column) => column,
  );

  $$TaskValueBundlesTableAnnotationComposer get bundleId {
    final $$TaskValueBundlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskValueBundleVersionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskValueBundleVersionsTable,
          TaskValueBundleVersion,
          $$TaskValueBundleVersionsTableFilterComposer,
          $$TaskValueBundleVersionsTableOrderingComposer,
          $$TaskValueBundleVersionsTableAnnotationComposer,
          $$TaskValueBundleVersionsTableCreateCompanionBuilder,
          $$TaskValueBundleVersionsTableUpdateCompanionBuilder,
          (TaskValueBundleVersion, $$TaskValueBundleVersionsTableReferences),
          TaskValueBundleVersion,
          PrefetchHooks Function({bool bundleId})
        > {
  $$TaskValueBundleVersionsTableTableManager(
    _$AppDatabase db,
    $TaskValueBundleVersionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskValueBundleVersionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskValueBundleVersionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskValueBundleVersionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bundleId = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<String?> previousVersionId = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> bundleType = const Value.absent(),
                Value<String> firstTaskId = const Value.absent(),
                Value<String> secondTaskId = const Value.absent(),
                Value<String> firstRoleLabel = const Value.absent(),
                Value<String> secondRoleLabel = const Value.absent(),
                Value<String> resultLabel = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> displayMode = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> goalValue = const Value.absent(),
                Value<int?> goalWindowDays = const Value.absent(),
                Value<int> firstTaskDayOffset = const Value.absent(),
                Value<int> secondTaskDayOffset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskValueBundleVersionsCompanion(
                id: id,
                bundleId: bundleId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                validFrom: validFrom,
                validTo: validTo,
                cancelledAt: cancelledAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                description: description,
                bundleType: bundleType,
                firstTaskId: firstTaskId,
                secondTaskId: secondTaskId,
                firstRoleLabel: firstRoleLabel,
                secondRoleLabel: secondRoleLabel,
                resultLabel: resultLabel,
                direction: direction,
                displayMode: displayMode,
                goalType: goalType,
                goalValue: goalValue,
                goalWindowDays: goalWindowDays,
                firstTaskDayOffset: firstTaskDayOffset,
                secondTaskDayOffset: secondTaskDayOffset,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bundleId,
                required int versionNumber,
                Value<String?> previousVersionId = const Value.absent(),
                required DateTime validFrom,
                Value<DateTime?> validTo = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                required String bundleType,
                required String firstTaskId,
                required String secondTaskId,
                Value<String> firstRoleLabel = const Value.absent(),
                Value<String> secondRoleLabel = const Value.absent(),
                Value<String> resultLabel = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> displayMode = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> goalValue = const Value.absent(),
                Value<int?> goalWindowDays = const Value.absent(),
                Value<int> firstTaskDayOffset = const Value.absent(),
                Value<int> secondTaskDayOffset = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskValueBundleVersionsCompanion.insert(
                id: id,
                bundleId: bundleId,
                versionNumber: versionNumber,
                previousVersionId: previousVersionId,
                validFrom: validFrom,
                validTo: validTo,
                cancelledAt: cancelledAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                name: name,
                description: description,
                bundleType: bundleType,
                firstTaskId: firstTaskId,
                secondTaskId: secondTaskId,
                firstRoleLabel: firstRoleLabel,
                secondRoleLabel: secondRoleLabel,
                resultLabel: resultLabel,
                direction: direction,
                displayMode: displayMode,
                goalType: goalType,
                goalValue: goalValue,
                goalWindowDays: goalWindowDays,
                firstTaskDayOffset: firstTaskDayOffset,
                secondTaskDayOffset: secondTaskDayOffset,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskValueBundleVersionsTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({bundleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (bundleId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.bundleId,
                            referencedTable:
                                $$TaskValueBundleVersionsTableReferences
                                    ._bundleIdTable(db),
                            referencedColumn:
                                $$TaskValueBundleVersionsTableReferences
                                    ._bundleIdTable(db)
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

typedef $$TaskValueBundleVersionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskValueBundleVersionsTable,
      TaskValueBundleVersion,
      $$TaskValueBundleVersionsTableFilterComposer,
      $$TaskValueBundleVersionsTableOrderingComposer,
      $$TaskValueBundleVersionsTableAnnotationComposer,
      $$TaskValueBundleVersionsTableCreateCompanionBuilder,
      $$TaskValueBundleVersionsTableUpdateCompanionBuilder,
      (TaskValueBundleVersion, $$TaskValueBundleVersionsTableReferences),
      TaskValueBundleVersion,
      PrefetchHooks Function({bool bundleId})
    >;
typedef $$TaskCardMetricPreferencesTableCreateCompanionBuilder =
    TaskCardMetricPreferencesCompanion Function({
      required String id,
      Value<String?> taskId,
      Value<String?> bundleId,
      required String configJson,
      Value<bool> isReset,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TaskCardMetricPreferencesTableUpdateCompanionBuilder =
    TaskCardMetricPreferencesCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<String?> bundleId,
      Value<String> configJson,
      Value<bool> isReset,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskCardMetricPreferencesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskCardMetricPreferencesTable,
          TaskCardMetricPreference
        > {
  $$TaskCardMetricPreferencesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AufgabenTable _taskIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(
          db.taskCardMetricPreferences.taskId,
          db.aufgaben.id,
        ),
      );

  $$AufgabenTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskValueBundlesTable _bundleIdTable(_$AppDatabase db) =>
      db.taskValueBundles.createAlias(
        $_aliasNameGenerator(
          db.taskCardMetricPreferences.bundleId,
          db.taskValueBundles.id,
        ),
      );

  $$TaskValueBundlesTableProcessedTableManager? get bundleId {
    final $_column = $_itemColumn<String>('bundle_id');
    if ($_column == null) return null;
    final manager = $$TaskValueBundlesTableTableManager(
      $_db,
      $_db.taskValueBundles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bundleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskCardMetricPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCardMetricPreferencesTable> {
  $$TaskCardMetricPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReset => $composableBuilder(
    column: $table.isReset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskValueBundlesTableFilterComposer get bundleId {
    final $$TaskValueBundlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableFilterComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCardMetricPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCardMetricPreferencesTable> {
  $$TaskCardMetricPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReset => $composableBuilder(
    column: $table.isReset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskValueBundlesTableOrderingComposer get bundleId {
    final $$TaskValueBundlesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableOrderingComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCardMetricPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCardMetricPreferencesTable> {
  $$TaskCardMetricPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isReset =>
      $composableBuilder(column: $table.isReset, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskValueBundlesTableAnnotationComposer get bundleId {
    final $$TaskValueBundlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCardMetricPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCardMetricPreferencesTable,
          TaskCardMetricPreference,
          $$TaskCardMetricPreferencesTableFilterComposer,
          $$TaskCardMetricPreferencesTableOrderingComposer,
          $$TaskCardMetricPreferencesTableAnnotationComposer,
          $$TaskCardMetricPreferencesTableCreateCompanionBuilder,
          $$TaskCardMetricPreferencesTableUpdateCompanionBuilder,
          (
            TaskCardMetricPreference,
            $$TaskCardMetricPreferencesTableReferences,
          ),
          TaskCardMetricPreference,
          PrefetchHooks Function({bool taskId, bool bundleId})
        > {
  $$TaskCardMetricPreferencesTableTableManager(
    _$AppDatabase db,
    $TaskCardMetricPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskCardMetricPreferencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskCardMetricPreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskCardMetricPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> bundleId = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<bool> isReset = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCardMetricPreferencesCompanion(
                id: id,
                taskId: taskId,
                bundleId: bundleId,
                configJson: configJson,
                isReset: isReset,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                Value<String?> bundleId = const Value.absent(),
                required String configJson,
                Value<bool> isReset = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskCardMetricPreferencesCompanion.insert(
                id: id,
                taskId: taskId,
                bundleId: bundleId,
                configJson: configJson,
                isReset: isReset,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskCardMetricPreferencesTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({taskId = false, bundleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$TaskCardMetricPreferencesTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$TaskCardMetricPreferencesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (bundleId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.bundleId,
                            referencedTable:
                                $$TaskCardMetricPreferencesTableReferences
                                    ._bundleIdTable(db),
                            referencedColumn:
                                $$TaskCardMetricPreferencesTableReferences
                                    ._bundleIdTable(db)
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

typedef $$TaskCardMetricPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCardMetricPreferencesTable,
      TaskCardMetricPreference,
      $$TaskCardMetricPreferencesTableFilterComposer,
      $$TaskCardMetricPreferencesTableOrderingComposer,
      $$TaskCardMetricPreferencesTableAnnotationComposer,
      $$TaskCardMetricPreferencesTableCreateCompanionBuilder,
      $$TaskCardMetricPreferencesTableUpdateCompanionBuilder,
      (TaskCardMetricPreference, $$TaskCardMetricPreferencesTableReferences),
      TaskCardMetricPreference,
      PrefetchHooks Function({bool taskId, bool bundleId})
    >;
typedef $$TaskPendingDefinitionChangesTableCreateCompanionBuilder =
    TaskPendingDefinitionChangesCompanion Function({
      required String id,
      required String taskId,
      required String groupKey,
      required DateTime effectiveDate,
      required String payloadJson,
      Value<int> payloadVersion,
      Value<String> state,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskPendingDefinitionChangesTableUpdateCompanionBuilder =
    TaskPendingDefinitionChangesCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> groupKey,
      Value<DateTime> effectiveDate,
      Value<String> payloadJson,
      Value<int> payloadVersion,
      Value<String> state,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskPendingDefinitionChangesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskPendingDefinitionChangesTable,
          TaskPendingDefinitionChange
        > {
  $$TaskPendingDefinitionChangesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AufgabenTable _taskIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(
          db.taskPendingDefinitionChanges.taskId,
          db.aufgaben.id,
        ),
      );

  $$AufgabenTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskPendingDefinitionChangesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskPendingDefinitionChangesTable> {
  $$TaskPendingDefinitionChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupKey => $composableBuilder(
    column: $table.groupKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskPendingDefinitionChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskPendingDefinitionChangesTable> {
  $$TaskPendingDefinitionChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupKey => $composableBuilder(
    column: $table.groupKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskPendingDefinitionChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskPendingDefinitionChangesTable> {
  $$TaskPendingDefinitionChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupKey =>
      $composableBuilder(column: $table.groupKey, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskPendingDefinitionChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskPendingDefinitionChangesTable,
          TaskPendingDefinitionChange,
          $$TaskPendingDefinitionChangesTableFilterComposer,
          $$TaskPendingDefinitionChangesTableOrderingComposer,
          $$TaskPendingDefinitionChangesTableAnnotationComposer,
          $$TaskPendingDefinitionChangesTableCreateCompanionBuilder,
          $$TaskPendingDefinitionChangesTableUpdateCompanionBuilder,
          (
            TaskPendingDefinitionChange,
            $$TaskPendingDefinitionChangesTableReferences,
          ),
          TaskPendingDefinitionChange,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskPendingDefinitionChangesTableTableManager(
    _$AppDatabase db,
    $TaskPendingDefinitionChangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskPendingDefinitionChangesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskPendingDefinitionChangesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskPendingDefinitionChangesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> groupKey = const Value.absent(),
                Value<DateTime> effectiveDate = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPendingDefinitionChangesCompanion(
                id: id,
                taskId: taskId,
                groupKey: groupKey,
                effectiveDate: effectiveDate,
                payloadJson: payloadJson,
                payloadVersion: payloadVersion,
                state: state,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String groupKey,
                required DateTime effectiveDate,
                required String payloadJson,
                Value<int> payloadVersion = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPendingDefinitionChangesCompanion.insert(
                id: id,
                taskId: taskId,
                groupKey: groupKey,
                effectiveDate: effectiveDate,
                payloadJson: payloadJson,
                payloadVersion: payloadVersion,
                state: state,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskPendingDefinitionChangesTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$TaskPendingDefinitionChangesTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$TaskPendingDefinitionChangesTableReferences
                                    ._taskIdTable(db)
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

typedef $$TaskPendingDefinitionChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskPendingDefinitionChangesTable,
      TaskPendingDefinitionChange,
      $$TaskPendingDefinitionChangesTableFilterComposer,
      $$TaskPendingDefinitionChangesTableOrderingComposer,
      $$TaskPendingDefinitionChangesTableAnnotationComposer,
      $$TaskPendingDefinitionChangesTableCreateCompanionBuilder,
      $$TaskPendingDefinitionChangesTableUpdateCompanionBuilder,
      (
        TaskPendingDefinitionChange,
        $$TaskPendingDefinitionChangesTableReferences,
      ),
      TaskPendingDefinitionChange,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TaskProjectAssignmentChangesTableCreateCompanionBuilder =
    TaskProjectAssignmentChangesCompanion Function({
      required String id,
      Value<String?> taskId,
      Value<String?> bundleId,
      Value<String?> targetProjectId,
      Value<String?> previousProjectId,
      required String scope,
      required DateTime effectiveDate,
      required int sequence,
      Value<String> state,
      Value<String> origin,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskProjectAssignmentChangesTableUpdateCompanionBuilder =
    TaskProjectAssignmentChangesCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<String?> bundleId,
      Value<String?> targetProjectId,
      Value<String?> previousProjectId,
      Value<String> scope,
      Value<DateTime> effectiveDate,
      Value<int> sequence,
      Value<String> state,
      Value<String> origin,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskProjectAssignmentChangesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskProjectAssignmentChangesTable,
          TaskProjectAssignmentChange
        > {
  $$TaskProjectAssignmentChangesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AufgabenTable _taskIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(
          db.taskProjectAssignmentChanges.taskId,
          db.aufgaben.id,
        ),
      );

  $$AufgabenTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskValueBundlesTable _bundleIdTable(_$AppDatabase db) =>
      db.taskValueBundles.createAlias(
        $_aliasNameGenerator(
          db.taskProjectAssignmentChanges.bundleId,
          db.taskValueBundles.id,
        ),
      );

  $$TaskValueBundlesTableProcessedTableManager? get bundleId {
    final $_column = $_itemColumn<String>('bundle_id');
    if ($_column == null) return null;
    final manager = $$TaskValueBundlesTableTableManager(
      $_db,
      $_db.taskValueBundles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bundleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _targetProjectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(
          db.taskProjectAssignmentChanges.targetProjectId,
          db.projects.id,
        ),
      );

  $$ProjectsTableProcessedTableManager? get targetProjectId {
    final $_column = $_itemColumn<String>('target_project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetProjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _previousProjectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(
          db.taskProjectAssignmentChanges.previousProjectId,
          db.projects.id,
        ),
      );

  $$ProjectsTableProcessedTableManager? get previousProjectId {
    final $_column = $_itemColumn<String>('previous_project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_previousProjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskProjectAssignmentChangesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskProjectAssignmentChangesTable> {
  $$TaskProjectAssignmentChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskValueBundlesTableFilterComposer get bundleId {
    final $$TaskValueBundlesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableFilterComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get targetProjectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get previousProjectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskProjectAssignmentChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskProjectAssignmentChangesTable> {
  $$TaskProjectAssignmentChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskValueBundlesTableOrderingComposer get bundleId {
    final $$TaskValueBundlesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableOrderingComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get targetProjectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get previousProjectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskProjectAssignmentChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskProjectAssignmentChangesTable> {
  $$TaskProjectAssignmentChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TaskValueBundlesTableAnnotationComposer get bundleId {
    final $$TaskValueBundlesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bundleId,
      referencedTable: $db.taskValueBundles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskValueBundlesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskValueBundles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get targetProjectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get previousProjectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.previousProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskProjectAssignmentChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskProjectAssignmentChangesTable,
          TaskProjectAssignmentChange,
          $$TaskProjectAssignmentChangesTableFilterComposer,
          $$TaskProjectAssignmentChangesTableOrderingComposer,
          $$TaskProjectAssignmentChangesTableAnnotationComposer,
          $$TaskProjectAssignmentChangesTableCreateCompanionBuilder,
          $$TaskProjectAssignmentChangesTableUpdateCompanionBuilder,
          (
            TaskProjectAssignmentChange,
            $$TaskProjectAssignmentChangesTableReferences,
          ),
          TaskProjectAssignmentChange,
          PrefetchHooks Function({
            bool taskId,
            bool bundleId,
            bool targetProjectId,
            bool previousProjectId,
          })
        > {
  $$TaskProjectAssignmentChangesTableTableManager(
    _$AppDatabase db,
    $TaskProjectAssignmentChangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskProjectAssignmentChangesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskProjectAssignmentChangesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskProjectAssignmentChangesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> bundleId = const Value.absent(),
                Value<String?> targetProjectId = const Value.absent(),
                Value<String?> previousProjectId = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<DateTime> effectiveDate = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskProjectAssignmentChangesCompanion(
                id: id,
                taskId: taskId,
                bundleId: bundleId,
                targetProjectId: targetProjectId,
                previousProjectId: previousProjectId,
                scope: scope,
                effectiveDate: effectiveDate,
                sequence: sequence,
                state: state,
                origin: origin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                Value<String?> bundleId = const Value.absent(),
                Value<String?> targetProjectId = const Value.absent(),
                Value<String?> previousProjectId = const Value.absent(),
                required String scope,
                required DateTime effectiveDate,
                required int sequence,
                Value<String> state = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskProjectAssignmentChangesCompanion.insert(
                id: id,
                taskId: taskId,
                bundleId: bundleId,
                targetProjectId: targetProjectId,
                previousProjectId: previousProjectId,
                scope: scope,
                effectiveDate: effectiveDate,
                sequence: sequence,
                state: state,
                origin: origin,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskProjectAssignmentChangesTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            taskId = false,
            bundleId = false,
            targetProjectId = false,
            previousProjectId = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (bundleId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.bundleId,
                            referencedTable:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._bundleIdTable(db),
                            referencedColumn:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._bundleIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (targetProjectId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.targetProjectId,
                            referencedTable:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._targetProjectIdTable(db),
                            referencedColumn:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._targetProjectIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (previousProjectId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.previousProjectId,
                            referencedTable:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._previousProjectIdTable(db),
                            referencedColumn:
                                $$TaskProjectAssignmentChangesTableReferences
                                    ._previousProjectIdTable(db)
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

typedef $$TaskProjectAssignmentChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskProjectAssignmentChangesTable,
      TaskProjectAssignmentChange,
      $$TaskProjectAssignmentChangesTableFilterComposer,
      $$TaskProjectAssignmentChangesTableOrderingComposer,
      $$TaskProjectAssignmentChangesTableAnnotationComposer,
      $$TaskProjectAssignmentChangesTableCreateCompanionBuilder,
      $$TaskProjectAssignmentChangesTableUpdateCompanionBuilder,
      (
        TaskProjectAssignmentChange,
        $$TaskProjectAssignmentChangesTableReferences,
      ),
      TaskProjectAssignmentChange,
      PrefetchHooks Function({
        bool taskId,
        bool bundleId,
        bool targetProjectId,
        bool previousProjectId,
      })
    >;
typedef $$TaskCorrectionOperationsTableCreateCompanionBuilder =
    TaskCorrectionOperationsCompanion Function({
      required String id,
      required String taskId,
      required String type,
      Value<String> state,
      Value<int> payloadVersion,
      Value<String> reason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskCorrectionOperationsTableUpdateCompanionBuilder =
    TaskCorrectionOperationsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> type,
      Value<String> state,
      Value<int> payloadVersion,
      Value<String> reason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskCorrectionOperationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskCorrectionOperationsTable,
          TaskCorrectionOperation
        > {
  $$TaskCorrectionOperationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AufgabenTable _taskIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(
          db.taskCorrectionOperations.taskId,
          db.aufgaben.id,
        ),
      );

  $$AufgabenTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TaskCorrectionItemsTable,
    List<TaskCorrectionItem>
  >
  _taskCorrectionItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskCorrectionItems,
        aliasName: $_aliasNameGenerator(
          db.taskCorrectionOperations.id,
          db.taskCorrectionItems.operationId,
        ),
      );

  $$TaskCorrectionItemsTableProcessedTableManager get taskCorrectionItemsRefs {
    final manager = $$TaskCorrectionItemsTableTableManager(
      $_db,
      $_db.taskCorrectionItems,
    ).filter((f) => f.operationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskCorrectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskCorrectionOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCorrectionOperationsTable> {
  $$TaskCorrectionOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskCorrectionItemsRefs(
    Expression<bool> Function($$TaskCorrectionItemsTableFilterComposer f) f,
  ) {
    final $$TaskCorrectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskCorrectionItems,
      getReferencedColumn: (t) => t.operationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCorrectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.taskCorrectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskCorrectionOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCorrectionOperationsTable> {
  $$TaskCorrectionOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCorrectionOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCorrectionOperationsTable> {
  $$TaskCorrectionOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get payloadVersion => $composableBuilder(
    column: $table.payloadVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskCorrectionItemsRefs<T extends Object>(
    Expression<T> Function($$TaskCorrectionItemsTableAnnotationComposer a) f,
  ) {
    final $$TaskCorrectionItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskCorrectionItems,
          getReferencedColumn: (t) => t.operationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCorrectionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskCorrectionOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCorrectionOperationsTable,
          TaskCorrectionOperation,
          $$TaskCorrectionOperationsTableFilterComposer,
          $$TaskCorrectionOperationsTableOrderingComposer,
          $$TaskCorrectionOperationsTableAnnotationComposer,
          $$TaskCorrectionOperationsTableCreateCompanionBuilder,
          $$TaskCorrectionOperationsTableUpdateCompanionBuilder,
          (TaskCorrectionOperation, $$TaskCorrectionOperationsTableReferences),
          TaskCorrectionOperation,
          PrefetchHooks Function({bool taskId, bool taskCorrectionItemsRefs})
        > {
  $$TaskCorrectionOperationsTableTableManager(
    _$AppDatabase db,
    $TaskCorrectionOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskCorrectionOperationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskCorrectionOperationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskCorrectionOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCorrectionOperationsCompanion(
                id: id,
                taskId: taskId,
                type: type,
                state: state,
                payloadVersion: payloadVersion,
                reason: reason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String type,
                Value<String> state = const Value.absent(),
                Value<int> payloadVersion = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCorrectionOperationsCompanion.insert(
                id: id,
                taskId: taskId,
                type: type,
                state: state,
                payloadVersion: payloadVersion,
                reason: reason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskCorrectionOperationsTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            taskId = false,
            taskCorrectionItemsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (taskCorrectionItemsRefs) db.taskCorrectionItems,
              ],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$TaskCorrectionOperationsTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$TaskCorrectionOperationsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskCorrectionItemsRefs)
                    await $_getPrefetchedData<
                      TaskCorrectionOperation,
                      $TaskCorrectionOperationsTable,
                      TaskCorrectionItem
                    >(
                      currentTable: table,
                      referencedTable: $$TaskCorrectionOperationsTableReferences
                          ._taskCorrectionItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskCorrectionOperationsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCorrectionItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.operationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskCorrectionOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCorrectionOperationsTable,
      TaskCorrectionOperation,
      $$TaskCorrectionOperationsTableFilterComposer,
      $$TaskCorrectionOperationsTableOrderingComposer,
      $$TaskCorrectionOperationsTableAnnotationComposer,
      $$TaskCorrectionOperationsTableCreateCompanionBuilder,
      $$TaskCorrectionOperationsTableUpdateCompanionBuilder,
      (TaskCorrectionOperation, $$TaskCorrectionOperationsTableReferences),
      TaskCorrectionOperation,
      PrefetchHooks Function({bool taskId, bool taskCorrectionItemsRefs})
    >;
typedef $$TaskCorrectionItemsTableCreateCompanionBuilder =
    TaskCorrectionItemsCompanion Function({
      required String id,
      required String operationId,
      required String entryId,
      required String beforeJson,
      required String afterJson,
      required int expectedRevision,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TaskCorrectionItemsTableUpdateCompanionBuilder =
    TaskCorrectionItemsCompanion Function({
      Value<String> id,
      Value<String> operationId,
      Value<String> entryId,
      Value<String> beforeJson,
      Value<String> afterJson,
      Value<int> expectedRevision,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TaskCorrectionItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskCorrectionItemsTable,
          TaskCorrectionItem
        > {
  $$TaskCorrectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskCorrectionOperationsTable _operationIdTable(_$AppDatabase db) =>
      db.taskCorrectionOperations.createAlias(
        $_aliasNameGenerator(
          db.taskCorrectionItems.operationId,
          db.taskCorrectionOperations.id,
        ),
      );

  $$TaskCorrectionOperationsTableProcessedTableManager get operationId {
    final $_column = $_itemColumn<String>('operation_id')!;

    final manager = $$TaskCorrectionOperationsTableTableManager(
      $_db,
      $_db.taskCorrectionOperations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_operationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TaskEntriesTable _entryIdTable(_$AppDatabase db) =>
      db.taskEntries.createAlias(
        $_aliasNameGenerator(db.taskCorrectionItems.entryId, db.taskEntries.id),
      );

  $$TaskEntriesTableProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $$TaskEntriesTableTableManager(
      $_db,
      $_db.taskEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskCorrectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCorrectionItemsTable> {
  $$TaskCorrectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedRevision => $composableBuilder(
    column: $table.expectedRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskCorrectionOperationsTableFilterComposer get operationId {
    final $$TaskCorrectionOperationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.operationId,
          referencedTable: $db.taskCorrectionOperations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionOperationsTableFilterComposer(
                $db: $db,
                $table: $db.taskCorrectionOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TaskEntriesTableFilterComposer get entryId {
    final $$TaskEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableFilterComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCorrectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCorrectionItemsTable> {
  $$TaskCorrectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afterJson => $composableBuilder(
    column: $table.afterJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedRevision => $composableBuilder(
    column: $table.expectedRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskCorrectionOperationsTableOrderingComposer get operationId {
    final $$TaskCorrectionOperationsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.operationId,
          referencedTable: $db.taskCorrectionOperations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionOperationsTableOrderingComposer(
                $db: $db,
                $table: $db.taskCorrectionOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TaskEntriesTableOrderingComposer get entryId {
    final $$TaskEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCorrectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCorrectionItemsTable> {
  $$TaskCorrectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get beforeJson => $composableBuilder(
    column: $table.beforeJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afterJson =>
      $composableBuilder(column: $table.afterJson, builder: (column) => column);

  GeneratedColumn<int> get expectedRevision => $composableBuilder(
    column: $table.expectedRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TaskCorrectionOperationsTableAnnotationComposer get operationId {
    final $$TaskCorrectionOperationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.operationId,
          referencedTable: $db.taskCorrectionOperations,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskCorrectionOperationsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskCorrectionOperations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TaskEntriesTableAnnotationComposer get entryId {
    final $$TaskEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.taskEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCorrectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCorrectionItemsTable,
          TaskCorrectionItem,
          $$TaskCorrectionItemsTableFilterComposer,
          $$TaskCorrectionItemsTableOrderingComposer,
          $$TaskCorrectionItemsTableAnnotationComposer,
          $$TaskCorrectionItemsTableCreateCompanionBuilder,
          $$TaskCorrectionItemsTableUpdateCompanionBuilder,
          (TaskCorrectionItem, $$TaskCorrectionItemsTableReferences),
          TaskCorrectionItem,
          PrefetchHooks Function({bool operationId, bool entryId})
        > {
  $$TaskCorrectionItemsTableTableManager(
    _$AppDatabase db,
    $TaskCorrectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskCorrectionItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskCorrectionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskCorrectionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> operationId = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<String> beforeJson = const Value.absent(),
                Value<String> afterJson = const Value.absent(),
                Value<int> expectedRevision = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCorrectionItemsCompanion(
                id: id,
                operationId: operationId,
                entryId: entryId,
                beforeJson: beforeJson,
                afterJson: afterJson,
                expectedRevision: expectedRevision,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String operationId,
                required String entryId,
                required String beforeJson,
                required String afterJson,
                required int expectedRevision,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCorrectionItemsCompanion.insert(
                id: id,
                operationId: operationId,
                entryId: entryId,
                beforeJson: beforeJson,
                afterJson: afterJson,
                expectedRevision: expectedRevision,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskCorrectionItemsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({operationId = false, entryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (operationId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.operationId,
                            referencedTable:
                                $$TaskCorrectionItemsTableReferences
                                    ._operationIdTable(db),
                            referencedColumn:
                                $$TaskCorrectionItemsTableReferences
                                    ._operationIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (entryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable:
                                $$TaskCorrectionItemsTableReferences
                                    ._entryIdTable(db),
                            referencedColumn:
                                $$TaskCorrectionItemsTableReferences
                                    ._entryIdTable(db)
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

typedef $$TaskCorrectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCorrectionItemsTable,
      TaskCorrectionItem,
      $$TaskCorrectionItemsTableFilterComposer,
      $$TaskCorrectionItemsTableOrderingComposer,
      $$TaskCorrectionItemsTableAnnotationComposer,
      $$TaskCorrectionItemsTableCreateCompanionBuilder,
      $$TaskCorrectionItemsTableUpdateCompanionBuilder,
      (TaskCorrectionItem, $$TaskCorrectionItemsTableReferences),
      TaskCorrectionItem,
      PrefetchHooks Function({bool operationId, bool entryId})
    >;
typedef $$TaskPlanningInterruptionsTableCreateCompanionBuilder =
    TaskPlanningInterruptionsCompanion Function({
      required String id,
      required String taskId,
      required String reason,
      required String fromDay,
      Value<String?> untilDayExclusive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> revision,
      Value<int> rowid,
    });
typedef $$TaskPlanningInterruptionsTableUpdateCompanionBuilder =
    TaskPlanningInterruptionsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> reason,
      Value<String> fromDay,
      Value<String?> untilDayExclusive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> revision,
      Value<int> rowid,
    });

final class $$TaskPlanningInterruptionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskPlanningInterruptionsTable,
          TaskPlanningInterruption
        > {
  $$TaskPlanningInterruptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AufgabenTable _taskIdTable(_$AppDatabase db) =>
      db.aufgaben.createAlias(
        $_aliasNameGenerator(
          db.taskPlanningInterruptions.taskId,
          db.aufgaben.id,
        ),
      );

  $$AufgabenTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$AufgabenTableTableManager(
      $_db,
      $_db.aufgaben,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskPlanningInterruptionsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskPlanningInterruptionsTable> {
  $$TaskPlanningInterruptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromDay => $composableBuilder(
    column: $table.fromDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get untilDayExclusive => $composableBuilder(
    column: $table.untilDayExclusive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  $$AufgabenTableFilterComposer get taskId {
    final $$AufgabenTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableFilterComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskPlanningInterruptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskPlanningInterruptionsTable> {
  $$TaskPlanningInterruptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromDay => $composableBuilder(
    column: $table.fromDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get untilDayExclusive => $composableBuilder(
    column: $table.untilDayExclusive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  $$AufgabenTableOrderingComposer get taskId {
    final $$AufgabenTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableOrderingComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskPlanningInterruptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskPlanningInterruptionsTable> {
  $$TaskPlanningInterruptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get fromDay =>
      $composableBuilder(column: $table.fromDay, builder: (column) => column);

  GeneratedColumn<String> get untilDayExclusive => $composableBuilder(
    column: $table.untilDayExclusive,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  $$AufgabenTableAnnotationComposer get taskId {
    final $$AufgabenTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.aufgaben,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AufgabenTableAnnotationComposer(
            $db: $db,
            $table: $db.aufgaben,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskPlanningInterruptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskPlanningInterruptionsTable,
          TaskPlanningInterruption,
          $$TaskPlanningInterruptionsTableFilterComposer,
          $$TaskPlanningInterruptionsTableOrderingComposer,
          $$TaskPlanningInterruptionsTableAnnotationComposer,
          $$TaskPlanningInterruptionsTableCreateCompanionBuilder,
          $$TaskPlanningInterruptionsTableUpdateCompanionBuilder,
          (
            TaskPlanningInterruption,
            $$TaskPlanningInterruptionsTableReferences,
          ),
          TaskPlanningInterruption,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskPlanningInterruptionsTableTableManager(
    _$AppDatabase db,
    $TaskPlanningInterruptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskPlanningInterruptionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TaskPlanningInterruptionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TaskPlanningInterruptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> fromDay = const Value.absent(),
                Value<String?> untilDayExclusive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPlanningInterruptionsCompanion(
                id: id,
                taskId: taskId,
                reason: reason,
                fromDay: fromDay,
                untilDayExclusive: untilDayExclusive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                revision: revision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String reason,
                required String fromDay,
                Value<String?> untilDayExclusive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPlanningInterruptionsCompanion.insert(
                id: id,
                taskId: taskId,
                reason: reason,
                fromDay: fromDay,
                untilDayExclusive: untilDayExclusive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                revision: revision,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskPlanningInterruptionsTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable:
                                $$TaskPlanningInterruptionsTableReferences
                                    ._taskIdTable(db),
                            referencedColumn:
                                $$TaskPlanningInterruptionsTableReferences
                                    ._taskIdTable(db)
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

typedef $$TaskPlanningInterruptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskPlanningInterruptionsTable,
      TaskPlanningInterruption,
      $$TaskPlanningInterruptionsTableFilterComposer,
      $$TaskPlanningInterruptionsTableOrderingComposer,
      $$TaskPlanningInterruptionsTableAnnotationComposer,
      $$TaskPlanningInterruptionsTableCreateCompanionBuilder,
      $$TaskPlanningInterruptionsTableUpdateCompanionBuilder,
      (TaskPlanningInterruption, $$TaskPlanningInterruptionsTableReferences),
      TaskPlanningInterruption,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$EntityDeletionMarkersTableCreateCompanionBuilder =
    EntityDeletionMarkersCompanion Function({
      required String entityType,
      required String entityId,
      required DateTime deletedAt,
      Value<int> rowid,
    });
typedef $$EntityDeletionMarkersTableUpdateCompanionBuilder =
    EntityDeletionMarkersCompanion Function({
      Value<String> entityType,
      Value<String> entityId,
      Value<DateTime> deletedAt,
      Value<int> rowid,
    });

class $$EntityDeletionMarkersTableFilterComposer
    extends Composer<_$AppDatabase, $EntityDeletionMarkersTable> {
  $$EntityDeletionMarkersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntityDeletionMarkersTableOrderingComposer
    extends Composer<_$AppDatabase, $EntityDeletionMarkersTable> {
  $$EntityDeletionMarkersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntityDeletionMarkersTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntityDeletionMarkersTable> {
  $$EntityDeletionMarkersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EntityDeletionMarkersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntityDeletionMarkersTable,
          EntityDeletionMarker,
          $$EntityDeletionMarkersTableFilterComposer,
          $$EntityDeletionMarkersTableOrderingComposer,
          $$EntityDeletionMarkersTableAnnotationComposer,
          $$EntityDeletionMarkersTableCreateCompanionBuilder,
          $$EntityDeletionMarkersTableUpdateCompanionBuilder,
          (
            EntityDeletionMarker,
            BaseReferences<
              _$AppDatabase,
              $EntityDeletionMarkersTable,
              EntityDeletionMarker
            >,
          ),
          EntityDeletionMarker,
          PrefetchHooks Function()
        > {
  $$EntityDeletionMarkersTableTableManager(
    _$AppDatabase db,
    $EntityDeletionMarkersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EntityDeletionMarkersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$EntityDeletionMarkersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$EntityDeletionMarkersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntityDeletionMarkersCompanion(
                entityType: entityType,
                entityId: entityId,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityType,
                required String entityId,
                required DateTime deletedAt,
                Value<int> rowid = const Value.absent(),
              }) => EntityDeletionMarkersCompanion.insert(
                entityType: entityType,
                entityId: entityId,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntityDeletionMarkersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntityDeletionMarkersTable,
      EntityDeletionMarker,
      $$EntityDeletionMarkersTableFilterComposer,
      $$EntityDeletionMarkersTableOrderingComposer,
      $$EntityDeletionMarkersTableAnnotationComposer,
      $$EntityDeletionMarkersTableCreateCompanionBuilder,
      $$EntityDeletionMarkersTableUpdateCompanionBuilder,
      (
        EntityDeletionMarker,
        BaseReferences<
          _$AppDatabase,
          $EntityDeletionMarkersTable,
          EntityDeletionMarker
        >,
      ),
      EntityDeletionMarker,
      PrefetchHooks Function()
    >;
typedef $$ProjectDeletionBatchesTableCreateCompanionBuilder =
    ProjectDeletionBatchesCompanion Function({
      required String id,
      required String projectId,
      required String mode,
      required DateTime deletedAt,
      required int projectRevision,
      Value<int> rowid,
    });
typedef $$ProjectDeletionBatchesTableUpdateCompanionBuilder =
    ProjectDeletionBatchesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> mode,
      Value<DateTime> deletedAt,
      Value<int> projectRevision,
      Value<int> rowid,
    });

final class $$ProjectDeletionBatchesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectDeletionBatchesTable,
          ProjectDeletionBatch
        > {
  $$ProjectDeletionBatchesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(
          db.projectDeletionBatches.projectId,
          db.projects.id,
        ),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ProjectDeletionBatchItemsTable,
    List<ProjectDeletionBatchItem>
  >
  _projectDeletionBatchItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.projectDeletionBatchItems,
        aliasName: $_aliasNameGenerator(
          db.projectDeletionBatches.id,
          db.projectDeletionBatchItems.batchId,
        ),
      );

  $$ProjectDeletionBatchItemsTableProcessedTableManager
  get projectDeletionBatchItemsRefs {
    final manager = $$ProjectDeletionBatchItemsTableTableManager(
      $_db,
      $_db.projectDeletionBatchItems,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _projectDeletionBatchItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectDeletionBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectDeletionBatchesTable> {
  $$ProjectDeletionBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get projectRevision => $composableBuilder(
    column: $table.projectRevision,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> projectDeletionBatchItemsRefs(
    Expression<bool> Function($$ProjectDeletionBatchItemsTableFilterComposer f)
    f,
  ) {
    final $$ProjectDeletionBatchItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectDeletionBatchItems,
          getReferencedColumn: (t) => t.batchId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchItemsTableFilterComposer(
                $db: $db,
                $table: $db.projectDeletionBatchItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProjectDeletionBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectDeletionBatchesTable> {
  $$ProjectDeletionBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get projectRevision => $composableBuilder(
    column: $table.projectRevision,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectDeletionBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectDeletionBatchesTable> {
  $$ProjectDeletionBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get projectRevision => $composableBuilder(
    column: $table.projectRevision,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> projectDeletionBatchItemsRefs<T extends Object>(
    Expression<T> Function($$ProjectDeletionBatchItemsTableAnnotationComposer a)
    f,
  ) {
    final $$ProjectDeletionBatchItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.projectDeletionBatchItems,
          getReferencedColumn: (t) => t.batchId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.projectDeletionBatchItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ProjectDeletionBatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectDeletionBatchesTable,
          ProjectDeletionBatch,
          $$ProjectDeletionBatchesTableFilterComposer,
          $$ProjectDeletionBatchesTableOrderingComposer,
          $$ProjectDeletionBatchesTableAnnotationComposer,
          $$ProjectDeletionBatchesTableCreateCompanionBuilder,
          $$ProjectDeletionBatchesTableUpdateCompanionBuilder,
          (ProjectDeletionBatch, $$ProjectDeletionBatchesTableReferences),
          ProjectDeletionBatch,
          PrefetchHooks Function({
            bool projectId,
            bool projectDeletionBatchItemsRefs,
          })
        > {
  $$ProjectDeletionBatchesTableTableManager(
    _$AppDatabase db,
    $ProjectDeletionBatchesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProjectDeletionBatchesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ProjectDeletionBatchesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ProjectDeletionBatchesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
                Value<int> projectRevision = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectDeletionBatchesCompanion(
                id: id,
                projectId: projectId,
                mode: mode,
                deletedAt: deletedAt,
                projectRevision: projectRevision,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String mode,
                required DateTime deletedAt,
                required int projectRevision,
                Value<int> rowid = const Value.absent(),
              }) => ProjectDeletionBatchesCompanion.insert(
                id: id,
                projectId: projectId,
                mode: mode,
                deletedAt: deletedAt,
                projectRevision: projectRevision,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ProjectDeletionBatchesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            projectId = false,
            projectDeletionBatchItemsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (projectDeletionBatchItemsRefs) db.projectDeletionBatchItems,
              ],
              addJoins: <
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
                if (projectId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.projectId,
                            referencedTable:
                                $$ProjectDeletionBatchesTableReferences
                                    ._projectIdTable(db),
                            referencedColumn:
                                $$ProjectDeletionBatchesTableReferences
                                    ._projectIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (projectDeletionBatchItemsRefs)
                    await $_getPrefetchedData<
                      ProjectDeletionBatch,
                      $ProjectDeletionBatchesTable,
                      ProjectDeletionBatchItem
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectDeletionBatchesTableReferences
                          ._projectDeletionBatchItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProjectDeletionBatchesTableReferences(
                                db,
                                table,
                                p0,
                              ).projectDeletionBatchItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.batchId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectDeletionBatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectDeletionBatchesTable,
      ProjectDeletionBatch,
      $$ProjectDeletionBatchesTableFilterComposer,
      $$ProjectDeletionBatchesTableOrderingComposer,
      $$ProjectDeletionBatchesTableAnnotationComposer,
      $$ProjectDeletionBatchesTableCreateCompanionBuilder,
      $$ProjectDeletionBatchesTableUpdateCompanionBuilder,
      (ProjectDeletionBatch, $$ProjectDeletionBatchesTableReferences),
      ProjectDeletionBatch,
      PrefetchHooks Function({
        bool projectId,
        bool projectDeletionBatchItemsRefs,
      })
    >;
typedef $$ProjectDeletionBatchItemsTableCreateCompanionBuilder =
    ProjectDeletionBatchItemsCompanion Function({
      required String batchId,
      required String objectType,
      required String objectId,
      required int lifecycleRevision,
      required DateTime trashedAt,
      Value<int> rowid,
    });
typedef $$ProjectDeletionBatchItemsTableUpdateCompanionBuilder =
    ProjectDeletionBatchItemsCompanion Function({
      Value<String> batchId,
      Value<String> objectType,
      Value<String> objectId,
      Value<int> lifecycleRevision,
      Value<DateTime> trashedAt,
      Value<int> rowid,
    });

final class $$ProjectDeletionBatchItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProjectDeletionBatchItemsTable,
          ProjectDeletionBatchItem
        > {
  $$ProjectDeletionBatchItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectDeletionBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.projectDeletionBatches.createAlias(
        $_aliasNameGenerator(
          db.projectDeletionBatchItems.batchId,
          db.projectDeletionBatches.id,
        ),
      );

  $$ProjectDeletionBatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<String>('batch_id')!;

    final manager = $$ProjectDeletionBatchesTableTableManager(
      $_db,
      $_db.projectDeletionBatches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectDeletionBatchItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectDeletionBatchItemsTable> {
  $$ProjectDeletionBatchItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get objectType => $composableBuilder(
    column: $table.objectType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get objectId => $composableBuilder(
    column: $table.objectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectDeletionBatchesTableFilterComposer get batchId {
    final $$ProjectDeletionBatchesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.batchId,
          referencedTable: $db.projectDeletionBatches,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchesTableFilterComposer(
                $db: $db,
                $table: $db.projectDeletionBatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ProjectDeletionBatchItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectDeletionBatchItemsTable> {
  $$ProjectDeletionBatchItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get objectType => $composableBuilder(
    column: $table.objectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectId => $composableBuilder(
    column: $table.objectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectDeletionBatchesTableOrderingComposer get batchId {
    final $$ProjectDeletionBatchesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.batchId,
          referencedTable: $db.projectDeletionBatches,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchesTableOrderingComposer(
                $db: $db,
                $table: $db.projectDeletionBatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ProjectDeletionBatchItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectDeletionBatchItemsTable> {
  $$ProjectDeletionBatchItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get objectType => $composableBuilder(
    column: $table.objectType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<int> get lifecycleRevision => $composableBuilder(
    column: $table.lifecycleRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  $$ProjectDeletionBatchesTableAnnotationComposer get batchId {
    final $$ProjectDeletionBatchesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.batchId,
          referencedTable: $db.projectDeletionBatches,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProjectDeletionBatchesTableAnnotationComposer(
                $db: $db,
                $table: $db.projectDeletionBatches,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ProjectDeletionBatchItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectDeletionBatchItemsTable,
          ProjectDeletionBatchItem,
          $$ProjectDeletionBatchItemsTableFilterComposer,
          $$ProjectDeletionBatchItemsTableOrderingComposer,
          $$ProjectDeletionBatchItemsTableAnnotationComposer,
          $$ProjectDeletionBatchItemsTableCreateCompanionBuilder,
          $$ProjectDeletionBatchItemsTableUpdateCompanionBuilder,
          (
            ProjectDeletionBatchItem,
            $$ProjectDeletionBatchItemsTableReferences,
          ),
          ProjectDeletionBatchItem,
          PrefetchHooks Function({bool batchId})
        > {
  $$ProjectDeletionBatchItemsTableTableManager(
    _$AppDatabase db,
    $ProjectDeletionBatchItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProjectDeletionBatchItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ProjectDeletionBatchItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ProjectDeletionBatchItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> batchId = const Value.absent(),
                Value<String> objectType = const Value.absent(),
                Value<String> objectId = const Value.absent(),
                Value<int> lifecycleRevision = const Value.absent(),
                Value<DateTime> trashedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectDeletionBatchItemsCompanion(
                batchId: batchId,
                objectType: objectType,
                objectId: objectId,
                lifecycleRevision: lifecycleRevision,
                trashedAt: trashedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String batchId,
                required String objectType,
                required String objectId,
                required int lifecycleRevision,
                required DateTime trashedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectDeletionBatchItemsCompanion.insert(
                batchId: batchId,
                objectType: objectType,
                objectId: objectId,
                lifecycleRevision: lifecycleRevision,
                trashedAt: trashedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ProjectDeletionBatchItemsTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (batchId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.batchId,
                            referencedTable:
                                $$ProjectDeletionBatchItemsTableReferences
                                    ._batchIdTable(db),
                            referencedColumn:
                                $$ProjectDeletionBatchItemsTableReferences
                                    ._batchIdTable(db)
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

typedef $$ProjectDeletionBatchItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectDeletionBatchItemsTable,
      ProjectDeletionBatchItem,
      $$ProjectDeletionBatchItemsTableFilterComposer,
      $$ProjectDeletionBatchItemsTableOrderingComposer,
      $$ProjectDeletionBatchItemsTableAnnotationComposer,
      $$ProjectDeletionBatchItemsTableCreateCompanionBuilder,
      $$ProjectDeletionBatchItemsTableUpdateCompanionBuilder,
      (ProjectDeletionBatchItem, $$ProjectDeletionBatchItemsTableReferences),
      ProjectDeletionBatchItem,
      PrefetchHooks Function({bool batchId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$AufgabenTableTableManager get aufgaben =>
      $$AufgabenTableTableManager(_db, _db.aufgaben);
  $$TaskDefinitionVersionsTableTableManager get taskDefinitionVersions =>
      $$TaskDefinitionVersionsTableTableManager(
        _db,
        _db.taskDefinitionVersions,
      );
  $$TaskEntriesTableTableManager get taskEntries =>
      $$TaskEntriesTableTableManager(_db, _db.taskEntries);
  $$TaskEntryValuesTableTableManager get taskEntryValues =>
      $$TaskEntryValuesTableTableManager(_db, _db.taskEntryValues);
  $$TaskValueBundlesTableTableManager get taskValueBundles =>
      $$TaskValueBundlesTableTableManager(_db, _db.taskValueBundles);
  $$TaskValueBundleVersionsTableTableManager get taskValueBundleVersions =>
      $$TaskValueBundleVersionsTableTableManager(
        _db,
        _db.taskValueBundleVersions,
      );
  $$TaskCardMetricPreferencesTableTableManager get taskCardMetricPreferences =>
      $$TaskCardMetricPreferencesTableTableManager(
        _db,
        _db.taskCardMetricPreferences,
      );
  $$TaskPendingDefinitionChangesTableTableManager
  get taskPendingDefinitionChanges =>
      $$TaskPendingDefinitionChangesTableTableManager(
        _db,
        _db.taskPendingDefinitionChanges,
      );
  $$TaskProjectAssignmentChangesTableTableManager
  get taskProjectAssignmentChanges =>
      $$TaskProjectAssignmentChangesTableTableManager(
        _db,
        _db.taskProjectAssignmentChanges,
      );
  $$TaskCorrectionOperationsTableTableManager get taskCorrectionOperations =>
      $$TaskCorrectionOperationsTableTableManager(
        _db,
        _db.taskCorrectionOperations,
      );
  $$TaskCorrectionItemsTableTableManager get taskCorrectionItems =>
      $$TaskCorrectionItemsTableTableManager(_db, _db.taskCorrectionItems);
  $$TaskPlanningInterruptionsTableTableManager get taskPlanningInterruptions =>
      $$TaskPlanningInterruptionsTableTableManager(
        _db,
        _db.taskPlanningInterruptions,
      );
  $$EntityDeletionMarkersTableTableManager get entityDeletionMarkers =>
      $$EntityDeletionMarkersTableTableManager(_db, _db.entityDeletionMarkers);
  $$ProjectDeletionBatchesTableTableManager get projectDeletionBatches =>
      $$ProjectDeletionBatchesTableTableManager(
        _db,
        _db.projectDeletionBatches,
      );
  $$ProjectDeletionBatchItemsTableTableManager get projectDeletionBatchItems =>
      $$ProjectDeletionBatchItemsTableTableManager(
        _db,
        _db.projectDeletionBatchItems,
      );
}
