import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/state/author/AuthorDetailState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'AuthorBookPcList.dart';
import 'AuthorForm.dart';

class AuthorDetailMobile extends ConsumerStatefulWidget {
  const AuthorDetailMobile({super.key, required this.id});

  final int id;

  @override
  ConsumerState<AuthorDetailMobile> createState() => AuthorDetailMobileState();
}

class AuthorDetailMobileState extends ConsumerState<AuthorDetailMobile> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<AuthorDetail?> asyncValue = ref.watch(
      authorDetailStateProvider(widget.id),
    );
    return asyncValue.when(
      data: (AuthorDetail? authorDetail) {
        if (authorDetail == null) {
          return const Center(
            child: Column(children: [Icon(Icons.error), Text("数据加载失败")]),
          );
        }
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                stretch: true,
                centerTitle: true,
                expandedHeight: MediaQuery.of(context).size.width,
                actions: [
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          AuthorForm(authorDetail: authorDetail),
                    ),
                    icon: const Icon(Icons.edit_note),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  expandedTitleScale: 1,
                  title: Text(authorDetail!.name),
                  background: AspectRatio(
                    aspectRatio: 1,
                    child: ImageModule.getImage(
                      authorDetail!.avatar,
                      isMemCache: true,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          leading: const Icon(Icons.person_3, size: 20),
                          horizontalTitleGap: 5,
                          title: const Text(
                            "职业",
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text(authorDetail!.vocational ?? "无数据"),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          horizontalTitleGap: 5,
                          leading: const Icon(Icons.calendar_month, size: 20),
                          title: const Text(
                            "出生年份",
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text(authorDetail!.date ?? "无数据"),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          horizontalTitleGap: 5,
                          leading: const Icon(Icons.numbers, size: 20),
                          title: const Text(
                            "BGM-ID",
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Text("${authorDetail!.bgmId}"),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          horizontalTitleGap: 5,
                          leading: const Icon(Icons.menu_book, size: 20),
                          title: const Text(
                            "简介",
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: TextButton(
                            onPressed: () => show(),
                            child: Text("点击查看"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: AuthorBookPcList(id: widget.id),
        );
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.only(bottom: 10),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ImageModule.getImage(authorDetail!.avatar),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        authorDetail!.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text(
            '加载失败: $error',
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () {
        return const Center(
          child: Column(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(),
              ),
              Text("加载中"),
            ],
          ),
        );
      },
    );
  }

  void show() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Card(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    child: Text(
                      ref
                              .read(authorDetailStateProvider(widget.id))
                              .value
                              ?.profile ??
                          "暂无简介",
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("关闭"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
