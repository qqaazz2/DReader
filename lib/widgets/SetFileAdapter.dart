import 'dart:convert';

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/state/UserInfoState.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/entity/ServerConfig.dart';
import 'package:DReader/state/ThemeState.dart';

class SetFileAdapter extends ConsumerStatefulWidget {
  const SetFileAdapter({super.key});

  @override
  ConsumerState<SetFileAdapter> createState() => SetFileAdapterState();
}

class SetFileAdapterState extends ConsumerState<SetFileAdapter> {
  List<String>? list;
  bool isLoading = true;
  late String adapter;

  @override
  void initState() {
    super.initState();
    getData();
    final userInfo = ref.read(userInfoStateProvider);
    adapter = jsonDecode(jsonEncode(userInfo!.fileAdapter));
  }

  void getData() async {
    BaseResult<List<String>> baseResult = await HttpApi.request<List<String>>(
      "/image/getAdapterList",
      (json) => List<String>.from(json),
    );
    if (baseResult.code == "2000") {
      list = baseResult.result;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("设置"),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 300,
          height: 100,
          child: getWidget(),
        ),
        Container(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(userInfoStateProvider.notifier)
                  .changeFileAdapter(adapter: adapter);
              Navigator.of(context).pop();
            },
            child: const Text("提交"),
          ),
        ),
      ],
    );
  }

  Widget getWidget() {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (list == null || list!.isEmpty) {
      return const Center(child: Text("暂无文件适配器可选择"));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: list!
          .map(
            (item) => RawChip(
              label: Text(item),
              selected: adapter == item,
              onPressed: () => setState(() => adapter = item),
            ),
          )
          .toList(),
    );
  }
}
