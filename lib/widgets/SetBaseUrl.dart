import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/entity/ServerConfig.dart';
import 'package:DReader/state/ThemeState.dart';

class SetBaseUrl extends StatefulWidget {
  @override
  State<SetBaseUrl> createState() => SetBaseUrlState();
}

class SetBaseUrlState extends State<SetBaseUrl> {
  String baseUrl = "";
  ServerConfig serverConfig = ServerConfig();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("设置"),
      children: [
        Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                    decoration: const InputDecoration(
                        labelText: "服务器地址",
                        hintText: "请输入服务器地址",
                        prefixText: "http://",
                        prefixIcon: Icon(
                          Icons.laptop_outlined,
                          size: 18,
                        )),
                    initialValue: Global.setting.serverConfig.baseUrl
                        .replaceAll("http://", ""),
                    onSaved: (value) => serverConfig.baseUrl = "http://$value",
                    validator: (value) {
                      if (value!.trim().isEmpty) return "服务器地址不可为空";
                      return null;
                    }),
                Consumer(builder: (context, ref, child) {
                  return Builder(builder: (context) {
                    return ElevatedButton.icon(
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
                      label: const Text("提交"),
                      icon: const Icon(Icons.save_as),
                    );
                  });
                })
              ],
            ),
          ),
        )
      ],
    );
  }
}
