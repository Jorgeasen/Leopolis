// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLetterProgressCollection on Isar {
  IsarCollection<LetterProgress> get letterProgress => this.collection();
}

const LetterProgressSchema = CollectionSchema(
  name: r'LetterProgress',
  id: -3550707655365634596,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'isCompleted': PropertySchema(
      id: 1,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'letter': PropertySchema(
      id: 2,
      name: r'letter',
      type: IsarType.string,
    ),
    r'tracingAttempts': PropertySchema(
      id: 3,
      name: r'tracingAttempts',
      type: IsarType.long,
    )
  },
  estimateSize: _letterProgressEstimateSize,
  serialize: _letterProgressSerialize,
  deserialize: _letterProgressDeserialize,
  deserializeProp: _letterProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'letter': IndexSchema(
      id: 5010637541476400395,
      name: r'letter',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'letter',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _letterProgressGetId,
  getLinks: _letterProgressGetLinks,
  attach: _letterProgressAttach,
  version: '3.1.0+1',
);

int _letterProgressEstimateSize(
  LetterProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.letter.length * 3;
  return bytesCount;
}

void _letterProgressSerialize(
  LetterProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeBool(offsets[1], object.isCompleted);
  writer.writeString(offsets[2], object.letter);
  writer.writeLong(offsets[3], object.tracingAttempts);
}

LetterProgress _letterProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LetterProgress();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[1]);
  object.letter = reader.readString(offsets[2]);
  object.tracingAttempts = reader.readLong(offsets[3]);
  return object;
}

P _letterProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _letterProgressGetId(LetterProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _letterProgressGetLinks(LetterProgress object) {
  return [];
}

void _letterProgressAttach(
    IsarCollection<dynamic> col, Id id, LetterProgress object) {
  object.id = id;
}

extension LetterProgressByIndex on IsarCollection<LetterProgress> {
  Future<LetterProgress?> getByLetter(String letter) {
    return getByIndex(r'letter', [letter]);
  }

  LetterProgress? getByLetterSync(String letter) {
    return getByIndexSync(r'letter', [letter]);
  }

  Future<bool> deleteByLetter(String letter) {
    return deleteByIndex(r'letter', [letter]);
  }

  bool deleteByLetterSync(String letter) {
    return deleteByIndexSync(r'letter', [letter]);
  }

  Future<List<LetterProgress?>> getAllByLetter(List<String> letterValues) {
    final values = letterValues.map((e) => [e]).toList();
    return getAllByIndex(r'letter', values);
  }

  List<LetterProgress?> getAllByLetterSync(List<String> letterValues) {
    final values = letterValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'letter', values);
  }

  Future<int> deleteAllByLetter(List<String> letterValues) {
    final values = letterValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'letter', values);
  }

  int deleteAllByLetterSync(List<String> letterValues) {
    final values = letterValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'letter', values);
  }

  Future<Id> putByLetter(LetterProgress object) {
    return putByIndex(r'letter', object);
  }

  Id putByLetterSync(LetterProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'letter', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLetter(List<LetterProgress> objects) {
    return putAllByIndex(r'letter', objects);
  }

  List<Id> putAllByLetterSync(List<LetterProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'letter', objects, saveLinks: saveLinks);
  }
}

extension LetterProgressQueryWhereSort
    on QueryBuilder<LetterProgress, LetterProgress, QWhere> {
  QueryBuilder<LetterProgress, LetterProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LetterProgressQueryWhere
    on QueryBuilder<LetterProgress, LetterProgress, QWhereClause> {
  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause> letterEqualTo(
      String letter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'letter',
        value: [letter],
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterWhereClause>
      letterNotEqualTo(String letter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'letter',
              lower: [],
              upper: [letter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'letter',
              lower: [letter],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'letter',
              lower: [letter],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'letter',
              lower: [],
              upper: [letter],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LetterProgressQueryFilter
    on QueryBuilder<LetterProgress, LetterProgress, QFilterCondition> {
  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'letter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'letter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'letter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'letter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letter',
        value: '',
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      letterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'letter',
        value: '',
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      tracingAttemptsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tracingAttempts',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      tracingAttemptsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tracingAttempts',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      tracingAttemptsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tracingAttempts',
        value: value,
      ));
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterFilterCondition>
      tracingAttemptsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tracingAttempts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LetterProgressQueryObject
    on QueryBuilder<LetterProgress, LetterProgress, QFilterCondition> {}

extension LetterProgressQueryLinks
    on QueryBuilder<LetterProgress, LetterProgress, QFilterCondition> {}

extension LetterProgressQuerySortBy
    on QueryBuilder<LetterProgress, LetterProgress, QSortBy> {
  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy> sortByLetter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letter', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByLetterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letter', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByTracingAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tracingAttempts', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      sortByTracingAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tracingAttempts', Sort.desc);
    });
  }
}

extension LetterProgressQuerySortThenBy
    on QueryBuilder<LetterProgress, LetterProgress, QSortThenBy> {
  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy> thenByLetter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letter', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByLetterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'letter', Sort.desc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByTracingAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tracingAttempts', Sort.asc);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QAfterSortBy>
      thenByTracingAttemptsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tracingAttempts', Sort.desc);
    });
  }
}

extension LetterProgressQueryWhereDistinct
    on QueryBuilder<LetterProgress, LetterProgress, QDistinct> {
  QueryBuilder<LetterProgress, LetterProgress, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QDistinct> distinctByLetter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letter', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LetterProgress, LetterProgress, QDistinct>
      distinctByTracingAttempts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tracingAttempts');
    });
  }
}

extension LetterProgressQueryProperty
    on QueryBuilder<LetterProgress, LetterProgress, QQueryProperty> {
  QueryBuilder<LetterProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LetterProgress, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<LetterProgress, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<LetterProgress, String, QQueryOperations> letterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letter');
    });
  }

  QueryBuilder<LetterProgress, int, QQueryOperations>
      tracingAttemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tracingAttempts');
    });
  }
}
