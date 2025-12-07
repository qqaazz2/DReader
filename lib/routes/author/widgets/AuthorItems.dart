import 'dart:io';

import 'package:DReader/entity/author/AuthorItem.dart';
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
import 'package:DReader/routes/book/FilesForm.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';

class AuthorItems extends ListItem<AuthorItem> {
  const AuthorItems({
    super.key,
    required super.data,
    required super.index,
    required super.show,
    required super.isPc,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AuthorItemsState();
}

class AuthorItemsState extends ConsumerState<AuthorItems> {
  Map<String, String> map = {"Authorization": "Bearer ${Global.token}"};

  final over = ["连载中", "完结", "弃坑"];

  final status = [Colors.redAccent, Colors.transparent, Colors.amberAccent];

  @override
  Widget build(BuildContext context) {
    AuthorItem data = widget.data;
    return GestureDetector(
      child: Stack(
        children: [
          ClipOval(
            child: AspectRatio(
              aspectRatio: 1,
              child: ImageModule.getImage(data.avatar,fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black45,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                data.name,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      onTap: () => context.go("/author/content?id=${data.id}"),
    );
  }
}
