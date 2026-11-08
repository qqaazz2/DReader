import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/FilesDownload.dart';
import 'package:flutter/material.dart';

class DownloadItem extends StatelessWidget {
  const DownloadItem({super.key, required this.filesDownload});

  final FilesDownload filesDownload;
  static const Map<int, String> status = {
    1: "正在下载",
    2: "下载完成",
    3: "等待下载",
    4: "下载失败",
    5: "文件删除",
  };

  Color getStatusColor(BuildContext context) {
    switch (filesDownload.status) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Theme.of(context).colorScheme.secondary;
      case 4:
        return Colors.red;
      default:
        return Colors.deepOrange;
    }
  }

  IconData getStatusIcon() {
    switch (filesDownload.status) {
      case 1:
        return Icons.downloading_rounded;
      case 2:
        return Icons.check_circle_outline_rounded;
      case 3:
        return Icons.schedule_rounded;
      case 4:
        return Icons.error_outline_rounded;
      default:
        return Icons.delete;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 76,
              child: ImageModule.getImage(filesDownload.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  filesDownload.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Icon(getStatusIcon(), size: 16, color: color),
                    const SizedBox(width: 5),
                    Text(
                      status[filesDownload.status] ?? "未知状态",
                      style: TextStyle(fontSize: 12, color: color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
