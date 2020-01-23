import 'dart:math';
import 'package:flutter_demo1/service/database_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_demo1/utility/extension.dart';

part 'entity.g.dart';

const PER_PAGE = 20;

@JsonSerializable()
class RepositoriesParams {
  @JsonKey(name: 'q')
  String query;

  String sort;

  String order;

  @JsonKey(name: 'per_page')
  int perPage;

  int page;

  factory RepositoriesParams.fromJson(Map<String, dynamic> json) => _$RepositoriesParamsFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoriesParamsToJson(this);

  RepositoriesParams(this.query, {this.sort = "stars", this.order = "desc", this.perPage = PER_PAGE,
    this.page = 1});
}

@JsonSerializable()
class Repositories {
  @JsonKey(name: 'total_count')
  int totalCount;

  List<Repository> items;

  int currentPage;

  int get totalPage => totalCount ~/ PER_PAGE;

  Repositories operator + (Repositories other) {
    final obj = Repositories();
    obj.totalCount = max(this.totalCount ?? 0, other.totalCount ?? 0);
    obj.items = this.items + other.items;
    obj.currentPage = max(this.currentPage ?? 0, other.currentPage ?? 0);
    return obj;
  }

  factory Repositories.fromJson(Map<String, dynamic> json) => _$RepositoriesFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoriesToJson(this);

  Repositories({this.totalCount = 0, this.items = const [], this.currentPage = 1});
}

@JsonSerializable()
class Repository {
  int id;

  String name;

  @JsonKey(name: 'full_name')
  String fullName;

  @JsonKey(name: 'html_url')
  String htmlUrl;

  @JsonKey(name: 'description')
  String desp;

  String comment;

  @JsonKey(ignore: true)
  final BehaviorSubject<bool> isSubscribed = BehaviorSubject.seeded(false);

  RepositoryOwner owner = RepositoryOwner();

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryToJson(this);

  Repository({this.id, this.name, this.fullName, this.htmlUrl, this.desp,
    this.comment, this.owner}) {
    log("${this.name} -> owner: ${this.owner}");
    final databaseService = DatabaseService.getInstance();
    this.isSubscribed
      .share()
      .skip(1)
      .doOnData((it) => log("${this.name} -> doOnData: $it"))
      .listen((it) => it ? databaseService.add(this) : databaseService.delete(this));
  }
}

@JsonSerializable()
class RepositoryOwner {
  int id;

  String login;

  String url;

  @JsonKey(name: 'avatar_url')
  String avatarUrl;

  factory RepositoryOwner.fromJson(Map<String, dynamic> json) => _$RepositoryOwnerFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryOwnerToJson(this);

  RepositoryOwner({this.id, this.login, this.url, this.avatarUrl});
}