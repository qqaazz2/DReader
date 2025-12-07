import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/state/author/AuthorDetailState.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'AuthorForm.dart';

class AuthorDetailPcCard extends ConsumerStatefulWidget {
  const AuthorDetailPcCard({super.key, required this.id});

  final int id;

  @override
  ConsumerState<AuthorDetailPcCard> createState() => AuthorDetailPcCardState();
}

class AuthorDetailPcCardState extends ConsumerState<AuthorDetailPcCard> {
  // Future<AuthorDetail?> getDetail() async {
  //   BaseResult<AuthorDetail> baseResult = await HttpApi.request<AuthorDetail>(
  //     "/author/getAuthorDetail",
  //         (json) => AuthorDetail.fromJson(json),
  //     params: {"id": widget.id},
  //   );
  //   if (baseResult.code == "2000") {
  //     return baseResult.result;
  //   }
  //   return null;
  // }
  //

  @override
  Widget build(BuildContext context) {
    AsyncValue<AuthorDetail?> asyncValue = ref.watch(
      authorDetailStateProvider(widget.id),
    );
    return Card(
      child: asyncValue.when(
        data: (AuthorDetail? detail) {
          if (detail == null)
            return Center(
              child: Text('数据加载失败', style: const TextStyle(color: Colors.red)),
            );
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ImageModule.getImage(
                            detail.avatar,
                            isMemCache: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        detail.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person_3),
                        title: const Text("职业"),
                        trailing: Text(detail.vocational ?? "无数据"),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_month),
                        title: const Text("出生年份"),
                        trailing: Text(detail.date ?? "无数据"),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.numbers),
                        title: const Text("BGM-ID"),
                        trailing: Text("${detail.bgmId}" ?? "无数据"),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.menu_book),
                        title: Text("简介"),
                      ),
                      Text(detail.profile ?? "暂无简介"),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AuthorForm(authorDetail: detail),
                  ),
                  icon: const Icon(Icons.edit_note),
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
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
