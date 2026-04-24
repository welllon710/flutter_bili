// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get_demo/app/core/network/api.dart';
import 'package:get_demo/app/core/network/constants.dart';
import 'package:get_demo/app/data/models/error_message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "en";
const String TOKEN = "Bearer token";
const String BASE_URL = "http://localhost:8080";

/// woo 电商 api 请求工具类
class WooHttpUtil {
  static final WooHttpUtil _instance = WooHttpUtil._internal();
  factory WooHttpUtil() => _instance;

  static final RegExp _spmPrefixExp = RegExp(
    r'<meta name="spm_prefix" content="([^"]+?)">',
  );
  static String? _buvid;

  late Dio _dio;
  CookieManager? _cookieManager;
  Future<void>? _sessionInitFuture;

  String headerUa({type = 'mob'}) {
    String headerUa = '';
    if (type == 'mob') {
      if (Platform.isIOS) {
        headerUa =
            'Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1 Mobile/15E148 Safari/604.1';
      } else {
        headerUa =
            'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Mobile Safari/537.36';
      }
    } else {
      headerUa =
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15';
    }
    return headerUa;
  }

  /// 单例初始
  WooHttpUtil._internal() {
    // header 头
    Map<String, String> headers = {
      'env': 'prod',
      'app-key': 'android64',
      'x-bili-aurora-zone': 'sh001',
      'referer': 'https://www.bilibili.com/',
      // 'user-agent': headerUa(type: extra['ua']),

      // CONTENT_TYPE: APPLICATION_JSON,
      // ACCEPT: APPLICATION_JSON,
      // AUTHORIZATION: TOKEN,
      // DEFAULT_LANGUAGE: DEFAULT_LANGUAGE,
    };

    // 初始选项
    var options = BaseOptions(
      baseUrl: HttpString.apiBaseUrl,
      headers: headers,
      connectTimeout: const Duration(seconds: 5), // 5秒
      receiveTimeout: const Duration(seconds: 3), // 3秒
      responseType: ResponseType.json,
    );

    // 初始 dio
    _dio = Dio(options);

    // 拦截器 - 日志打印
    if (!kReleaseMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          error: false,
        ),
      );
    }

    // 拦截器
    _dio.interceptors.add(RequestInterceptors());
  }

  Future<void> initSessionContext() {
    _sessionInitFuture ??= _initSessionContextInternal();
    return _sessionInitFuture!;
  }

  Future<void> _initSessionContextInternal() async {
    final String cookiePath = await _getCookiePath();
    final PersistCookieJar cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    _cookieManager = CookieManager(cookieJar);
    if (!_dio.interceptors.any((it) => it is CookieManager)) {
      _dio.interceptors.insert(0, _cookieManager!);
    }

    try {
      // 预热 cookie，上下文更接近浏览器侧请求。
      await _dio.get(HttpString.baseUrl);
    } catch (_) {}

    try {
      await _buvidActivate();
    } catch (_) {}

    try {
      await getBuvid();
    } catch (_) {}

    await _refreshCookieHeader();
  }

  Future<String> _getCookiePath() async {
    final Directory baseDir = await getApplicationSupportDirectory();
    final Directory cookieDir = Directory('${baseDir.path}/cookies');
    if (!cookieDir.existsSync()) {
      cookieDir.createSync(recursive: true);
    }
    return cookieDir.path;
  }

  Future<void> _refreshCookieHeader() async {
    final CookieManager? manager = _cookieManager;
    if (manager == null) return;
    final List<Cookie> cookies = await manager.cookieJar.loadForRequest(
      Uri.parse(HttpString.baseUrl),
    );
    if (cookies.isEmpty) return;
    final String cookieString = cookies
        .map((Cookie c) => '${c.name}=${c.value}')
        .join('; ');
    _dio.options.headers['cookie'] = cookieString;
  }

  Future<void> _buvidActivate() async {
    final Response htmlResponse = await _dio.get(
      Api.dynamicSpmPrefix,
      options: Options(responseType: ResponseType.plain),
    );
    final String html = (htmlResponse.data ?? '').toString();
    final Match? match = _spmPrefixExp.firstMatch(html);
    if (match == null) return;
    final String spmPrefix = match.group(1)!;

    final Random rand = Random();
    final String randPngEnd = base64.encode(
      List<int>.generate(32, (_) => rand.nextInt(256)) +
          List<int>.filled(4, 0) +
          [73, 69, 78, 68] +
          List<int>.generate(4, (_) => rand.nextInt(256)),
    );

    final String jsonData = json.encode({
      '3064': 1,
      '39c8': '$spmPrefix.fp.risk',
      '3c43': {
        'adca': 'Linux',
        'bfe9': randPngEnd.substring(randPngEnd.length - 50),
      },
    });

    await _dio.post(
      Api.activateBuvidApi,
      data: {'payload': jsonData},
      options: Options(contentType: 'application/json'),
    );
  }

  Future<String> getBuvid() async {
    if (_buvid != null && _buvid!.isNotEmpty) {
      return _buvid!;
    }
    final CookieManager? manager = _cookieManager;
    if (manager != null) {
      final List<Cookie> cookies = await manager.cookieJar.loadForRequest(
        Uri.parse(HttpString.baseUrl),
      );
      final Cookie? buvidCookie = cookies.cast<Cookie?>().firstWhere(
        (Cookie? c) => c?.name == 'buvid3',
        orElse: () => null,
      );
      if (buvidCookie != null && buvidCookie.value.isNotEmpty) {
        _buvid = buvidCookie.value;
        return _buvid!;
      }
    }

    final Response result = await _dio.get(
      "${HttpString.apiBaseUrl}/x/frontend/finger/spi",
    );
    _buvid = (result.data?['data']?['b_3'] ?? '').toString();
    return _buvid ?? '';
  }

  /// get 请求
  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// post 请求
  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// put 请求
  Future<Response> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// delete 请求
  Future<Response> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }
}

/// 拦截
class RequestInterceptors extends Interceptor {
  //

  /// 发送请求
  /// 我们这里可以添加一些公共参数，或者对参数进行加密
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // super.onRequest(options, handler);

    // http header 头加入 Authorization
    // if (UserService.to.hasToken) {
    //   options.headers['Authorization'] = 'Bearer ${UserService.to.token}';
    // }

    return handler.next(options);
    // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  /// 响应
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 200 请求成功, 201 添加成功
    if (response.statusCode != 200 && response.statusCode != 201) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    } else {
      handler.next(response);
    }
  }

  // // 退出并重新登录
  // Future<void> _errorNoAuthLogout() async {
  //   await UserService.to.logout();
  //   IMService.to.logout();
  //   Get.toNamed(RouteNames.systemLogin);
  // }

  /// 错误
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final exception = HttpException(err.message ?? "error message");
    switch (err.type) {
      case DioExceptionType.badResponse: // 服务端自定义错误体处理
        {
          final response = err.response;
          final errorMessage = ErrorMessageModel.fromJson(response?.data);
          switch (errorMessage.statusCode) {
            // 401 未登录
            case 401:
              // 注销 并跳转到登录页面
              // _errorNoAuthLogout();
              break;
            case 404:
              break;
            case 500:
              break;
            case 502:
              break;
            default:
              break;
          }
          // 显示错误信息
          // if(errorMessage.message != null){
          //   Loading.error(errorMessage.message);
          // }
        }
        break;
      case DioExceptionType.unknown:
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionTimeout:
        break;
      default:
        break;
    }
    DioException errNext = err.copyWith(error: exception);
    handler.next(errNext);
  }
}
