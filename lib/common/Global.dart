import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:DReader/entity/ServerConfig.dart';
import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/widgets/LeftDrawer.dart';
import 'package:DReader/widgets/SetBaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HttpApi.dart';

class Global {
  static late String token;
  static late SharedPreferences preferences;
  static List<Item> itemList = [

  ];
  static const String _serverConfig = "serverConfig";
  static late Setting setting;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token") ?? "";
    bool light = false;
    bool? getLight = preferences.getBool("light");
    if (getLight == null) {
      preferences.setBool("light", light);
    } else {
      light = getLight;
    }

    late ServerConfig serverConfig;
    String? serverConfigStr = preferences.getString(_serverConfig);
    if (serverConfigStr == null) {
      serverConfig = ServerConfig();
    } else {
      serverConfig = ServerConfig.fromJson(serverConfigStr);
    }

    String? musicInfoParamsStr = preferences.getString("musicInfoParams");
    if (musicInfoParamsStr != null) {
      // musicInfoParams = MusicInfoParams.fromJson(json.decode(musicInfoParamsStr));
    }

    setting = Setting(serverConfig: serverConfig, light: light);

    itemList.add(Item(title: "首页", path: "/home", icon: const Icon(Icons.home)));
    itemList.add(Item(title: "图书", path: "/books", icon: const Icon(Icons.menu_book)));
    itemList.add(Item(title: "日志", path: "/logs", icon: const Icon(Icons.analytics)));
    itemList.add(Item(title: "设置", path: "/setting", icon: const Icon(Icons.settings)));
  }

  static saveLoginStatus(String token, UserInfo userInfo) {
    Global.token = token;
    preferences.setString("token", token);

    setUserInfo(userInfo);
  }

  static setUserInfo(UserInfo userInfo) {
    Global.setting.userInfo = userInfo;
  }

  static logout(BuildContext context) {
    preferences.remove("token");
    GoRouter.of(context).go("/login");
  }

  static setServerConfig(ServerConfig config) {
    preferences.setString(_serverConfig, config.toJson());
    Global.setting.serverConfig = config;
    HttpApi.updateDio();
  }

  static showSetBaseUrlDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SetBaseUrl();
        });
  }

  static setMystery(mystery) {
    setting.userInfo!.mystery = mystery;
  }

  static setLight() {
    setting.light = !setting.light;
    preferences.setBool("light", setting.light);
  }
}

class Setting {
  ServerConfig serverConfig;
  bool light = false;
  UserInfo? userInfo;

  Setting({
    required this.serverConfig,
    this.light = false,
    this.userInfo,
  });

  Setting copyWith(
      {ServerConfig? serverConfig,
      bool? light,
      UserInfo? userInfo}) {
    return Setting(
        serverConfig: serverConfig ?? this.serverConfig,
        light: light ?? this.light,
        userInfo: userInfo ?? this.userInfo);
  }
}
