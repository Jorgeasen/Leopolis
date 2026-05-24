// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewards_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRewardsDataCollection on Isar {
  IsarCollection<RewardsData> get rewardsDatas => this.collection();
}

const RewardsDataSchema = CollectionSchema(
  name: r'RewardsData',
  id: 8838585247339173179,
  properties: {
    r'currentLevel': PropertySchema(
      id: 0,
      name: r'currentLevel',
      type: IsarType.long,
    ),
    r'lastUpdated': PropertySchema(
      id: 1,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'totalStars': PropertySchema(
      id: 2,
      name: r'totalStars',
      type: IsarType.long,
    ),
    r'unlockedBadges': PropertySchema(
      id: 3,
      name: r'unlockedBadges',
      type: IsarType.stringList,
    )
  },
  estimateSize: _rewardsDataEstimateSize,
  serialize: _rewardsDataSerialize,
  deserialize: _rewardsDataDeserialize,
  deserializeProp: _rewardsDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _rewardsDataGetId,
  getLinks: _rewardsDataGetLinks,
  attach: _rewardsDataAttach,
  version: '3.1.0+1',
);

int _rewardsDataEstimateSize(
  RewardsData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.unlockedBadges.length * 3;
  {
    for (var i = 0; i < object.unlockedBadges.length; i++) {
      final value = object.unlockedBadges[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _rewardsDataSerialize(
  RewardsData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentLevel);
  writer.writeDateTime(offsets[1], object.lastUpdated);
  writer.writeLong(offsets[2], object.totalStars);
  writer.writeStringList(offsets[3], object.unlockedBadges);
}

RewardsData _rewardsDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RewardsData();
  object.currentLevel = reader.readLong(offsets[0]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[1]);
  object.totalStars = reader.readLong(offsets[2]);
  object.unlockedBadges = reader.readStringList(offsets[3]) ?? [];
  return object;
}

P _rewardsDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _rewardsDataGetId(RewardsData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rewardsDataGetLinks(RewardsData object) {
  return [];
}

void _rewardsDataAttach(
    IsarCollection<dynamic> col, Id id, RewardsData object) {
  object.id = id;
}

extension RewardsDataQueryWhereSort
    on QueryBuilder<RewardsData, RewardsData, QWhere> {
  QueryBuilder<RewardsData, RewardsData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RewardsDataQueryWhere
    on QueryBuilder<RewardsData, RewardsData, QWhereClause> {
  QueryBuilder<RewardsData, RewardsData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<RewardsData, RewardsData, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterWhereClause> idBetween(
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

extension RewardsDataQueryFilter
    on QueryBuilder<RewardsData, RewardsData, QFilterCondition> {
  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      currentLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      currentLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      currentLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      currentLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      totalStarsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalStars',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      totalStarsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalStars',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      totalStarsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalStars',
        value: value,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      totalStarsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalStars',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedBadges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unlockedBadges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unlockedBadges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unlockedBadges',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unlockedBadges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unlockedBadges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unlockedBadges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unlockedBadges',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unlockedBadges',
        value: '',
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unlockedBadges',
        value: '',
      ));
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedBadges',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedBadges',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedBadges',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedBadges',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedBadges',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterFilterCondition>
      unlockedBadgesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'unlockedBadges',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RewardsDataQueryObject
    on QueryBuilder<RewardsData, RewardsData, QFilterCondition> {}

extension RewardsDataQueryLinks
    on QueryBuilder<RewardsData, RewardsData, QFilterCondition> {}

extension RewardsDataQuerySortBy
    on QueryBuilder<RewardsData, RewardsData, QSortBy> {
  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> sortByCurrentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy>
      sortByCurrentLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.desc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> sortByTotalStars() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStars', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> sortByTotalStarsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStars', Sort.desc);
    });
  }
}

extension RewardsDataQuerySortThenBy
    on QueryBuilder<RewardsData, RewardsData, QSortThenBy> {
  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenByCurrentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy>
      thenByCurrentLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.desc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenByTotalStars() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStars', Sort.asc);
    });
  }

  QueryBuilder<RewardsData, RewardsData, QAfterSortBy> thenByTotalStarsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalStars', Sort.desc);
    });
  }
}

extension RewardsDataQueryWhereDistinct
    on QueryBuilder<RewardsData, RewardsData, QDistinct> {
  QueryBuilder<RewardsData, RewardsData, QDistinct> distinctByCurrentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentLevel');
    });
  }

  QueryBuilder<RewardsData, RewardsData, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<RewardsData, RewardsData, QDistinct> distinctByTotalStars() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalStars');
    });
  }

  QueryBuilder<RewardsData, RewardsData, QDistinct> distinctByUnlockedBadges() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedBadges');
    });
  }
}

extension RewardsDataQueryProperty
    on QueryBuilder<RewardsData, RewardsData, QQueryProperty> {
  QueryBuilder<RewardsData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RewardsData, int, QQueryOperations> currentLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentLevel');
    });
  }

  QueryBuilder<RewardsData, DateTime, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<RewardsData, int, QQueryOperations> totalStarsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalStars');
    });
  }

  QueryBuilder<RewardsData, List<String>, QQueryOperations>
      unlockedBadgesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedBadges');
    });
  }
}
