
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/entity/ServerConfig.dart';
import 'package:DReader/state/ThemeState.dart';

class SetBaseUrl extends StatefulWidget {
  const SetBaseUrl({super.key});

  @override
  State<SetBaseUrl> createState() => SetBaseUrlState();
}

class SetBaseUrlState extends State<SetBaseUrl> {
  String baseUrl = "";
  ServerConfig serverConfig = ServerConfig();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleDialog(
      title: const Row(
        children: [
          Text("服务器设置"),
        ],
      ),
      children: [
        Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "服务器地址",
                    hintText: "例如 192.168.1.100:8080",
                    prefixText: "http://",
                    prefixIcon: Icon(Icons.dns_outlined),
                    border: OutlineInputBorder(),
                  ),
                  initialValue: Global.setting.serverConfig.baseUrl
                      .replaceAll("http://", ""),
                  onSaved: (value) =>
                  serverConfig.baseUrl = "http://$value",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "服务器地址不可为空";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Consumer(
                  builder: (context, ref, child) {
                    return Builder(
                      builder: (context) {
                        return FilledButton.icon(
                          onPressed: () {
                            bool status = Form.of(context).validate();
                            if (status) {
                              Form.of(context).save();
                              ref
                                  .read(themeStateProvider.notifier)
                                  .changeServerConfig(serverConfig);
                              Navigator.of(context).pop();
                            }
                          },
                          label: const Text("保存设置"),
                          icon: const Icon(Icons.save_outlined),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
