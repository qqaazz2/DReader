import 'dart:io';

import 'package:DReader/state/book/FilesDetailsItemState.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/routes/book/FilesForm.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';

import 'BookCoverChange.dart';

class FilesItems extends ListItem<FilesItem> {
  const FilesItems({
    super.key,
    required super.data,
    required super.index,
    required super.show,
    required super.isPc,
    required this.parentId,
  });
  final int parentId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FilesItemsState();
}

class FilesItemsState extends ConsumerState<FilesItems> {
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  final over = ["连载中", "完结", "弃坑"];

  final status = [Colors.redAccent, Colors.transparent, Colors.amberAccent];

  @override
  Widget build(BuildContext context) {
    FilesItem data = widget.data;
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
                  ImageModule.getImage(data.cover),
                  Positioned(
                    left: 5,
                    top: 5,
                    child: Icon(
                      data.isFolder == 1
                          ? Icons.folder_rounded
                          : Icons.book_rounded,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Badge(
                      smallSize: 10,
                      backgroundColor: status[data.status - 1],
                    ),
                  ),
                  if (data.isFolder == 1)
                    Positioned(
                      left: 5,
                      bottom: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          over[data.overStatus - 1],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            return IconButton(
                              iconSize: 23,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                              icon: const Icon(Icons.more_vert_rounded),
                              onPressed: () => showPopover(
                                context: context,
                                bodyBuilder: (context) => PopoverItemList(
                                  isFolder: data.isFolder,
                                  onChangeCover: changeCover,
                                  onEdit: editForm,
                                  onSetSeriesCover: setSeriesCover,
                                ),
                                onPop: () => print('Popover was popped!'),
                                direction: PopoverDirection.right,
                                constraints: const BoxConstraints(
                                  maxWidth: 160,
                                  maxHeight: 150,
                                  minWidth: 160,
                                ),
                                arrowHeight: 10,
                                arrowWidth: 20,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 23,
                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),
                          onPressed: () => ref
                              .read(
                                filesListStateProvider(widget.parentId).notifier,
                              )
                              .setLove(widget.index),
                          icon: Icon(
                            data.love == 1
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
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
      onTap: () {
        if (data.isFolder == 1) {
          context.push("/books/content?", extra: data);
        } else {
          context.push("/read?", extra: data);
        }
      },
    );
  }

  void changeCover() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 20,
              bottom: 20,
              right: 20,
            ),
            child: BookCoverChange(filesItem: widget.data, index: widget.index),
          ),
        );
      },
    );
  }

  void editForm() {
    showDialog(
      context: context,
      builder: (context) {
        return FilesForm(filesId: widget.data.filesId,);
      },
    );
  }

  void setSeriesCover() => ref.read(filesDetailsItemStateProvider(widget.data.parentId).notifier).updateCover(widget.data.id);
}

class PopoverItemList extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onChangeCover;
  final VoidCallback? onSetSeriesCover;
  final int isFolder;

  const PopoverItemList({
    super.key,
    required this.isFolder,
    this.onEdit,
    this.onChangeCover,
    this.onSetSeriesCover,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildItem(
          context,
          icon: Icons.edit_note_sharp,
          title: "编辑文件数据",
          onTap: onEdit,
        ),
        if (isFolder == 2)
          _buildItem(
            context,
            icon: Icons.image_search,
            title: "更换书籍封面",
            onTap: onChangeCover,
          ),
        if (isFolder == 2)
          _buildItem(
            context,
            icon: Icons.image,
            title: "设为系列封面",
            onTap: onSetSeriesCover,
          ),
      ],
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        size: 22,
        color: Theme.of(context).colorScheme.surfaceTint,
      ),
      visualDensity: const VisualDensity(vertical: -2),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surfaceTint,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }
}
