import 'package:english_words/english_words.dart';
import 'package:rxdart/rxdart.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

class Word {
  WordPair wordPair;
  BehaviorSubject<bool> isFavorite;

  Word(this.wordPair, this.isFavorite);
}

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

  RepositoriesParams(this.query, {this.sort = "stars", this.order = "desc", this.perPage = 10,
    this.page = 1});
}

@JsonSerializable()
class Repositories {
  @JsonKey(name: 'total_count')
  int totalCount;

  List<Repository> items;

  int currentPage;

  int get totalPage => totalCount ~/ 10;

  factory Repositories.fromJson(Map<String, dynamic> json) => _$RepositoriesFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoriesToJson(this);

  Repositories({this.totalCount, this.items, this.currentPage});
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

  bool isSubscribed;

  RepositoryOwner owner;

  factory Repository.fromJson(Map<String, dynamic> json) => _$RepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryToJson(this);

  Repository(this.id, this.name, this.fullName, this.htmlUrl, this.desp,
    this.comment, this.isSubscribed, this.owner);
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

  RepositoryOwner(this.id, this.login, this.url, this.avatarUrl);
}