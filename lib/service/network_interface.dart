import 'package:flutter_demo1/domain/entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'network_interface.g.dart';

@RestApi(baseUrl: "https://api.github.com")
abstract class NetworkInterface {
  factory NetworkInterface(Dio dio, {String baseUrl}) = _NetworkInterface;

  @GET("/search/repositories")
  Future<Repositories> searchRepositories({
    @Query("q") String query,
    @Query("sort") String sort = "stars",
    @Query("order") String order = "desc",
    @Query("per_page") int perPage = PER_PAGE,
    @Query("page") int page = 1
  });

}
