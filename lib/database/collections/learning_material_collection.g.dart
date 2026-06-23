// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_material_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLearningMaterialEntityCollection on Isar {
  IsarCollection<LearningMaterialEntity> get learningMaterialEntitys =>
      this.collection();
}

const LearningMaterialEntitySchema = CollectionSchema(
  name: r'LearningMaterialEntity',
  id: -437356215016307091,
  properties: {
    r'audioPath': PropertySchema(
      id: 0,
      name: r'audioPath',
      type: IsarType.string,
    ),
    r'audioStoragePath': PropertySchema(
      id: 1,
      name: r'audioStoragePath',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 2,
      name: r'category',
      type: IsarType.string,
    ),
    r'cloudUpdatedAt': PropertySchema(
      id: 3,
      name: r'cloudUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'cloudVersion': PropertySchema(
      id: 4,
      name: r'cloudVersion',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 6,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'favorite': PropertySchema(
      id: 7,
      name: r'favorite',
      type: IsarType.bool,
    ),
    r'fileName': PropertySchema(
      id: 8,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 9,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'imageStoragePath': PropertySchema(
      id: 10,
      name: r'imageStoragePath',
      type: IsarType.string,
    ),
    r'materialId': PropertySchema(
      id: 11,
      name: r'materialId',
      type: IsarType.string,
    ),
    r'mediaVersion': PropertySchema(
      id: 12,
      name: r'mediaVersion',
      type: IsarType.long,
    ),
    r'sourceUrl': PropertySchema(
      id: 13,
      name: r'sourceUrl',
      type: IsarType.string,
    ),
    r'subcategory': PropertySchema(
      id: 14,
      name: r'subcategory',
      type: IsarType.string,
    ),
    r'syncState': PropertySchema(
      id: 15,
      name: r'syncState',
      type: IsarType.string,
    ),
    r'thumbnailPath': PropertySchema(
      id: 16,
      name: r'thumbnailPath',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 17,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 18,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'videoPath': PropertySchema(
      id: 19,
      name: r'videoPath',
      type: IsarType.string,
    ),
    r'videoStoragePath': PropertySchema(
      id: 20,
      name: r'videoStoragePath',
      type: IsarType.string,
    )
  },
  estimateSize: _learningMaterialEntityEstimateSize,
  serialize: _learningMaterialEntitySerialize,
  deserialize: _learningMaterialEntityDeserialize,
  deserializeProp: _learningMaterialEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'materialId': IndexSchema(
      id: -4039490305560314015,
      name: r'materialId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'materialId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'favorite': IndexSchema(
      id: 4264748667377999100,
      name: r'favorite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'favorite',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _learningMaterialEntityGetId,
  getLinks: _learningMaterialEntityGetLinks,
  attach: _learningMaterialEntityAttach,
  version: '3.1.0+1',
);

int _learningMaterialEntityEstimateSize(
  LearningMaterialEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.audioPath.length * 3;
  bytesCount += 3 + object.audioStoragePath.length * 3;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.fileName.length * 3;
  bytesCount += 3 + object.imagePath.length * 3;
  bytesCount += 3 + object.imageStoragePath.length * 3;
  bytesCount += 3 + object.materialId.length * 3;
  bytesCount += 3 + object.sourceUrl.length * 3;
  bytesCount += 3 + object.subcategory.length * 3;
  bytesCount += 3 + object.syncState.length * 3;
  bytesCount += 3 + object.thumbnailPath.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.videoPath.length * 3;
  bytesCount += 3 + object.videoStoragePath.length * 3;
  return bytesCount;
}

void _learningMaterialEntitySerialize(
  LearningMaterialEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.audioPath);
  writer.writeString(offsets[1], object.audioStoragePath);
  writer.writeString(offsets[2], object.category);
  writer.writeDateTime(offsets[3], object.cloudUpdatedAt);
  writer.writeLong(offsets[4], object.cloudVersion);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeDateTime(offsets[6], object.deletedAt);
  writer.writeBool(offsets[7], object.favorite);
  writer.writeString(offsets[8], object.fileName);
  writer.writeString(offsets[9], object.imagePath);
  writer.writeString(offsets[10], object.imageStoragePath);
  writer.writeString(offsets[11], object.materialId);
  writer.writeLong(offsets[12], object.mediaVersion);
  writer.writeString(offsets[13], object.sourceUrl);
  writer.writeString(offsets[14], object.subcategory);
  writer.writeString(offsets[15], object.syncState);
  writer.writeString(offsets[16], object.thumbnailPath);
  writer.writeString(offsets[17], object.title);
  writer.writeDateTime(offsets[18], object.updatedAt);
  writer.writeString(offsets[19], object.videoPath);
  writer.writeString(offsets[20], object.videoStoragePath);
}

LearningMaterialEntity _learningMaterialEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LearningMaterialEntity();
  object.audioPath = reader.readString(offsets[0]);
  object.audioStoragePath = reader.readString(offsets[1]);
  object.category = reader.readString(offsets[2]);
  object.cloudUpdatedAt = reader.readDateTimeOrNull(offsets[3]);
  object.cloudVersion = reader.readLong(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[5]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[6]);
  object.favorite = reader.readBool(offsets[7]);
  object.fileName = reader.readString(offsets[8]);
  object.id = id;
  object.imagePath = reader.readString(offsets[9]);
  object.imageStoragePath = reader.readString(offsets[10]);
  object.materialId = reader.readString(offsets[11]);
  object.mediaVersion = reader.readLong(offsets[12]);
  object.sourceUrl = reader.readString(offsets[13]);
  object.subcategory = reader.readString(offsets[14]);
  object.syncState = reader.readString(offsets[15]);
  object.thumbnailPath = reader.readString(offsets[16]);
  object.title = reader.readString(offsets[17]);
  object.updatedAt = reader.readDateTime(offsets[18]);
  object.videoPath = reader.readString(offsets[19]);
  object.videoStoragePath = reader.readString(offsets[20]);
  return object;
}

P _learningMaterialEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readDateTime(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _learningMaterialEntityGetId(LearningMaterialEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _learningMaterialEntityGetLinks(
    LearningMaterialEntity object) {
  return [];
}

void _learningMaterialEntityAttach(
    IsarCollection<dynamic> col, Id id, LearningMaterialEntity object) {
  object.id = id;
}

extension LearningMaterialEntityByIndex
    on IsarCollection<LearningMaterialEntity> {
  Future<LearningMaterialEntity?> getByMaterialId(String materialId) {
    return getByIndex(r'materialId', [materialId]);
  }

  LearningMaterialEntity? getByMaterialIdSync(String materialId) {
    return getByIndexSync(r'materialId', [materialId]);
  }

  Future<bool> deleteByMaterialId(String materialId) {
    return deleteByIndex(r'materialId', [materialId]);
  }

  bool deleteByMaterialIdSync(String materialId) {
    return deleteByIndexSync(r'materialId', [materialId]);
  }

  Future<List<LearningMaterialEntity?>> getAllByMaterialId(
      List<String> materialIdValues) {
    final values = materialIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'materialId', values);
  }

  List<LearningMaterialEntity?> getAllByMaterialIdSync(
      List<String> materialIdValues) {
    final values = materialIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'materialId', values);
  }

  Future<int> deleteAllByMaterialId(List<String> materialIdValues) {
    final values = materialIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'materialId', values);
  }

  int deleteAllByMaterialIdSync(List<String> materialIdValues) {
    final values = materialIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'materialId', values);
  }

  Future<Id> putByMaterialId(LearningMaterialEntity object) {
    return putByIndex(r'materialId', object);
  }

  Id putByMaterialIdSync(LearningMaterialEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'materialId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMaterialId(List<LearningMaterialEntity> objects) {
    return putAllByIndex(r'materialId', objects);
  }

  List<Id> putAllByMaterialIdSync(List<LearningMaterialEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'materialId', objects, saveLinks: saveLinks);
  }
}

