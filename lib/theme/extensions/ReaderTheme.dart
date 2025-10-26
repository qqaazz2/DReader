import 'package:flutter/material.dart';
import 'dart:convert';

class ReaderTheme extends ThemeExtension<ReaderTheme> {
  bool followThemeColor;
  Color? backgroundColor;
  Color? textColor;
  int textSize;
  double? lineMargin;
  bool useLineSpacing;
  bool useLinePreset;

  ReaderTheme({
    this.followThemeColor = true,
    this.backgroundColor = Colors.purple,
    this.textColor = Colors.white,
    this.textSize = 16,
    this.lineMargin,
    this.useLineSpacing = false,
    this.useLinePreset = true,
  });

  @override
  ThemeExtension<ReaderTheme> copyWith({
    bool? followThemeColor,
    Color? backgroundColor,
    Color? textColor,
    int? textSize,
    double? lineMargin,
    bool? useLineSpacing,
    bool? useLinePreset,
  }) {
    return ReaderTheme(
      followThemeColor: followThemeColor ?? this.followThemeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
      lineMargin: lineMargin ?? this.lineMargin,
      useLineSpacing: useLineSpacing ?? this.useLineSpacing,
      useLinePreset: useLinePreset ?? this.useLinePreset,
    );
  }

  ReaderTheme copy({
    bool? followThemeColor,
    Color? backgroundColor,
    Color? textColor,
    int? textSize,
    double? lineMargin,
    bool? useLineSpacing,
    bool? useLinePreset,
  }) {
    return ReaderTheme(
      followThemeColor: followThemeColor ?? this.followThemeColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
      lineMargin: lineMargin ?? this.lineMargin,
      useLineSpacing: useLineSpacing ?? this.useLineSpacing,
      useLinePreset: useLinePreset ?? this.useLinePreset,
    );
  }

  @override
  ReaderTheme lerp(ThemeExtension<ReaderTheme>? other, double t) {
    if (other is! ReaderTheme) return this;
    return ReaderTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
    );
  }

  String toJson() {
    return json.encode({
      "followThemeColor": followThemeColor,
      "backgroundColor": backgroundColor?.toARGB32(),
      "textColor": textColor?.toARGB32(),
      "textSize": textSize,
      "lineMargin": lineMargin,
      "useLineSpacing": useLineSpacing,
      "useLinePreset": useLinePreset,
    });
  }

  // 从 JSON 字符串创建 ServerConfig 对象
  factory ReaderTheme.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return ReaderTheme(
      followThemeColor: jsonMap['followThemeColor'],
      backgroundColor: Color(jsonMap['backgroundColor']),
      textColor: Color(jsonMap['textColor']),
      textSize: jsonMap['textSize'],
      lineMargin: jsonMap['lineMargin'],
      useLineSpacing: jsonMap['useLineSpacing'],
      useLinePreset: jsonMap['useLinePreset'],
    );
  }

  @override
  int get hashCode =>
      Object.hash(
          followThemeColor,
          backgroundColor,
          textColor,
          textSize,
          lineMargin,
          useLineSpacing,
          useLinePreset);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ReaderTheme && runtimeType == other.runtimeType &&
            textColor == other.textColor && textSize == other.textSize &&
            lineMargin == other.lineMargin &&
            useLineSpacing == other.useLineSpacing &&
            useLinePreset == other.useLinePreset;
  }
}
