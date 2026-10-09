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
  List<String>? scraperList;
  bool isLoading = true;
  late String adapter;
  late String scraper;

  @override
  void initState() {
    super.initState();
    getData();
    final userInfo = ref.read(userInfoStateProvider);
    adapter = jsonDecode(jsonEncode(userInfo!.fileAdapter));
    scraper = jsonDecode(jsonEncode(userInfo.scraper));
  }

  void getData() async {
    try {
      BaseResult<List<String>> baseResult = await HttpApi.request<List<String>>(
        "/image/getAdapterList",
            (json) => List<String>.from(json),
      );
      if (baseResult.code == "2000") {
        list = baseResult.result;
      }

      BaseResult<List<String>> baseResult1 =
      await HttpApi.request<List<String>>(
        "/user/getScraper",
            (json) => List<String>.from(json),
      );
      if (baseResult.code == "2000") {
        scraperList = baseResult1.result;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("设置"),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 300,
          height: 250,
          child: getWidget(),
        ),
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(userInfoStateProvider.notifier)
                  .changeFileAdapter(adapter: adapter,scraper:scraper);
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdapterSection(
            title: '图片适配器',
            items: list,
            selected: adapter,
            onSelected: (value) {
              setState(() => adapter = value);
            },
          ),
          const SizedBox(height: 16),
          _buildAdapterSection(
            title: '刮削器',
            items: scraperList,
            selected: scraper,
            onSelected: (value) {
              setState(() => scraper = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdapterSection({
    required String title,
    required List<String>? items,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (items == null || items.isEmpty)
          const Text('暂无可选择项')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return RawChip(
                label: Text(item),
                selected: selected == item,
                onPressed: () => onSelected(item),
              );
            }).toList(),
          ),
      ],
    );
  }
}
