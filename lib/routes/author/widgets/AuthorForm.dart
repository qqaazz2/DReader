import 'dart:io';
import 'dart:math' as math;

import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/author/AuthorItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/author/AuthorListState.dart';
import 'package:DReader/state/author/AuthorUpdateState.dart';
import 'package:DReader/widgets/FormInput.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthorForm extends ConsumerStatefulWidget {
  AuthorForm({super.key, this.authorDetail});

  AuthorDetail? authorDetail;

  @override
  ConsumerState<AuthorForm> createState() => AuthorFormState();
}

class AuthorFormState extends ConsumerState<AuthorForm> {
  late AuthorDetail authorDetail;
  late TextEditingController nameController;
  late TextEditingController bgmIdController;
  late TextEditingController dateController;
  late TextEditingController vocationalController;
  late TextEditingController profileController;
  String? filePath;

  @override
  void initState() {
    super.initState();
    if (widget.authorDetail == null) {
      authorDetail = AuthorDetail(null, "", null, null, null, null, null);
    } else {
      authorDetail = widget.authorDetail!.copyWith();
    }
    nameController = TextEditingController(text: authorDetail.name);
    bgmIdController = TextEditingController(
      text: authorDetail.bgmId == null ? null : authorDetail.bgmId.toString(),
    );
    dateController = TextEditingController(text: authorDetail.date);
    vocationalController = TextEditingController(text: authorDetail.vocational);
    profileController = TextEditingController(text: authorDetail.profile);
  }

  void changeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() => filePath = result.files.single.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        double width = constraint.maxWidth > MyApp.width
            ? constraint.maxWidth * 0.5
            : constraint.maxWidth;
        double height = constraint.maxHeight > MyApp.width
            ? constraint.maxHeight * 0.5
            : constraint.maxHeight;
        double imageSize = math.min(width * 0.5, 300);
        return Form(
          child: AlertDialog(
            insetPadding: constraint.maxWidth > MyApp.width
                ? null
                : EdgeInsets.zero,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            constraints: BoxConstraints(
              minWidth: width,
              minHeight: height,
              maxWidth: width,
              maxHeight: height,
            ),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "作者信息",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: imageSize,
                              height: imageSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(child: avatarWidget(imageSize)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Material(
                                color: Theme.of(context).primaryColor, // 使用主题色
                                shape: const CircleBorder(),
                                elevation: 4,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: changeImage, // 点击触发选择图片
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FormInput(
                          label: '名称',
                          controller: nameController,
                          iconData: Icons.drive_file_rename_outline_sharp,
                          onSaved: (String? value) =>
                              authorDetail.name = value!,
                          validator: (value) {
                            if (value!.trim().isEmpty) return "请输入名称";
                            return null;
                          },
                        ),
                        FormInput(
                          label: 'BGMID',
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: bgmIdController,
                          textInputType: TextInputType.number,
                          iconData: Icons.numbers,
                          onSaved: (String? value) =>
                              authorDetail.bgmId = int.tryParse(value!),
                        ),
                        Listener(
                          child: AbsorbPointer(
                            child: FormInput(
                              label: '出生年月',
                              readOnly: true,
                              controller: dateController,
                              iconData: Icons.date_range,
                              onSaved: (String? value) =>
                                  authorDetail.date = value!,
                            ),
                          ),
                          onPointerDown: (v) => showDateDialog(),
                        ),
                        FormInput(
                          label: '职业',
                          controller: vocationalController,
                          iconData: Icons.person_3,
                          onSaved: (String? value) =>
                              authorDetail.vocational = value!,
                        ),
                        FormInput(
                          label: '系列简介',
                          controller: profileController,
                          iconData: Icons.content_paste_rounded,
                          onSaved: (String? value) =>
                              authorDetail.profile = value!,
                          maxLines: 100,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () => save(context),
                        child: const Text("确认"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("取消"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget avatarWidget(double size) {
    int cacheSize = (size * 2.5).toInt();
    if (filePath != null) {
      return Image.file(
        File(filePath!),
        fit: BoxFit.cover,
        width: size,
        height: size,
        // 🔥【防 OOM 关键】指定缓存宽度，Flutter 会在解码时缩小图片
        cacheWidth: cacheSize,
      );
    }

    if (authorDetail.avatar != null && authorDetail.avatar!.isNotEmpty) {
      return ImageModule.getImage(authorDetail.avatar);
    }

    // 默认占位图
    return Icon(Icons.person, size: size * 0.6, color: Colors.grey.shade400);
  }

  void showDateDialog() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );

    if (dateTime != null) {
      setState(() => dateController.text = dateTime.toString().split(" ")[0]);
    }
  }

  void save(context) async {
    bool status = Form.of(context).validate();
    if (status) {
      Form.of(context).save();
      FormData formData = FormData.fromMap({
        ...authorDetail.toJson(),
        if (filePath != null)
          "avatarFile": await MultipartFile.fromFile(
            filePath!,
            filename: "cover",
          ),
      });
      if (authorDetail.id == null) {
        BaseResult<AuthorDetail> baseResult =
            await HttpApi.request<AuthorDetail>(
              "/author/create",
              (json) => AuthorDetail.fromJson(json),
              method: "post",
              formData: formData,
            );
        if (baseResult.code == "2000") {
          if (baseResult.result == null) return;
          ref
              .read(authorListStateProvider.notifier)
              .addFirstItem(
                AuthorItem(
                  baseResult.result!.id!,
                  baseResult.result!.name,
                  baseResult.result!.avatar,
                ),
              );
          Navigator.of(context).pop();
        }
      } else {
        BaseResult<AuthorDetail> baseResult =
            await HttpApi.request<AuthorDetail>(
              "/author/update",
              (json) => AuthorDetail.fromJson(json),
              method: "post",
              formData: formData,
            );
        if (baseResult.code == "2000") {
          if (baseResult.result == null) return;
          ref.read(authorUpdateStateProvider).add(baseResult.result!);
        }
      }
    }
  }
}
