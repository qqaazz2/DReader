import 'dart:convert';
import 'dart:math';

import 'package:DReader/entity/BaseResult.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'Global.dart';
import 'HttpApi.dart';

class ImageModule {

  static String splicingPath(String filePath, bool baseUrl) {
    if (baseUrl) filePath = "${HttpApi.options.baseUrl}$filePath";
    String modifiedString = filePath.replaceFirst('\\', '');
    modifiedString = modifiedString.replaceAll('\\', '/');
    return modifiedString;
  }

  static Widget minioImage(String? path, String? objName,
      {fit = BoxFit.contain}) {
    Future<String?> callback(String url) async {
      if(objName == null) return objName;
      BaseResult baseResult = await HttpApi.request(
          "/minio/getObject", (json) => json, params: {
        "objectName": objName,
      });
      if (baseResult.code == "2000") return baseResult.result;
      return null;
    }

    return imageModule(path, fit: fit, baseUrl: false, errorCallback: callback);
  }

  static Widget imageModule(String? path,
      {fit = BoxFit.contain, baseUrl = true, Future<
          String?> Function(String)? errorCallback}) {
    if (path == null) return Image.asset("images/img.png", fit: fit);
    path = splicingPath(path, baseUrl);
    return _RetryingCachedImage(
      path: path, fit: fit, baseUrl: baseUrl, errorCallback: errorCallback,);
    // }
  }
}

class _RetryingCachedImage extends StatefulWidget {
  final Future<String?> Function(String)? errorCallback;
  final String path;
  final bool baseUrl;
  final BoxFit fit;

  const _RetryingCachedImage(
      {required this.path, required this.fit, required this.baseUrl, this.errorCallback});


  @override
  State<StatefulWidget> createState() => _RetryingCachedImageState();
}

class _RetryingCachedImageState extends State<_RetryingCachedImage> {
  int retryCount = 0;
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};
  String? currentPath;

  void _handleError(String url) async {
    if (widget.errorCallback != null && retryCount < 3) {
      retryCount++;
      final newPath = await widget.errorCallback!(url);
      if (newPath != null && mounted) {
        setState(() {
          currentPath = newPath; // 使用新的地址重试
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: double.infinity,
      height: double.infinity,
      imageUrl: currentPath ?? widget.path,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      httpHeaders: widget.baseUrl ? map : {},
      errorWidget: (context, url, error) {
        CachedNetworkImage.evictFromCache(url);
        _handleError(url);
        if (widget.errorCallback == null || retryCount == 3) {
          return Image.asset("images/img.png", fit: widget.fit);
        }
        return Column(children: [
          const CircularProgressIndicator(),
          Text("第${retryCount + 1}次重试")
        ],);
      },
      fit: widget.fit,
    );
  }
}
