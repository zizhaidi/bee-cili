import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

const baseUrl = 'https://api.baidu.com/';
const apiKey = 'mytestservers';
const headers = {'apikey': apiKey};

class DioClient {
  final _dio = createDio();

  static Dio createDio() {
    var dio = Dio(
      BaseOptions(connectTimeout: 5000, receiveTimeout: 4000, headers: headers),
    )..interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function (optional)
      retries: 3, // retry count (optional)
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));
    return dio;
  }

  DioClient._internal();

  static final _singleton = DioClient._internal();

  factory DioClient() => _singleton;

  // 获取种子数状态数据
  Future<Response> getStatus() => _dio.get(
        '${baseUrl}status',
        options: buildCacheOptions(const Duration(hours: 1)),
      );

  // 根据查询获取种子列表
  Future<Response> getTorrents(
      {required int limit, required int page, String? q, String? sort}) {
    Map<String, dynamic> query = {
      "limit": limit.toString(),
      "page": page.toString(),
    };
    if (q != null) {
      query.addAll(
        {
          "q": q,
        },
      );
    }
    if (sort != null) {
      query.addAll({"sort": sort});
    }
    return _dio.get(
      '${baseUrl}torrents',
      queryParameters: query,
      options: buildCacheOptions(const Duration(hours: 1)),
    );
  }

  // 获取推广内容
  Future<Response> getAds() => _dio.get(
        '${baseUrl}ads',
        options: buildCacheOptions(const Duration(hours: 1)),
      );

  // 获取种子详情
  Future<Response> getTorrent(String id) => _dio.get(
        '${baseUrl}torrent',
        queryParameters: {"id": id},
        options: buildCacheOptions(const Duration(hours: 1)),
      );
}
