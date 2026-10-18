import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/book/FileScraperMatch.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:flutter/material.dart';

class UserSelectMatch extends StatefulWidget {
  const UserSelectMatch({super.key, required this.list});

  final List<FilesItem> list;

  @override
  State<UserSelectMatch> createState() => _UserSelectMatch();
}

class _UserSelectMatch extends State<UserSelectMatch> {
  late List<FileScraperMatch> list;

  @override
  void initState() {
    super.initState();
    list = widget.list
        .map((item) => FileScraperMatch(id: item.id, selectId: null))
        .toList();
  }
  void change(int id,String? selectId){
    final item = list.firstWhere((item)=>item.id==id);
    item.selectId = int.tryParse(selectId ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            width: constraint.maxWidth > MyApp.width
                ? 600
                : constraint.maxWidth - 20,
            height: constraint.maxWidth > MyApp.width
                ? 600
                : constraint.maxWidth - 50,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_fix_high),
                    const SizedBox(width: 8),
                    Text(
                      "系列信息刮削",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      "已选择系列数量：${list.length}",
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = widget.list[index];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 80,
                                height: 100,
                                child: ImageModule.getImage(item.cover),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 120,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "ID",
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (value) {
                                  change(item.id, value);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("取消"),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () async {
                        BaseResult base = await HttpApi.request(
                          "/files/scraperByIds",
                          (json) => json,
                          method: "post",
                          paramsList: list.map((item) => item.toJson()).toList(),
                          successMsg: true,
                        );
                        if (base.code == "2000") Navigator.pop(context);
                      },
                      child: const Text("提交"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
