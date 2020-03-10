import 'package:dio/dio.dart';
import 'package:flutter_demo1/domain/entity.dart';
import 'package:flutter_demo1/utility/extension.dart';

class NetworkService {
  static NetworkService _instance;
  NetworkService._internal();
  static _getInstance() {
    if (_instance == null) {
      _instance = NetworkService._internal();
    }
    return _instance;
  }
  factory NetworkService.getInstance() => _getInstance();

  final Dio dio = Dio();
  static const String baseUrl = "https://api.github.com";

  Stream<Repositories> searchRepositories(RepositoriesParams param) {
    final url = baseUrl + "/search/repositories";
    if (param.query.isNullOrEmpty()) {
      return Stream.value(Repositories());
    } else {
      log("GET: $url ${param.toJson()}");
      return dio
        .get(url, queryParameters: param.toJson(), options: Options(responseType: ResponseType.json))
        .catchError((onError) => log("onError: $onError"))
        .asStream()
        .map((res) => res == null ? Repositories() : Repositories.fromJson(res.data ?? {}));
    }
  }
}