import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/Global.dart';
import '../state/ThemeState.dart';

class SettingsBar extends StatelessWidget {
  const SettingsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(themeStateProvider);
      return Padding(
          padding: const EdgeInsets.all(0),
          child: Wrap(
            children: [
              IconButton(
                  onPressed: () =>
                      ref.read(themeStateProvider.notifier).changeTheme(),
                  icon:
                      Icon(state.light ? Icons.sunny : Icons.nightlight_round)),
              IconButton(
                  onPressed: () => Global.showSetBaseUrlDialog(context),
                  icon: const Icon(Icons.link_outlined)),
              // IconButton(onPressed: () => Global.logout(context), icon: const Icon(Icons.logout))
            ],
          ));
    });
  }
}
