import 'dart:ui';

import 'package:DReader/widgets/SideNotice.dart';
import 'package:csslib/parser.dart' as css_parser;
import 'package:csslib/visitor.dart' as css_parser;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DomRendering.dart';

class StyleMap {
  final Map<String, ModelStyle> tagStyles = {};
  final Map<String, ModelStyle> classStyles = {};
  final Map<String, ModelStyle> idStyles = {};
  final Map<String, ModelStyle> complexStyles = {};
  final List<String> importList = [];
}

class CssToTextstyle {
  static const double baseFontSize = 16;
  final Map<String, Color> cssColorKeywords = {
    'black': const Color(0xFF000000),
    'white': const Color(0xFFFFFFFF),
    'red': const Color(0xFFFF0000),
    'blue': const Color(0xFF0000FF),
    'green': const Color(0xFF008000),
    'gray': const Color(0xFF808080),
    'yellow': const Color(0xFFFFFF00),
    'orange': const Color(0xFFFFA500),
    'purple': const Color(0xFF800080),
    'pink': const Color(0xFFFFC0CB),
    'cyan': const Color(0xFF00FFFF),
    'magenta': const Color(0xFFFF00FF),
    'transparent': const Color(0x00000000),
  };

  String filterEmptyCssDeclarations(String css) {
    final regex = RegExp(r'[a-zA-Z0-9_-]+\s*:\s*;');
    return css.replaceAll(regex, '');
  }

  StyleMap parseCssToStyleMap(String css) {
    final styleMap = StyleMap();
    try {
      css = filterEmptyCssDeclarations(css);
      final sheet = css_parser.parse(css);
      final imports = sheet.topLevels.whereType<css_parser.ImportDirective>();
      for (var item in imports) {
        if (!item.import.contains("css")) continue;
        styleMap.importList.add(item.import);
      }

      for (final rule in sheet.topLevels.whereType<css_parser.RuleSet>()) {
        final declarations = rule.declarationGroup.declarations
            .whereType<css_parser.Declaration>()
            .toList();
        final modelStyle = parseCssDeclarationsToTextStyle(declarations);

        // 遍历规则中所有的选择器 (例如 "h1, .foo" 会有两个 selector)
        for (final selector in rule.selectorGroup!.selectors) {
          // 判断选择器是简单还是复杂
          final bool isSimpleSelector =
              selector.simpleSelectorSequences.length == 1;

          if (isSimpleSelector) {
            // --- 处理简单选择器 (如: "p", ".my-class", "#my-id") ---
            final simpleSelector =
                selector.simpleSelectorSequences.first.simpleSelector;
            final elementName = simpleSelector.name;

            // 使用您原来的逻辑来区分 tag, class, id
            if (simpleSelector.toString().contains(".")) {
              styleMap.classStyles[elementName] = modelStyle;
            } else if (simpleSelector.toString().contains("#")) {
              styleMap.idStyles[elementName] = modelStyle;
            } else if (elementName.isNotEmpty) {
              styleMap.tagStyles[elementName] = modelStyle;
            }
          } else {
            // --- 处理复杂选择器 (如: "sup img", "div > p") ---
            final fullSelectorText = selector.span?.text.trim();
            if (fullSelectorText != null) {
              styleMap.complexStyles[fullSelectorText] = modelStyle;
            }
          }
        }
      }
    } catch (e) {
      SideNoticeOverlay.error(text: "css文件解析错误");
    }
    return styleMap;
  }

  ModelStyle parseInlineStyle(String inlineStyle) {
    ModelStyle textStyle = ModelStyle();
    final sheet = css_parser.parse('* { $inlineStyle }');
    for (final rule in sheet.topLevels.whereType<css_parser.RuleSet>()) {
      final declarations = rule.declarationGroup.declarations
          .whereType<css_parser.Declaration>()
          .toList();
      textStyle = parseCssDeclarationsToTextStyle(declarations);
    }
    return textStyle;
  }

