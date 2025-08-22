import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:DReader/epub/ReaderNode.dart';
import 'package:image/image.dart' as img;

class ImageNode extends InlineNode {
  @override
  String get tag => "img";
  List<int> bytes;
  late ui.Image image;
  String imgName;

  ImageNode(super.tag, super.styleModel, super.uniqueId, this.bytes,
      this.imgName);

  Future<void> decode() async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image img) {
      completer.complete(img);
    });
    image = await completer.future;
  }

  @override
  List<ReaderNode> layout(double availableWidth, Offset offset, {isFull}) {
    layoutBefore();
    currentOffset = offset;

    double originalWidth = image.width.toDouble();
    double originalHeight = image.height.toDouble();
    double aspectRatio = originalWidth / originalHeight;

    double remainingHeight = NodeStatus.pageHeight - currentOffset.dy;
    bool hasExplicitSize = (styleModel.width ?? -1) > 0 || (styleModel.height ?? -1) > 0;
    if (hasExplicitSize) {
      double targetWidth = styleModel.width ?? -1;
      double targetHeight = styleModel.height ?? -1;
      if (targetWidth > 0 && targetHeight > 0) {
        currentWidth = targetWidth;
        currentHeight = targetHeight;
      } else if (targetWidth <= 0 && targetHeight > 0) {
        currentHeight = targetHeight;
        currentWidth = currentHeight * aspectRatio;
      } else {
        currentWidth = targetWidth;
        currentHeight = currentWidth / aspectRatio;
      }

      if (currentHeight > remainingHeight) {
        return cloneImage();
      }

      if (currentWidth > availableWidth) {
        isEnter = true;
        currentWidth = availableWidth;
        currentHeight = currentWidth / aspectRatio;
        if (currentHeight > remainingHeight) return cloneImage();
      }

      nextOffset = Offset(currentOffset.dx + currentWidth, currentOffset.dy);
    } else {
      double top = 0;
      double left = 0;
      currentHeight = NodeStatus.pageHeight;
      currentWidth = currentHeight * aspectRatio;
      if (currentOffset.dy > 0 || remainingHeight < NodeStatus.pageHeight) {
        return cloneImage();
      }

      if (currentWidth > availableWidth) {
        currentWidth = availableWidth;
        currentHeight = currentWidth / aspectRatio;
      }else left = (availableWidth - currentWidth) / 2;

      if (currentHeight < NodeStatus.pageHeight) top = (NodeStatus.pageHeight - currentHeight) / 2;

      currentOffset = Offset(currentOffset.dx + left, currentOffset.dy + top);
      nextOffset = Offset(currentOffset.dx + currentWidth, currentOffset.dy + currentHeight);
    }
    return [];
  }

  List<ReaderNode> cloneImage() {
    isTurning = true;
    currentWidth = 0;
    currentHeight = 0;
    currentLineHeight = 0;
    return [clone()];
  }

  @override
  void paint(ui.Canvas canvas, ui.Offset offset) {
    Rect src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    Rect dst = Rect.fromLTWH(
        currentOffset.dx, currentOffset.dy, currentWidth, currentHeight);
    canvas.drawImageRect(image, src, dst, Paint());
  }

  @override
  ImageNode clone() {
    ImageNode cloneNode = ImageNode(tag, styleModel, uniqueId, bytes, imgName);
    cloneNode.image = image;
    return cloneNode;
  }
}
