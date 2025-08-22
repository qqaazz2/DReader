import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

class EpubParsing {
  late final Map<String, List<int>> files;
  String _opfDir = "";

  Future<Map<String, dynamic>> _getOptData(List<int> epubBytes) async {
    files = await extractEpubFromBytes(epubBytes);
    final opfPath = locateOpfFile(files);
    final opfContent = utf8.decode(files[opfPath]!);
    final Map<String, dynamic> opfData = parseOpf(opfContent);
    return opfData;
  }

  Future<List<String>?> parseEpubFromBytes(List<int> epubBytes) async {
    try {
      Map<String, dynamic> opfData = await _getOptData(epubBytes);
      print('opfData$opfData');
      List<String> chapters =
          readChapters(files, opfData['manifest'], opfData['spine']);
      return chapters;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<String>> parseEpubImageFromBytes(List<int> epubBytes) async {
    try {
      Map<String, dynamic> opfData = await _getOptData(epubBytes);
      List<String> images = [];
      opfData["manifest"].forEach((id, path) {
        final lower = path.toLowerCase();
        if (lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png') ||
            lower.endsWith('.gif') ||
            lower.endsWith('.svg')) {
          images.add(path);
        }
      });
      return images;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, List<int>>> extractEpubFromBytes(
      List<int> epubBytes) async {
    final archive = ZipDecoder().decodeBytes(epubBytes);
    final extractedFiles = <String, List<int>>{};

    for (final file in archive) {
      if (file.isFile) {
        extractedFiles[file.name] = file.content as List<int>;
      }
    }

    return extractedFiles;
  }

  String locateOpfFile(Map<String, List<int>> files) {
    const containerPath = 'META-INF/container.xml';
    if (!files.containsKey(containerPath)) {
      throw Exception('container.xml not found!');
    }

    final containerContent = utf8.decode(files[containerPath]!);
    final document = XmlDocument.parse(containerContent);
    final opfPath =
        document.findAllElements('rootfile').first.getAttribute('full-path');
    if (opfPath == null) {
      throw Exception('OPF file path not found in container.xml!');
    }

    _opfDir = opfPath.contains("/")
        ? opfPath.substring(0, opfPath.lastIndexOf("/"))
        : "";
    return opfPath;
  }

  Map<String, dynamic> parseOpf(String opfContent) {
    final document = XmlDocument.parse(opfContent);

    // 解析 manifest
    Map<String, String> manifest = {};
    for (final item in document.findAllElements('item')) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      if (id != null && href != null) {
        manifest[id] = href;
      }
    }

    // 解析 spine
    final spine = document
        .findAllElements('itemref')
        .map((itemRef) {
          return itemRef.getAttribute('idref');
        })
        .where((idref) => idref != null)
        .toList();

    return {'manifest': manifest, 'spine': spine};
  }

  List<String> readChapters(
    Map<String, List<int>> files,
    Map<String, String> manifest,
    List<String?> spine,
  ) {
    final chapters = <String>[];

    for (final idref in spine) {
      String? relativePath = manifest[idref];
      if (relativePath == null) {
        throw Exception('Warning: idref $idref not found in manifest.');
      }

      relativePath = Uri.decodeFull(relativePath);
      final chapterFile = files["$_opfDir/$relativePath"];
      if (chapterFile == null) {
        throw Exception('Warning: Chapter file not found: $relativePath');
      }

      final content = utf8.decode(chapterFile);
      chapters.add(content);
    }

    return chapters;
  }

  List<int>? getImage(String path) {
    if (path.contains("http")) return null;

    if (files.containsKey("$_opfDir/$path")) {
      return files["$_opfDir/$path"];
    }
    return null;
  }

  Map<String, String> getAllCss() {
    Map<String, String> cssTexts = {};

    for (final entry in files.entries) {
      if (entry.key.endsWith('.css')) {
        final content = utf8.decode(entry.value);
        String key = entry.key.split("/").last;
        cssTexts[key] = content;
      }
    }

    return cssTexts;
  }
}