  ModelStyle parseCssDeclarationsToTextStyle(
      List<css_parser.Declaration> declarations) {
    double? marginTop, marginRight, marginBottom, marginLeft;
    double? paddingTop, paddingRight, paddingBottom, paddingLeft;
    double fontSize = baseFontSize;
    FontWeight? fontWeight;
    Color? color;
    double? lineHeight;
    String? rawLineHeight;
    TextAlign textAlign = TextAlign.start;
    List<Shadow> shadowList = [];
    double? width;
    double? height;
    BorderRadius? borderRadius;
    String? floatDirection;
    FontStyle? fontStyle;
    bool marginLeftAuto = false;
    bool marginRightAuto = false;
    for (var declaration in declarations) {
      final property = declaration.property;
      // final value = declaration.expression?.span?.text.trim();
      final raw = declaration.span?.text;
      final value =
          raw != null ? raw.split(":").last.trim().replaceAll(';', '') : null;

      // "padding" 1
      // "margin" 1
      // "line-height" 1
      // "text-align" 1
      // "font-weight" 1
      // "text-indent" 加入依赖indent https://bbs.itying.com/topic/6789e71524cdd5004b449251 延后
      // "display" 延后
      // "font-size" 1
      // "text-shadow" 1
      //border 延后
      //float 1
      //transform 延后
      //border-radius 1
      if (property.startsWith('margin')) {
        switch (property) {
          case "margin":
            final parts = value?.split(RegExp(r'\s+')) ?? [];
            if (parts.isNotEmpty) {
              final sides =
                  (parts.length == 2 || parts.length == 4 || parts.length == 3)
                      ? parts[1]
                      : (parts.length == 1 ? parts[0] : null);
              if (sides == 'auto') {
                marginLeftAuto = true;
                marginRightAuto = true;
              }
              final numericalInsets = parseCssEdgeInsets(value);
              marginTop = numericalInsets?.top;
              marginRight = numericalInsets?.right;
              marginBottom = numericalInsets?.bottom;
              marginLeft = numericalInsets?.left;
            }
            break;
          case "margin-left":
            final parsed = parseCssSize(value);
            if (parsed == 'auto') {
              marginLeftAuto = true;
            } else if (parsed is double) {
              marginLeft = parsed;
            }
            break;
          case "margin-right":
            final parsed = parseCssSize(value);
            if (parsed == 'auto') {
              marginRightAuto = true;
            } else if (parsed is double) {
              marginRight = parsed;
            }
            break;
          case "margin-top":
            final parsed = parseCssSize(value);
            if (parsed is double) marginTop = parsed;
            break;
          case "margin-bottom":
            final parsed = parseCssSize(value);
            if (parsed is double) marginBottom = parsed;
            break;
        }
      }

      if (RegExp(r'^padding($|-top|-right|-bottom|-left)$')
          .hasMatch(property)) {
        final size = parseCssSize(value) ?? 0;
        switch (property) {
          case "padding":
            EdgeInsets? edgeInsets = parseCssEdgeInsets(value);
            if (edgeInsets != null) {
              paddingTop = edgeInsets.top;
              paddingRight = edgeInsets.right;
              paddingBottom = edgeInsets.bottom;
              paddingLeft = edgeInsets.left;
            }
            break;
          case "padding-top":
            paddingTop = size;
            break;
          case "padding-right":
            paddingRight = size;
            break;
          case "padding-bottom":
            paddingBottom = size;
            break;
          case "padding-left":
            paddingLeft = size;
            break;
        }
      }

      switch (property) {
        case 'font-size':
          fontSize = parseFontSize(value) ?? baseFontSize;
          break;
        case 'font-weight':
          fontWeight = parseFontWeight(value);
          break;
        case 'color':
          color = parseColor(value);
          break;
        case 'font-style':
          if (value == 'italic') fontStyle = FontStyle.italic;
          break;
        case "line-height":
          lineHeight = parseLineHeight(value, fontSize);
          break;
        case "text-align":
          textAlign = parseTextAlign(value);
          break;
        case "text-shadow":
          shadowList = parseTextShadows(value);
          break;
        case 'width':
          width = parseCssSize(value);
          break;
        case 'height':
          height = parseCssSize(value) ?? 0;
          break;
        case 'border-radius':
          borderRadius = parseBorderRadius(value);
          break;
        case 'float':
          if (value == 'left' || value == 'right' || value == 'none') {
            floatDirection = value;
          }
          break;
      }
    }

    if (fontSize != baseFontSize) parseLineHeight(rawLineHeight, fontSize);

    ModelStyle modelStyle = ModelStyle(
      padding: EdgeInsets.only(
        top: paddingTop ?? 0,
        right: paddingRight ?? 0,
        bottom: paddingBottom ?? 0,
        left: paddingLeft ?? 0,
      ),
      margin: EdgeInsets.only(
        top: marginTop ?? 0,
        right: marginRight ?? 0,
        bottom: marginBottom ?? 0,
        left: marginLeft ?? 0,
      ),
      width: width,
      height: height,
      borderRadius: borderRadius,
      floatDirection: floatDirection,
      lineHeight: lineHeight,
      textAlign: textAlign,
      textShadows: shadowList,
      textStyle: TextStyle(
          color: color,
          height: lineHeight,
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: shadowList,
          fontStyle: fontStyle),
    );
    return modelStyle;
  }

