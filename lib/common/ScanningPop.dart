import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/state/UserInfoState.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/SetProxy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:popover/popover.dart';

class ScanningPop {
  static final ScanningPop _instance = ScanningPop._();

  factory ScanningPop() => _instance;

  ScanningPop._();

  static showPop(BuildContext context, {direction = PopoverDirection.top}) {
    bool isCheck = true;
    showPopover(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      direction: direction,
      constraints: const BoxConstraints(
        maxWidth: 180,
        maxHeight: 315,
        minWidth: 180,
      ),
      arrowHeight: 10,
      arrowWidth: 20,
      bodyBuilder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            UserInfo? userInfo = ref.watch(userInfoStateProvider);

            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isCheck,
                            onChanged: (value) =>
                                setState(() => isCheck = value!),
                          ),
                          const Text("是否刮削数据"),
                        ],
                      ),
                      const Divider(height: 15),
                      const Text(
                        "代理设置",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text("代理状态"),
                        trailing: Text(
                          userInfo?.proxyEnabled == 1 ? "开启" : "关闭",
                          style: TextStyle(
                            color: userInfo?.proxyEnabled == 1
                                ? Colors.green
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text("代理地址"),
                        trailing: Text(userInfo?.proxyHost ?? ""),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text("代理端口"),
                        trailing: Text("${userInfo?.proxyPort ?? ""}"),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => const SetProxy(),
                          ),
                          child: const Text("设置代理"),
                        ),
                      ),
                      const Divider(height: 15),
                      const SizedBox(height: 4),
                      FilledButton(
                        onPressed: () {
                          ref
                              .read(filesListStateProvider("-1").notifier)
                              .scanning(isScrape: isCheck);
                          Navigator.of(context).pop();
                        },
                        child: const Text("确认"),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
