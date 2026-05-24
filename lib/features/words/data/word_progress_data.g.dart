// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_progress_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWordProgressDataCollection on Isar {
  IsarCollection<WordProgressData> get wordProgressDatas => this.collection();
}

const WordProgressDataSchema = CollectionSchema(
  name: r'WordProgressData',
  id: 2407956497578662366,
  properties: {
    r'lastPlayed': PropertySchema(
      id: 0,
      name: r'lastPlayed',
      type: IsarType.dateTime,
    ),
    r'syllableCompleted': PropertySchema(
      id: 1,
      name: r'syllableCompleted',
      type: IsarType.long,
    ),
    r'wordMatchCompleted': PropertySchema(
      id: 2,
      name: r'wordMatchCompleted',
      type: IsarType.long,
    )
  },
  estimateSize: _wordProgressDataEstimateSize,
  serialize: _wordProgressDataSerialize,
  deserialize: _wordProgressDataDeserialize,
  deserializeProp: _wordProgressDataDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _wordProgressDataGetId,
  getLinks: _wordProgressDataGetLinks,
  attach: _wordProgressDataAttach,
  version: '3.1.0+1',
);

int _wordProgressDataEstimateSize(
  WordProgressData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _wordProgressDataSerialize(
  WordProgressData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastPlayed);
  writer.writeLong(offsets[1], object.syllableCompleted);
  writer.writeLong(offsets[2], object.wordMatchCompleted);
}

WordProgressData _wordProgressDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordProgressData();
  object.id = id;
  object.lastPlayed = reader.readDateTimeOrNull(offsets[0]);
  object.syllableCompleted = reader.readLong(offsets[1]);
  object.wordMatchCompleted = reader.readLong(offsets[2]);
  return object;
}

P _wordProgressDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wordProgressDataGetId(WordProgressData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wordProgressDataGetLinks(WordProgressData object) {
  return [];
}

void _wordProgressDataAttach(
    IsarCollection<dynamic> col, Id id, WordProgressData object) {
  object.id = id;
}

extension WordProgressDataQueryWhereSort
    on QueryBuilder<WordProgressData, WordProgressData, QWhere> {
  QueryBuilder<WordProgressData, WordProgressData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WordProgressDataQueryWhere
    on QueryBuilder<WordProgressData, WordProgressData, QWhereClause> {
  QueryBuilder<WordProgressData, WordProgressData, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<WordProgressData, WordProgressData, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterWhereClause> idBetween(
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

extension WordProgressDataQueryFilter
    on QueryBuilder<WordProgressData, WordProgressData, QFilterCondition> {
  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
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

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
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

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      lastPlayedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPlayed',
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      lastPlayedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPlayed',
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      lastPlayedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      lastPlayedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      lastPlayedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      lastPlayedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      syllableCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syllableCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      syllableCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syllableCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      syllableCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syllableCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      syllableCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syllableCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      wordMatchCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordMatchCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      wordMatchCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordMatchCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      wordMatchCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordMatchCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterFilterCondition>
      wordMatchCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordMatchCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WordProgressDataQueryObject
    on QueryBuilder<WordProgressData, WordProgressData, QFilterCondition> {}

extension WordProgressDataQueryLinks
    on QueryBuilder<WordProgressData, WordProgressData, QFilterCondition> {}

extension WordProgressDataQuerySortBy
    on QueryBuilder<WordProgressData, WordProgressData, QSortBy> {
  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      sortByLastPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      sortByLastPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.desc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      sortBySyllableCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syllableCompleted', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      sortBySyllableCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syllableCompleted', Sort.desc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      sortByWordMatchCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMatchCompleted', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      sortByWordMatchCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMatchCompleted', Sort.desc);
    });
  }
}

extension WordProgressDataQuerySortThenBy
    on QueryBuilder<WordProgressData, WordProgressData, QSortThenBy> {
  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenByLastPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenByLastPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlayed', Sort.desc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenBySyllableCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syllableCompleted', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenBySyllableCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syllableCompleted', Sort.desc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenByWordMatchCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMatchCompleted', Sort.asc);
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QAfterSortBy>
      thenByWordMatchCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordMatchCompleted', Sort.desc);
    });
  }
}

extension WordProgressDataQueryWhereDistinct
    on QueryBuilder<WordProgressData, WordProgressData, QDistinct> {
  QueryBuilder<WordProgressData, WordProgressData, QDistinct>
      distinctByLastPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPlayed');
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QDistinct>
      distinctBySyllableCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syllableCompleted');
    });
  }

  QueryBuilder<WordProgressData, WordProgressData, QDistinct>
      distinctByWordMatchCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordMatchCompleted');
    });
  }
}

extension WordProgressDataQueryProperty
    on QueryBuilder<WordProgressData, WordProgressData, QQueryProperty> {
  QueryBuilder<WordProgressData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WordProgressData, DateTime?, QQueryOperations>
      lastPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPlayed');
    });
  }

  QueryBuilder<WordProgressData, int, QQueryOperations>
      syllableCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syllableCompleted');
    });
  }

  QueryBuilder<WordProgressData, int, QQueryOperations>
      wordMatchCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordMatchCompleted');
    });
  }
}