  EdgeInsets? parseCssEdgeInsets(String? value) {
    if (value == null) return EdgeInsets.zero;

    final parts =
        value.split(RegExp(r'\s+')).map((v) => parseCssSize(v)).toList();
    switch (parts.length) {
      case 1: // 所有方向
        return EdgeInsets.all(parts[0] ?? 0);
      case 2: // 上下、左右
        return EdgeInsets.symmetric(
          vertical: parts[0] ?? 0,
          horizontal: parts[1] ?? 0,
        );
      case 3: // 上、左右、下
        return EdgeInsets.fromLTRB(
          parts[1] ?? 0,
          parts[0] ?? 0,
          parts[1] ?? 0,
          parts[2] ?? 0,
        );
      case 4: // 上、右、下、左
        return EdgeInsets.fromLTRB(
          parts[3] ?? 0,
          parts[0] ?? 0,
          parts[1] ?? 0,
          parts[2] ?? 0,
        );
      default:
        return EdgeInsets.zero;
    }
  }

  double? parseFontSize(String? value) {
    if (value == null) return null;
    value = value.replaceAll('!important', '').trim();
    if (value.contains('px')) {
      return double.tryParse(value.replaceAll('px', '')) ?? 0;
    }
    if (value.contains('em')) {
      double emNum =
          double.tryParse(value.replaceAll('em', ''))?.toDouble() ?? 0;
      return emNum * baseFontSize;
    }
    if (value.contains('%')) {
      double percentageNum =
          double.tryParse(value.replaceAll('%', ''))?.toDouble() ?? 0;
      return percentageNum / 100 * baseFontSize;
    }
    if (value == "smaller") return baseFontSize;
    return double.tryParse(value) ?? 0;
  }

  double? parseCssSize(String? value) {
    if (value == null) return null;
    value = value.replaceAll('!important', '').trim();
    if (value.contains('px')) {
      return double.tryParse(value.replaceAll('px', '')) ?? 0;
    }
    if (value.contains('em')) {
      double emNum =
          double.tryParse(value.replaceAll('em', ''))?.toDouble() ?? 0;
      return emNum * baseFontSize;
    }
    return double.tryParse(value) ?? 0;
  }

  FontWeight? parseFontWeight(String? value) {
    switch (value) {
      case "bold":
        return FontWeight.bold;
      case "normal":
        return FontWeight.normal;
      case "100":
        return FontWeight.w100;
      case "200":
        return FontWeight.w200;
      case "300":
        return FontWeight.w300;
      case "400":
        return FontWeight.w400;
      case "500":
        return FontWeight.w500;
      case "600":
        return FontWeight.w700;
      case "700":
        return FontWeight.w700;
      case "800":
        return FontWeight.w800;
      case "900":
        return FontWeight.w900;
      default:
        return null;
    }
  }

