import 'package:DReader/state/book/FilesListState.dart';
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
        maxHeight: 100,
        minWidth: 180,
      ),
      arrowHeight: 10,
      arrowWidth: 20,
      bodyBuilder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: isCheck,
                      onChanged: (value) => setState(() => isCheck = value!),
                    ),
                    const Text("是否刮削数据"),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        ref.read(filesListStateProvider("-1").notifier)
                            .scanning(isScrape: isCheck);
                        Navigator.of(context).pop();
                      },
                      label: const Text("确认"),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
