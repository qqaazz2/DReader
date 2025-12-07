import 'package:DReader/theme/extensions/ReaderTheme.dart';
import 'package:flutter/material.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseListResult.dart';
import 'package:DReader/entity/ListData.dart';
import 'package:DReader/entity/ServerConfig.dart';
import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ThemeState.g.dart';

@riverpod
class ThemeState extends _$ThemeState {
  @override
  Setting build() {
    return Global.setting;
  }

  void changeTheme() {
    Global.setLight();
    state = state.copyWith(light: Global.setting.light);
  }

  void changeColor(Color color) {
    if (color == state.color) return;
    Global.setThemeColor(color);
    if (state.readerTheme.followThemeColor) {
      ReaderTheme readerTheme = Global.initReaderTheme(state.light, color);
      Global.setReaderTheme(readerTheme);
      state = state.copyWith(
          color: color,
          readerTheme: readerTheme);
    } else {
      state = state.copyWith(color: color);
    }
  }

  void changeServerConfig(ServerConfig config) {
    Global.setServerConfig(config);
    state = state.copyWith(serverConfig: config);
  }

  void changeReaderTheme(ReaderTheme theme) {
    Global.setReaderTheme(theme);
    state = state.copyWith(readerTheme: theme);
  }
}
