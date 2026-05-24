// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSessionDataCollection on Isar {
  IsarCollection<SessionData> get sessionDatas => this.collection();
}

const SessionDataSchema = CollectionSchema(
  name: r'SessionData',
  id: 7223334170416996232,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'lettersAttempted': PropertySchema(
      id: 1,
      name: r'lettersAttempted',
      type: IsarType.stringList,
    ),
    r'starsEarned': PropertySchema(
      id: 2,
      name: r'starsEarned',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 3,
      name: r'startTime',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sessionDataEstimateSize,
  serialize: _sessionDataSerialize,
  deserialize: _sessionDataDeserialize,
  deserializeProp: _sessionDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sessionDataGetId,
  getLinks: _sessionDataGetLinks,
  attach: _sessionDataAttach,
  version: '3.1.0+1',
);

int _sessionDataEstimateSize(
  SessionData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lettersAttempted.length * 3;
  {
    for (var i = 0; i < object.lettersAttempted.length; i++) {
      final value = object.lettersAttempted[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _sessionDataSerialize(
  SessionData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endTime);
  writer.writeStringList(offsets[1], object.lettersAttempted);
  writer.writeLong(offsets[2], object.starsEarned);
  writer.writeDateTime(offsets[3], object.startTime);
}

SessionData _sessionDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionData();
  object.endTime = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.lettersAttempted = reader.readStringList(offsets[1]) ?? [];
  object.starsEarned = reader.readLong(offsets[2]);
  object.startTime = reader.readDateTime(offsets[3]);
  return object;
}

P _sessionDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sessionDataGetId(SessionData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sessionDataGetLinks(SessionData object) {
  return [];
}

void _sessionDataAttach(
    IsarCollection<dynamic> col, Id id, SessionData object) {
  object.id = id;
}

extension SessionDataQueryWhereSort
    on QueryBuilder<SessionData, SessionData, QWhere> {
  QueryBuilder<SessionData, SessionData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SessionDataQueryWhere
    on QueryBuilder<SessionData, SessionData, QWhereClause> {
  QueryBuilder<SessionData, SessionData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SessionData, SessionData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterWhereClause> idBetween(
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
}

extension SessionDataQueryFilter
    on QueryBuilder<SessionData, SessionData, QFilterCondition> {
  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> endTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lettersAttempted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lettersAttempted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lettersAttempted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lettersAttempted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lettersAttempted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lettersAttempted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lettersAttempted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lettersAttempted',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lettersAttempted',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lettersAttempted',
        value: '',
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lettersAttempted',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lettersAttempted',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lettersAttempted',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lettersAttempted',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lettersAttempted',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      lettersAttemptedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lettersAttempted',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      starsEarnedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'starsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      starsEarnedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'starsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      starsEarnedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'starsEarned',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      starsEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'starsEarned',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionDataQueryObject
    on QueryBuilder<SessionData, SessionData, QFilterCondition> {}

extension SessionDataQueryLinks
    on QueryBuilder<SessionData, SessionData, QFilterCondition> {}

extension SessionDataQuerySortBy
    on QueryBuilder<SessionData, SessionData, QSortBy> {
  QueryBuilder<SessionData, SessionData, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> sortByStarsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starsEarned', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> sortByStarsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starsEarned', Sort.desc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension SessionDataQuerySortThenBy
    on QueryBuilder<SessionData, SessionData, QSortThenBy> {
  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByStarsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starsEarned', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByStarsEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'starsEarned', Sort.desc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<SessionData, SessionData, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension SessionDataQueryWhereDistinct
    on QueryBuilder<SessionData, SessionData, QDistinct> {
  QueryBuilder<SessionData, SessionData, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<SessionData, SessionData, QDistinct>
      distinctByLettersAttempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lettersAttempted');
    });
  }

  QueryBuilder<SessionData, SessionData, QDistinct> distinctByStarsEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'starsEarned');
    });
  }

  QueryBuilder<SessionData, SessionData, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }
}

extension SessionDataQueryProperty
    on QueryBuilder<SessionData, SessionData, QQueryProperty> {
  QueryBuilder<SessionData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SessionData, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<SessionData, List<String>, QQueryOperations>
      lettersAttemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lettersAttempted');
    });
  }

  QueryBuilder<SessionData, int, QQueryOperations> starsEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'starsEarned');
    });
  }

  QueryBuilder<SessionData, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }
}
