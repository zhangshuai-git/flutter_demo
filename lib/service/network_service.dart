import 'package:dio/dio.dart';
import 'package:flutter_demo1/model/entity.dart';

class NetworkService {
  static String baseUrl = "https://api.github.com";
  static Dio dio = Dio();

  static Stream<Repositories> searchRepositories(RepositoriesParams param) {
    final path = "/search/repositories";
    print("param: ${param.toJson()}");
    return Stream
      .fromFuture(dio
      .get(baseUrl + path, queryParameters: param.toJson(), options: Options(responseType: ResponseType.json))
      .catchError((onError) => print("onError: $onError")))
      .map((res) => Repositories.fromJson(res.data));
  }
}