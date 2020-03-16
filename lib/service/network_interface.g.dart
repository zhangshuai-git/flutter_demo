// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_interface.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _NetworkInterface implements NetworkInterface {
  _NetworkInterface(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://api.github.com';
  }

  final Dio _dio;

  String baseUrl;

  @override
  searchRepositories(param) async {
    ArgumentError.checkNotNull(param, 'param');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(param ?? <String, dynamic>{});
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/search/repositories',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Repositories.fromJson(_result.data);
    return Future.value(value);
  }
}
