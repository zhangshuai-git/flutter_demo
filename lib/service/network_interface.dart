import 'package:flutter_demo1/domain/entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'network_interface.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class NetworkInterface {
  factory NetworkInterface(Dio dio, {String baseUrl}) = _NetworkInterface;

  @GET("/search/repositories")
  Future<Repositories> searchRepositories(@Queries() Map<String, dynamic> param);

}