extension LearningMaterialEntityQueryWhereSort
    on QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QWhere> {
  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterWhere>
      anyFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'favorite'),
      );
    });
  }
}

extension LearningMaterialEntityQueryWhere on QueryBuilder<
    LearningMaterialEntity, LearningMaterialEntity, QWhereClause> {
  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> materialIdEqualTo(String materialId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'materialId',
        value: [materialId],
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> materialIdNotEqualTo(String materialId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materialId',
              lower: [],
              upper: [materialId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materialId',
              lower: [materialId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materialId',
              lower: [materialId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'materialId',
              lower: [],
              upper: [materialId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> categoryEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [category],
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> categoryNotEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> favoriteEqualTo(bool favorite) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'favorite',
        value: [favorite],
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterWhereClause> favoriteNotEqualTo(bool favorite) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [],
              upper: [favorite],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [favorite],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [favorite],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'favorite',
              lower: [],
              upper: [favorite],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LearningMaterialEntityQueryFilter on QueryBuilder<
    LearningMaterialEntity, LearningMaterialEntity, QFilterCondition> {
  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      audioPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      audioPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioStoragePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      audioStoragePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      audioStoragePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioStoragePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioStoragePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> audioStoragePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioStoragePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudUpdatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cloudUpdatedAt',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudUpdatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cloudUpdatedAt',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudUpdatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cloudUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudUpdatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cloudUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudUpdatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cloudUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudUpdatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cloudUpdatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cloudVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cloudVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cloudVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> cloudVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cloudVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> favoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'favorite',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageStoragePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      imageStoragePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      imageStoragePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageStoragePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageStoragePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> imageStoragePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageStoragePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materialId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'materialId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'materialId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'materialId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'materialId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'materialId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      materialIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'materialId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      materialIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'materialId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'materialId',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> materialIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'materialId',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> mediaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> mediaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> mediaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> mediaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      sourceUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      sourceUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> sourceUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subcategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subcategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subcategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subcategory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subcategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subcategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      subcategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subcategory',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      subcategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subcategory',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subcategory',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> subcategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subcategory',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      syncStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      syncStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> syncStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncState',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnailPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      thumbnailPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      thumbnailPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbnailPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> thumbnailPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbnailPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      videoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      videoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoStoragePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      videoStoragePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoStoragePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
          QAfterFilterCondition>
      videoStoragePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoStoragePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoStoragePath',
        value: '',
      ));
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity,
      QAfterFilterCondition> videoStoragePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoStoragePath',
        value: '',
      ));
    });
  }
}

