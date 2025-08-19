import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'Global.dart';
import 'HttpApi.dart';

class ImageModule {
  static Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  static String splicingPath(String filePath, bool baseUrl) {
    if (baseUrl) filePath = "${HttpApi.options.baseUrl}$filePath";
    String modifiedString = filePath.replaceFirst('\\', '');
    modifiedString = modifiedString.replaceAll('\\', '/');
    return modifiedString;
  }

  static Widget minioImage(String? path,{fit = BoxFit.contain}){
    return imageModule(path,fit: fit,baseUrl: false);
  }

  static Widget imageModule(String? path,
      {fit = BoxFit.contain, baseUrl = true}) {
    // if(kIsWeb){
    //   return Image.network(path,width: double.infinity,height: double.infinity,headers: map,errorBuilder:(context,object,stackTrace) => Image.asset("images/1.png"));
    // }else{
    if (path == null) return Image.asset("images/img.png", fit: fit);
    path = splicingPath(path,baseUrl);
    return CachedNetworkImage(
      width: double.infinity,
      height: double.infinity,
      imageUrl: path,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      httpHeaders: baseUrl ? map : {},
      errorWidget: (context, url, error) {
        CachedNetworkImage.evictFromCache(url);
        return Image.asset("images/img.png", fit: fit);
      },
      fit: fit,
    );
    // }
  }

  // static Future<void> removeFile(String? path, {String? cacheKey}) async {
  //   final String url = splicingPath(path,);
  //   return CachedNetworkImage.evictFromCache(url, cacheKey: cacheKey)
  //       .then((value) {
  //     CachedNetworkImageProvider(url, cacheKey: cacheKey)
  //         .obtainKey(const ImageConfiguration())
  //         .then((key) {
  //       PaintingBinding.instance.imageCache.evict(key);
  //     });
  //   });
  // }
}
