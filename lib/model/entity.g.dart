// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepositoriesParams _$RepositoriesParamsFromJson(Map<String, dynamic> json) {
  return RepositoriesParams(
    json['q'] as String,
    sort: json['sort'] as String,
    order: json['order'] as String,
    perPage: json['per_page'] as int,
    page: json['page'] as int,
  );
}

Map<String, dynamic> _$RepositoriesParamsToJson(RepositoriesParams instance) =>
    <String, dynamic>{
      'q': instance.query,
      'sort': instance.sort,
      'order': instance.order,
      'per_page': instance.perPage,
      'page': instance.page,
    };

Repositories _$RepositoriesFromJson(Map<String, dynamic> json) {
  return Repositories(
    totalCount: json['total_count'] as int,
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : Repository.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    currentPage: json['currentPage'] as int,
  );
}

Map<String, dynamic> _$RepositoriesToJson(Repositories instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'items': instance.items,
      'currentPage': instance.currentPage,
    };

Repository _$RepositoryFromJson(Map<String, dynamic> json) {
  return Repository(
    id: json['id'] as int,
    name: json['name'] as String,
    fullName: json['full_name'] as String,
    htmlUrl: json['html_url'] as String,
    desp: json['description'] as String,
    comment: json['comment'] as String,
    owner: json['owner'] == null
        ? null
        : RepositoryOwner.fromJson(json['owner'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'html_url': instance.htmlUrl,
      'description': instance.desp,
      'comment': instance.comment,
      'owner': instance.owner,
    };

RepositoryOwner _$RepositoryOwnerFromJson(Map<String, dynamic> json) {
  return RepositoryOwner(
    id: json['id'] as int,
    login: json['login'] as String,
    url: json['url'] as String,
    avatarUrl: json['avatar_url'] as String,
  );
}

Map<String, dynamic> _$RepositoryOwnerToJson(RepositoryOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'url': instance.url,
      'avatar_url': instance.avatarUrl,
    };
