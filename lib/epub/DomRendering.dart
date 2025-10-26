import 'dart:ui';

import 'package:DReader/theme/extensions/ReaderTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:DReader/common/EpubParsing.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:DReader/epub/CssToTextstyle.dart';
import 'package:DReader/epub/Node/BodyNode.dart';
import 'package:DReader/epub/Node/BrNode.dart';
import 'package:DReader/epub/Node/DelNode.dart';
import 'package:DReader/epub/Node/INode.dart';
import 'package:DReader/epub/Node/ImageNode.dart';
import 'package:DReader/epub/Node/RubyNode.dart';
import 'package:DReader/epub/ReaderNode.dart';

import 'Node/BNode.dart';
import 'Node/TextNode.dart';

class DomRendering {
  DomRendering({this.readIndex = 0, required this.readerTheme});

  int readIndex;
  ReaderTheme readerTheme;
  int nodeIndex = 0;
  List<String> tagList = [];
  CssToTextstyle cssToTextstyle = CssToTextstyle();
  Map<String, StyleMap> cssMap = {};
  List<List<ReaderNode>> nodeListList = [];
  late EpubParsing epubParsing;
  List<String> blockList = [
    "div",
    "p",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "ol",
    "li",
    "aside",
    "table",
    "tbody",
    "tr",
    "td",
    "note",
    "section",
    "figure",
  ];
  late ModelStyle readerThemeStyle;

  ModelStyle getStyle(String css, ModelStyle style, node) {
    StyleMap styleMap = cssMap[css]!;
    for (var item in styleMap.importList) {
      style = getStyle(item, style, node);
    }

    if (styleMap.tagStyles.containsKey(node.localName)) {
      ModelStyle tagStyle = styleMap.tagStyles[node.localName]!;
      style = style.merge(tagStyle);
    }

    for (var className in node.classes) {
      if (styleMap.classStyles.containsKey(className)) {
        ModelStyle classStyle = styleMap.classStyles[className]!;
        style = style.merge(classStyle);
      }
    }

    if (styleMap.idStyles.containsKey(node.id)) {
      ModelStyle idStyle = styleMap.idStyles[node.id]!;
      style = style.merge(idStyle);
    }

    return style;
  }

  ModelStyle checkReadTheme() {
    return ModelStyle(
      textStyle: TextStyle(
        color: !readerTheme.followThemeColor ? readerTheme.textColor : null,
        fontSize: !readerTheme.followThemeColor
            ? readerTheme.textSize.toDouble()
            : null,
      ),
      margin: readerTheme.useLinePreset
          ? null
          : EdgeInsets.only(bottom: readerTheme.lineMargin ?? 12, top: 0),
      extraLineSpacing: !readerTheme.useLinePreset && readerTheme.useLineSpacing
          ? readerTheme.lineMargin
          : null,
    );
  }

  Future<List<ReaderNode>> domParse(
    List<dom.Node> nodes,
    ModelStyle baseStyle,
    List<String> useCss,
  ) async {
    List<ReaderNode> list = [];
    for (var node in nodes) {
      ReaderNode readerNode;
      ModelStyle style = baseStyle.clone();
      if (node is dom.Text) {
        String text = node.text;
        text = text.replaceAll('\n', '').trim();
        if (text.isNotEmpty && !text.contains('\n')) {
          // if(style.extraLineSpacing != null){
          //   double fontSize = style.textStyle!.fontSize!;
          //   double height = (fontSize + style.extraLineSpacing!) / fontSize;
          //   style.textStyle = style.textStyle?.merge(TextStyle(height: height));
          // }
          list.add(
            TextNode(
              TextSpan(text: text, style: style.textStyle),
              style,
              nodeIndex,
            ),
          );
        }
      } else if (node is dom.Element) {
        for (String css in useCss) {
          style = getStyle(css, style, node);
        }

        String? nodeStyle = node.attributes["style"];
        if (nodeStyle != null) {
          style = style.merge(cssToTextstyle.parseInlineStyle(nodeStyle));
        }

        style = style.merge(readerThemeStyle);
        if (blockList.contains(node.localName)) {
          readerNode = BlockNode(node.localName!, style, nodeIndex);
        } else {
          if (["image", "img"].contains(node.localName)) {
            String? path = getImageBytes(node);
            if (path == null) continue;
            List<int>? list = epubParsing.getImage(path);
            if (list == null || list.isEmpty) continue;
            readerNode = ImageNode(
              node.localName!,
              style,
              nodeIndex,
              list,
              path,
            );
            await (readerNode as ImageNode).decode();
          } else if (node.localName == "i") {
            readerNode = INode("i", style, nodeIndex);
          } else if (node.localName == "ruby") {
            readerNode = RubyNode("ruby", style, nodeIndex);
          } else if (node.localName == "rt") {
            readerNode = RtNode("rt", style, nodeIndex);
          } else if (node.localName == "br") {
            readerNode = BrNode("br", style, nodeIndex);
          } else if (node.localName == "del") {
            readerNode = DelNode("del", style, nodeIndex);
          } else if (node.localName == "b") {
            readerNode = BNode("b", style, nodeIndex);
          } else {
            readerNode = InlineNode(node.localName!, style, nodeIndex);
          }
        }

        style = readerNode.styleModel;
        readerNode.children = await domParse(node.nodes, style, useCss);
        list.add(readerNode);
      }
      nodeIndex++;
    }
    return list;
  }

  List<String> extractExternalCssLinks(dom.Document document) {
    final links = document.querySelectorAll('link[rel="stylesheet"]');
    return links
        .map((element) => element.attributes['href']?.split("/").last)
        .where((href) => href != null && href.isNotEmpty)
        .cast<String>()
        .toList();
  }

  Future<List<List<ReaderNode>>> start(List<int> epubBytes) async {
    try {
      epubParsing = EpubParsing();
      List<String>? list = await epubParsing.parseEpubFromBytes(epubBytes);

      Map<String, String> cssList = epubParsing.getAllCss();
      cssList.forEach((key, value) {
        cssMap[key] = cssToTextstyle.parseCssToStyleMap(value);
      });

      readerThemeStyle = checkReadTheme();
      if (list != null) {
        for (String item in list) {
          dom.Document document = html_parser.parse(item);
          List<String> useCss = extractExternalCssLinks(document);
          final styleTags = document.querySelectorAll('style');
          List<ReaderNode> nodeList = await domParse(
            document.body?.nodes ?? [],
            ModelStyle(),
            useCss,
          );
          if (nodeList.length > 1) {
            BodyNode bodyNode = BodyNode();
            bodyNode.children = nodeList;
            nodeListList.add([bodyNode]);
          } else {
            nodeListList.add(nodeList);
          }
        }
      }

      return nodeListList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String? getImageBytes(dom.Element element) {
    String? path;
    if (element.localName == 'img') {
      path = element.attributes["src"]?.replaceAll('../', '');
    } else if (element.localName == 'image') {
      element.attributes.forEach((key, value) {
        if (key.toString() == "xlink:href" || key.toString() == "href") {
          path = element.attributes[key]?.replaceAll('../', '');
        }
      });
    }
    return path;
  }
}
