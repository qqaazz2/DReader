import 'package:DReader/entity/book/FilesDownload.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/book/FilesDownloadState.dart';
import 'package:DReader/widgets/Download/DownloadItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DownloadPanel extends ConsumerStatefulWidget {
  const DownloadPanel({super.key});

  @override
  ConsumerState<DownloadPanel> createState() => DownloadPanelState();
}

class DownloadPanelState extends ConsumerState<DownloadPanel> {
  @override
  Widget build(BuildContext context) {
    List<FilesDownload> list = ref.watch(filesDownloadStateProvider);
    return SimpleDialog(
      title: const Text("缓存任务"),
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: list.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    FilesDownload filesDownload = list[index];
                    return GestureDetector(
                      child: DownloadItem(filesDownload: filesDownload),
                      onTap: () => onTap(filesDownload, index),
                    );
                  },
                  itemCount: list.length,
                )
              : const Center(child: Text("暂无缓存任务")),
        ),
      ],
    );
  }

  void onTap(FilesDownload item, int index) {
    if (item.status == 4 || item.status == 5) ref.read(filesDownloadStateProvider.notifier).reDownload(index);
  }
}
