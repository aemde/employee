import 'package:dio/dio.dart';
import 'package:employee/app/data/shared_preferences/shared_preferences.dart';
import 'package:employee/core/keys/headers.dart';
import 'package:employee/core/keys/pref_keys.dart';
import 'package:employee/core/resources/app_urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class AppDioInterceptor extends Interceptor {
  final BuildContext context;
  String token = "";
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  AppDioInterceptor(this.context) {
    Prefs.getPrefs().then((prefs) {
      token = prefs.getString(PrefKey.authorization) ?? "";
    });
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Map<String, dynamic> er = {
      "type": err.type,
      "message": err.message,
      "status_code": err.response?.statusCode,
      "status_message": err.response?.statusMessage,
      "headers": err.response?.headers,
      "data": err.response?.data,
      "response": err.response,
    };
    logger.e(er);

    if (err.response != null) {
      handler.resolve(err.response!);
    } else {
      handler.next(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Map<String, dynamic> er = {
      "base_url": response.requestOptions.baseUrl,
      "end_point": response.requestOptions.path,
      "method": response.requestOptions.method,
      "status_code": response.statusCode,
      "status_message": response.statusMessage,
      "headers": response.headers,
      "data": response.data,
      "extra": response.extra,
      "response": response,
    };
    logger.i(er);

    handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppUrls.baseUrl.isEmpty) {
      throw Exception("Base URL is not set");
    }

    options..baseUrl = AppUrls.baseUrl;
    if (token.isNotEmpty) {
      options..headers.addAll({RequestHeader.authorization: "Bearer $token"});
    }

    Map<String, dynamic> er = {
      "base_url": options.baseUrl,
      "end_point": options.path,
      "method": options.method,
      "headers": options.headers,
      "params": options.queryParameters,
      "data": options.data,
      "extra": options.extra,
    };
    logger.d(er);

    handler.next(options);
  }
}
