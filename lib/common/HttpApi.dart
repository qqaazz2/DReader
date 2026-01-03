import 'dart:convert';
import 'dart:io';

import 'package:DReader/widgets/SideNotice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/entity/BaseListResult.dart';
import 'package:DReader/main.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/widgets/SetBaseUrl.dart';

class HttpApi {
  static final BaseOptions options = BaseOptions(
      baseUrl:kIsWeb ? "/api" : "${Global.setting.serverConfig.baseUrl}/api",
      // baseUrl: 'http://127.0.0.1:8081/',
      method: 'GET',
      connectTimeout: const Duration(seconds: 3),
      // 设置连接超时时间为 5 秒
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        if (status != null) return status < 500;
        return false;
      });

  static Dio dio = _createDio();

  static Dio _createDio() {
    return Dio(options);
  }

  static void updateDio() {
    options.baseUrl = kIsWeb ? "/api" : "${Global.setting.serverConfig.baseUrl}/api";
    dio = _createDio();
  }

  static Future request<T>(
    String url,
    Function fromJson, {
    String method = "get",
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
    bool isLoading = false,
    bool successMsg = false,
    bool isList = false,
    FormData? formData,
  }) async {
    if(options.baseUrl.isEmpty)  SideNoticeOverlay.error(text: "请先设置服务端地址");
    if (Global.token.isNotEmpty) {
      headers ??= {};
      headers["Authorization"] = "Bearer ${Global.token}";
    }

    final optionsData =
        Options(method: method, headers: headers, responseType: responseType);
    Interceptor inter = InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (e, handler) {
        if (e.statusCode == 401) {
          GoRouter.of(MyApp.rootNavigatorKey.currentContext!).go("/login");
          _handleHttpError(401);
          EasyLoading.dismiss();
          return;
        }
        return handler.next(e);
      },
      onError: (e, handler) {
        return handler.next(e);
      },
    );

    List<Interceptor> inters = [];
    inters.add(inter); //添加自定义拦截器
    // inters.add(LogInterceptor()); //添加内置拦截器
    if (isLoading) EasyLoading.show(status: 'loading...');
    dio.interceptors.addAll(inters);
    // 3 发起网络请求
    try {
      late Response response;
      if (method == "get") {
        response = await dio.request(
          url,
          options: optionsData,
          queryParameters: params,
        );
      } else {
        response = await dio.request(
          url,
          options: optionsData,
          data: formData ?? params,
        );
      }
      if (isLoading) EasyLoading.dismiss();
      if (response.statusCode == 200) {
        if (response.requestOptions.responseType == ResponseType.bytes) {
          EasyLoading.dismiss();
          return response.data;
        }
        if (response.data["code"] == "2000") {
          if (!isList) {
            BaseResult<T> result =
                BaseResult<T>.fromJson(response.data, (json) => fromJson(json));
            if (successMsg) SideNoticeOverlay.success(text: result.message);
            return result;
          } else {
            BaseListResult<T> result = BaseListResult<T>.fromJson(
                response.data, (json) => fromJson(json));
            if (successMsg) SideNoticeOverlay.success(text: result.message);
            return result;
          }
        } else {
          BaseResult result = BaseResult.fromJson(response.data, (json) => {});
          SideNoticeOverlay.error(text: result.message);
          return result;
        }
      } else {
        _handleHttpError(response.statusCode!);
      }
    } catch (e) {
      SideNoticeOverlay.error(text: e.toString());
      return Future.error(e);
    }
  }

  // 处理 Http 错误码
  static void _handleHttpError(int errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    SideNoticeOverlay.error(text: message);
  }
}
