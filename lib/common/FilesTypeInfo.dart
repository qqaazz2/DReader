import 'package:flutter/material.dart';

// 创建封装类
class FilesTypeInfo {
  final int itemType;

  // 构造函数
  FilesTypeInfo(this.itemType);

  // 获取颜色（加透明效果）
  Color get color {
    switch (itemType) {
      case 0: // 缓存文件
        return Colors.grey[300]!.withOpacity(0.8);  // 浅灰色 + 80% 不透明度
      case 1: // 图书
        return Colors.blue[300]!.withOpacity(0.8);  // 浅蓝色 + 80% 不透明度
      case 2: // 漫画
        return Colors.orange[300]!.withOpacity(0.8);  // 浅橙色 + 80% 不透明度
      case 3: // 图片
        return Colors.green[300]!.withOpacity(0.8);  // 浅绿色 + 80% 不透明度
      default: // 未知类型
        return Colors.grey[300]!.withOpacity(0.8);  // 浅灰色 + 80% 不透明度
    }
  }

  // 获取文字
  String get text {
    switch (itemType) {
      case 0:
        return "缓存文件";
      case 1:
        return "图书";
      case 2:
        return "漫画";
      case 3:
        return "图片";
      default:
        return "未知类型";
    }
  }
}