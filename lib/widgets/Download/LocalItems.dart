import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/BookExtra.dart';
import 'package:DReader/entity/book/FilesDownload.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/ReadRecord.dart';
import 'package:DReader/state/LocalState.dart';
import 'package:DReader/state/book/FilesDownloadState.dart';
import 'package:DReader/widgets/Download/DownloadItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/core.dart';
import 'package:go_router/go_router.dart';

import '../ListWidget.dart';

class LocalItems extends ListItem<FilesDownload> {
  const LocalItems({super.key, required super.data, required super.index});

  @override
  ConsumerState<LocalItems> createState() => LocalItemsState();
}

class LocalItemsState extends ConsumerState<LocalItems> {
  final status = [Colors.redAccent, Colors.transparent, Colors.amberAccent];

  @override
  Widget build(BuildContext context) {
    // final String filePath =
    //     "${ref.read(filesDownloadStateProvider.notifier).bookDirectory.path}/${widget.data.hash}.epub";
    final String coverPath = "${ref.read(localStateProvider.notifier).coverDirectory.path}/${widget.data.hash}.jpg";
    FilesDownload data = widget.data;
    return GestureDetector(
      child: Card(
        color: Theme.of(context).cardColor.withAlpha(255),
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ImageModule.getLocalImage(coverPath),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Badge(
                      smallSize: 10,
                      backgroundColor: status[data.readStatus - 1],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(data.name, maxLines: 1),
            ),
          ],
        ),
      ),
      onTap: () => context.push("/read?", extra: BookExtra(filesItem: FilesItem(-1, 1, null, data.name, 1, data.readStatus, "", 2, "", "", data.hash),readRecord: ReadRecord(progress: data.progress, readTagNum: data.readTagNum),isLocal: true)),
    );
  }
}
