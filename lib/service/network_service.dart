import 'package:dio/dio.dart';
import 'package:flutter_demo1/model/entity.dart';

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
    final path = "/search/repositories";
    print("param: ${param.toJson()}");
    return Stream
      .fromFuture(dio
      .get(baseUrl + path, queryParameters: param.toJson(), options: Options(responseType: ResponseType.json))
      .catchError((onError) => print("onError: $onError")))
      .map((res) => res == null ? Repositories() : Repositories.fromJson(res.data ?? {}));
  }
}