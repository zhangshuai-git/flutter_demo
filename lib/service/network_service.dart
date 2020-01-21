import 'package:dio/dio.dart';
import 'package:flutter_demo1/model/entity.dart';

class NetworkService {
  static String baseUrl = "https://api.github.com";
  static Dio dio = Dio();

  static Stream<Repositories> searchRepositories(String query) {
    final path = "/search/repositories";
    final param = RepositoriesParams(query);
    print("param: ${param.toJson()}");
    return Stream.fromFuture(dio.get(baseUrl + path, queryParameters: param.toJson(),).catchError((onError) {
      print("onError: $onError");
    })).map((res) {
//      print("res: ${res.data}");
      return Repositories.fromJson(res.data);
    });
  }
}