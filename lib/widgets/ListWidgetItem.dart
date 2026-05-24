import 'package:DReader/state/common/ListWidgetCheckState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

import 'ListWidget.dart';

class ListWidgetItem<T> extends ConsumerWidget {
  final int index;
  final ListItem<T> Function(T data, int index) widget;
  final T data;
  final bool showCheckBox;
  final String? nodeKey;

  const ListWidgetItem({
    super.key,
    required this.index,
    required this.widget,
    required this.data,
    required this.showCheckBox,
    this.nodeKey
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isCheck = false;
    if(showCheckBox) isCheck = ref.watch(listWidgetCheckStateProvider(nodeKey!).select((set) => set.contains(index)));
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: widget(data, index),
        ),
        if (showCheckBox)
          Positioned(
            child: Container(
              color: Theme.of(context).cardColor.withAlpha(100),
              child: Center(
                child: Transform.scale(
                  scale: 1.4,
                  child: Checkbox(
                    shape: const CircleBorder(),
                    value: isCheck,
                    onChanged: (v) => ref.read(listWidgetCheckStateProvider(nodeKey!).notifier).toggle(index),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