  Color? parseColor(String? value) {
    if (value == null) return null;

    if (value.startsWith("#")) {
      final String hex = value.replaceAll("#", "");
      if (hex.length == 6) {
        return Color(int.parse("0xff$hex"));
      } else if (hex.length == 3) {
        final r = hex[0] * 2, g = hex[1] * 2, b = hex[2] * 2;
        return Color(int.parse("0xff$r$g$b"));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    }

    if (value.startsWith("rgb")) {
      final rgbaMatch = RegExp(r'rgba?\(([^)]+)\)').firstMatch(value);
      if (rgbaMatch != null) {
        final parts =
            rgbaMatch.group(1)!.split(",").map((e) => e.trim()).toList();
        if (parts.length >= 3) {
          final int r = int.tryParse(parts[0]) ?? 0;
          final int g = int.tryParse(parts[1]) ?? 0;
          final int b = int.tryParse(parts[2]) ?? 0;
          double a = 1.0;
          if (parts.length == 4) {
            a = double.tryParse(parts[4]) ?? 1.0;
          }
          return Color.fromRGBO(r, g, b, a);
        }
      }
    }

    value = value.toLowerCase();
    if (cssColorKeywords.containsKey(value)) return cssColorKeywords[value];

    return null;
  }

  double? parseLineHeight(String? value, double fontSize) {
    if (value == null) return null;
    value = value.trim();

    if (value == "normal") return 1.2;
    if (value.endsWith("px")) {
      final px = double.tryParse(value.replaceAll("px", ""));
      return px != null ? px / fontSize : null;
    } else if (value.endsWith("em")) {
      final em = double.tryParse(value.replaceAll("em", ""));
      return em;
    }

    return double.tryParse(value);
  }

  TextAlign parseTextAlign(String? value) {
    switch (value?.trim()) {
      case "center":
        return TextAlign.center;
      case "right":
        return TextAlign.right;
      case "left":
        return TextAlign.left;
      case "justify":
        return TextAlign.justify;
      default:
        return TextAlign.start;
    }
  }

  bool isColor(String value) {
    return value.startsWith("#") ||
        value.startsWith("rgb") ||
        value == 'transparent' ||
        value == 'currentColor' ||
        cssColorKeywords.containsKey(value.toLowerCase());
  }

  Shadow parseOneTextShadow(String input) {
    final List<String> parts = input.trim().split(RegExp(r'\s+'));

    double dx = 0, dy = 0, blur = 0;
    Color color = const Color(0xFF000000);

    final List<String> list = [];
    String? colorParts;

    for (String part in parts) {
      if (isColor(part)) {
        colorParts = part;
      } else {
        list.add(part);
      }
    }

    if (colorParts != null) {
      color = parseColor(colorParts) ?? const Color(0xFF000000);
    }

    if (list.isNotEmpty) {
      dx = parseCssSize(list[0]) ?? 0;
    }
    if (list.length > 1) {
      dy = parseCssSize(list[1]) ?? 0;
    }
    if (list.length > 2) {
      blur = parseCssSize(list[2]) ?? 0;
    }

    return Shadow(color: color, offset: Offset(dx, dy), blurRadius: blur);
  }

  List<Shadow> parseTextShadows(String? raw) {
    if (raw == null) return [];
    final shadowParts = raw.split(',').map((e) => e.trim());
    return shadowParts.map(parseOneTextShadow).toList();
  }

  BorderRadius? parseBorderRadius(String? value) {
    if (value == null) return null;

    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .map((e) => parseCssSize(e) ?? 0)
        .toList();
    switch (parts.length) {
      case 1:
        return BorderRadius.all(Radius.circular(parts[0]));
      case 2:
        return BorderRadius.only(
          topLeft: Radius.circular(parts[0]),
          topRight: Radius.circular(parts[1]),
          bottomRight: Radius.circular(parts[0]),
          bottomLeft: Radius.circular(parts[1]),
        );
      case 3:
        return BorderRadius.only(
          topLeft: Radius.circular(parts[0]),
          topRight: Radius.circular(parts[1]),
          bottomRight: Radius.circular(parts[2]),
          bottomLeft: Radius.circular(parts[1]),
        );
      case 4:
        return BorderRadius.only(
          topLeft: Radius.circular(parts[0]),
          topRight: Radius.circular(parts[1]),
          bottomRight: Radius.circular(parts[2]),
          bottomLeft: Radius.circular(parts[3]),
        );
      default:
        return BorderRadius.zero;
    }
  }
}

class ModelStyle {
  TextStyle? textStyle;
  double? height;
  double? width;
  EdgeInsets? padding;
  EdgeInsets? margin;
  BorderRadius? borderRadius;
  String? floatDirection;
  double? lineHeight;
  TextAlign? textAlign;
  List<Shadow>? textShadows;
  bool? marginLeftAuto;
  bool? marginRightAuto;

  ModelStyle(
      {this.textStyle,
      this.margin,
      this.padding,
      this.width,
      this.height,
      this.borderRadius,
      this.floatDirection,
      this.lineHeight,
      this.textAlign,
      this.textShadows,
      this.marginLeftAuto,
      this.marginRightAuto});

  ModelStyle merge(ModelStyle? other) {
    if (other == null) return this;
    return ModelStyle(
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      width: other.width ?? width,
      height: other.height ?? height,
      margin: other.margin ?? margin,
      padding: other.padding ?? padding,
      borderRadius: other.borderRadius ?? borderRadius,
      floatDirection: other.floatDirection ?? floatDirection,
      lineHeight: other.lineHeight ?? lineHeight,
      textAlign: other.textAlign ?? textAlign,
      textShadows: other.textShadows ?? textShadows,
    );
  }

  ModelStyle clone() {
    return ModelStyle(
      textStyle: textStyle != null
          ? textStyle!.copyWith() // TextStyle 自带 copyWith()
          : null,
      width: width,
      height: height,
      margin: margin != null
          ? EdgeInsets.fromLTRB(
              margin!.left, margin!.top, margin!.right, margin!.bottom)
          : null,
      padding: padding != null
          ? EdgeInsets.fromLTRB(
              padding!.left, padding!.top, padding!.right, padding!.bottom)
          : null,
      borderRadius: borderRadius != null
          ? BorderRadius.only(
              topLeft: borderRadius!.topLeft,
              topRight: borderRadius!.topRight,
              bottomLeft: borderRadius!.bottomLeft,
              bottomRight: borderRadius!.bottomRight,
            )
          : null,
      floatDirection: floatDirection,
      lineHeight: lineHeight,
      textAlign: textAlign,
      textShadows: textShadows != null ? List<Shadow>.from(textShadows!) : null,
      marginLeftAuto: marginLeftAuto,
      marginRightAuto: marginRightAuto,
    );
  }
}
