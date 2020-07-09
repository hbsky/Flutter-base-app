import 'package:base_app/const/const.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

enum RequestMethod { POST, GET, PUT }

const Duration DEFAULT_CACHE_DURATION = Duration(days: 7);
const DEFAULT_HEADER = {
  "Content-Type": "application/json",
};

/// BaseRequest is Singleton, it means you can not use multiple BaseRequest in your application,
/// but you can recreate BaseRequest when you need.
/// Eg: you create BaseRequest with [connectionTimeout] = `10000 ms` for normal request,
/// then you recreate BaseRequest with [connectionTimeout] = `300000 ms` for downloading file.
/// It is possible.
///
/// `baseUrl`: http base url
///
/// `connectionTimeout`: connection timeout in connecting and receiving in milliseconds, default value is `10000 ms`
///
/// `cacheDuration`: how long http cache will be store,
/// it will work when params `isBuildCacheOptions` in [sendRequest] is `true`, default value is [DEFAULT_CACHE_DURATION]
class BaseRequest extends _Request {
  factory BaseRequest(String baseUrl,
      {int connectionTimeout = cRequestTimeOut,
      Duration cacheDuration = DEFAULT_CACHE_DURATION}) {
    _instance._baseUrl = baseUrl;
    _instance._dio = _instance._getBaseDio();
    _instance._connectionTimeOut = connectionTimeout;
    _instance._cacheDuration = cacheDuration;
    return _instance;
  }

  /// Easy to get Base request instance
  static BaseRequest get I => _instance;

  static final _instance = BaseRequest._internal();

  BaseRequest._internal();
}

abstract class _Request {
  String _baseUrl;
  Dio _dio;
  int _connectionTimeOut;
  Duration _cacheDuration;

  // ---------- PRIVATE COMMANDS ---------- \\
  Dio _getBaseDio() {
    Dio dio = Dio();

    dio.options.baseUrl = _baseUrl;
    dio.options.connectTimeout = _connectionTimeOut ?? cRequestTimeOut;
    dio.options.receiveTimeout = _connectionTimeOut ?? cRequestTimeOut;
    return dio;
  }

  Options _buildCacheOptions(
      Map<String, String> headers, RequestMethod requestMethod,
      {ResponseType responseType = ResponseType.json}) {
    return buildCacheOptions(_cacheDuration,
        maxStale: _cacheDuration,
        options: Options(
            headers: headers,
            method: requestMethod.toString(),
            responseType: responseType),
        forceRefresh: false);
  }

  DioCacheManager _buildDioCacheManager() {
    return DioCacheManager(CacheConfig(
        baseUrl: _baseUrl,
        defaultMaxAge: _cacheDuration,
        defaultMaxStale: _cacheDuration));
  }

  // ---------- COMMANDS ---------- \\
  void close() {
    _dio.close(force: true);
    updateCurrentDio();
  }

  void updateCurrentDio() {
    _dio = _getBaseDio();
  }

  Dio getCurrentDio() {
    return _dio;
  }

  /// Send a http request to server
  ///
  /// `action`: final url will be: [_baseUrl] + [action]
  ///
  /// `headers`: http headers, default is [DEFAULT_HEADER]
  ///
  /// `jsonMap`: requests params/body will be send in request
  ///
  /// `isBuildCacheOptions` if `true` request will save to cache.
  /// In the nextTime, request will load cache if request failure
  ///
  /// `responseType`: response type when a request success
  Future<dynamic> sendRequest(String action, RequestMethod requestMethod,
      {Map<String, String> headers = DEFAULT_HEADER,
      Map<String, String> jsonMap,
      bool isBuildCacheOptions = false,
      ResponseType responseType}) async {
    Response response;

    if (isBuildCacheOptions) {
      _dio.interceptors.add(_buildDioCacheManager().interceptor);
    }

    Options options = isBuildCacheOptions
        ? _buildCacheOptions(headers, requestMethod, responseType: responseType)
        : Options(
            headers: headers,
            method: requestMethod.toString(),
            responseType: ResponseType.json);

    if (requestMethod == RequestMethod.POST) {
      response = await _dio.post(action, data: jsonMap, options: options);
    } else if (requestMethod == RequestMethod.GET) {
      response =
          await _dio.get(action, queryParameters: jsonMap, options: options);
    }
    return response.data;
  }
}
