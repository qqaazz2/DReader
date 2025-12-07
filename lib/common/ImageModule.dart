import 'dart:convert';
import 'dart:math';

import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/state/UserInfoState.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'Global.dart';
import 'HttpApi.dart';

class ImageModule {
  static String splicingPath(String filePath, bool baseUrl) {
    if (baseUrl) filePath = "${HttpApi.options.baseUrl}$filePath";
    String modifiedString = filePath.replaceFirst('\\', '');
    modifiedString = modifiedString.replaceAll('\\', '/');
    return modifiedString;
  }

  static Widget getImage(
    String? objName, {
    fit = BoxFit.contain,
    isMemCache = true,
  }) {
    return _RetryingCachedImage(path: objName, fit: fit, isCache: isMemCache);
  }
}

class _RetryingCachedImage extends ConsumerStatefulWidget {
  final String? path;
  final BoxFit fit;
  final bool isCache;

  const _RetryingCachedImage({
    required this.path,
    required this.fit,
    this.isCache = true,
  });

  @override
  ConsumerState<_RetryingCachedImage> createState() =>
      _RetryingCachedImageState();
}

class _RetryingCachedImageState extends ConsumerState<_RetryingCachedImage> {
  int retryCount = 0;
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};
  String? currentPath;
  bool firstLoading = true;

  void _handleError(String objName) async {
    if (retryCount >= 3) return;
    final delay = Duration(milliseconds: 1000 * pow(2, retryCount).toInt());
    await Future.delayed(delay);
    String? newPath = await getImageUrl();
    retryCount++;
    if (newPath != null && mounted) {
      setState(() {
        currentPath = newPath; // 使用新的地址重试
      });
    }
  }

  Future<void> loadInitial() async {
    retryCount = 0;
    firstLoading = true;
    if (mounted) setState(() {});
    final newPath = await getImageUrl();
    if (!mounted) return;
    setState(() {
      currentPath = newPath;
      firstLoading = false;
    });
  }

  Future<String?> getImageUrl() async {
    String? newPath;
    BaseResult baseResult = await HttpApi.request(
      "/image/getObject",
      (json) => json,
      params: {"objectName": widget.path},
    );
    if (baseResult.code == "2000") newPath = baseResult.result;
    return newPath;
  }

  @override
  void initState() {
    super.initState();
    loadInitial();
  }

  @override
  void didUpdateWidget(_RetryingCachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      loadInitial();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userInfoStateProvider, (p, n) {
      if (p?.fileAdapter == n?.fileAdapter) return;
      loadInitial();
    });

    if (firstLoading) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (currentPath == null) {
      return Image.asset("images/img.png", fit: widget.fit);
    }

    if (!widget.isCache)
      return _getWidget(double.infinity, double.infinity, null);

    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        final dpr = MediaQuery.of(context).devicePixelRatio;
        int cacheWidth = (constraints.maxWidth * dpr).toInt();
        cacheWidth = _getImageCacheSize(cacheWidth);
        return _getWidget(
          constraints.maxWidth,
          constraints.maxHeight,
          cacheWidth,
        );
      },
    );
  }

  Widget _getWidget(double width, double height, int? cacheWidth) {
    return CachedNetworkImage(
      width: width,
      height: height,
      memCacheWidth: cacheWidth,
      imageUrl: currentPath!,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(value: downloadProgress.progress),
        ),
      ),
      errorWidget: (context, url, error) {
        CachedNetworkImage.evictFromCache(url);
        _handleError(url);
        if (retryCount >= 3) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey,
            child: const Icon(Icons.broken_image, size: 80),
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
              Text("第${retryCount + 1}次重试"),
            ],
          ),
        );
      },
      fit: widget.fit,
    );
  }

int _getImageCacheSize(int width) {
  if (width < 0) return 0;
  return switch (width) {
    <= 150 => 150,
    <= 200 => 200,
    <= 300 => 300,
    <= 400 => 400,
    <= 500 => 500,
    <= 600 => 600,
    <= 700 => 700,
    <= 800 => 800,
    <= 900 => 900,
    <= 1000 => 1000,
    <= 2000 => 2000,
    _ => 3000,
  };
}
}