extension LearningMaterialEntityQueryObject on QueryBuilder<
    LearningMaterialEntity, LearningMaterialEntity, QFilterCondition> {}

extension LearningMaterialEntityQueryLinks on QueryBuilder<
    LearningMaterialEntity, LearningMaterialEntity, QFilterCondition> {}

extension LearningMaterialEntityQuerySortBy
    on QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QSortBy> {
  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByAudioStoragePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioStoragePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByAudioStoragePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioStoragePath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCloudUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCloudUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCloudVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudVersion', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCloudVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudVersion', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByImageStoragePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageStoragePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByImageStoragePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageStoragePath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByMaterialId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByMaterialIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByMediaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaVersion', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByMediaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaVersion', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortBySourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortBySourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortBySubcategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subcategory', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortBySubcategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subcategory', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByThumbnailPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByThumbnailPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByVideoStoragePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoStoragePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      sortByVideoStoragePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoStoragePath', Sort.desc);
    });
  }
}

extension LearningMaterialEntityQuerySortThenBy on QueryBuilder<
    LearningMaterialEntity, LearningMaterialEntity, QSortThenBy> {
  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByAudioPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByAudioPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioPath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByAudioStoragePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioStoragePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByAudioStoragePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioStoragePath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCloudUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCloudUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCloudVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudVersion', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCloudVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cloudVersion', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'favorite', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByImageStoragePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageStoragePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByImageStoragePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageStoragePath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByMaterialId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByMaterialIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByMediaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaVersion', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByMediaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaVersion', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenBySourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenBySourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenBySubcategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subcategory', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenBySubcategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subcategory', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByThumbnailPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByThumbnailPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByVideoStoragePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoStoragePath', Sort.asc);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QAfterSortBy>
      thenByVideoStoragePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoStoragePath', Sort.desc);
    });
  }
}

extension LearningMaterialEntityQueryWhereDistinct
    on QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct> {
  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByAudioPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByAudioStoragePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioStoragePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByCloudUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cloudUpdatedAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByCloudVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cloudVersion');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'favorite');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByImageStoragePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageStoragePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByMaterialId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materialId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByMediaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaVersion');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctBySourceUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctBySubcategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subcategory', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctBySyncState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByThumbnailPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbnailPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByVideoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningMaterialEntity, LearningMaterialEntity, QDistinct>
      distinctByVideoStoragePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoStoragePath',
          caseSensitive: caseSensitive);
    });
  }
}

extension LearningMaterialEntityQueryProperty on QueryBuilder<
    LearningMaterialEntity, LearningMaterialEntity, QQueryProperty> {
  QueryBuilder<LearningMaterialEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      audioPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioPath');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      audioStoragePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioStoragePath');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<LearningMaterialEntity, DateTime?, QQueryOperations>
      cloudUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cloudUpdatedAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, int, QQueryOperations>
      cloudVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cloudVersion');
    });
  }

  QueryBuilder<LearningMaterialEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, bool, QQueryOperations>
      favoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'favorite');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      imageStoragePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageStoragePath');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      materialIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materialId');
    });
  }

  QueryBuilder<LearningMaterialEntity, int, QQueryOperations>
      mediaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaVersion');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      sourceUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceUrl');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      subcategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subcategory');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      thumbnailPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbnailPath');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<LearningMaterialEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      videoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoPath');
    });
  }

  QueryBuilder<LearningMaterialEntity, String, QQueryOperations>
      videoStoragePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoStoragePath');
    });
  }
}
