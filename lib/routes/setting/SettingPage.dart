import 'dart:convert';
import 'dart:io';

import 'package:DReader/common/ImageModule.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:DReader/common/Global.dart';
import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/UserInfo.dart';
import 'package:DReader/main.dart';
import 'package:DReader/state/ThemeState.dart';
import 'package:crypto/crypto.dart';
import 'package:DReader/widgets/KeepActivePage.dart';
import 'package:DReader/widgets/TopTool.dart';

import 'SettingChart.dart';
import 'widgets/SettingPieChart.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends ConsumerState<SettingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> tabs = ["我的", "图表数据"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // if(Global.setting.userInfo == null){
    //   HttpApi.request("/user/info", (json) => UserInfo.fromJson(json)).then((baseResult) {
    //     Global.setting.userInfo = baseResult.result;
    //   });
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 800) {
          return getMobile(constraints);
        } else {
          return getPc(constraints);
        }
      },
    );
  }

  Widget getMobile(BoxConstraints constraints) {
    return TopTool(
        title: "设置",
        child: Consumer(builder: (context, ref, child) {
          final state = ref.watch(themeStateProvider);
          return Column(
            children: [
              Expanded(
                  child: TabBarView(controller: _tabController, children: [
                KeepActivePage(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Stack(children: [
                              Align(
                                child: Container(
                                  width: constraints.maxWidth * 0.5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // 使用多个阴影效果增强立体感
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .shadowColor
                                            .withOpacity(0.2),
                                        // 更淡的阴影
                                        offset: const Offset(4, 4),
                                        blurRadius: 12,
                                        spreadRadius: 4,
                                      ),
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .shadowColor
                                            .withOpacity(0.1),
                                        // 更淡的第二层阴影
                                        offset: const Offset(-4, -4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: ClipOval(
                                        child: ImageModule.minioImage(
                                            Global.setting.userInfo?.cover,
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () => changeImage(),
                                          icon:
                                              const Icon(Icons.image_rounded)),
                                      IconButton(
                                          onPressed: () => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return userDetailForm(context);
                                              }),
                                          icon: const Icon(Icons.edit_note))
                                    ],
                                  ))
                            ]),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                Global.setting.userInfo?.name ?? "",
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: SingleChildScrollView(child: getListWidget())),
                    ],
                  ),
                ),
                KeepActivePage(
                  widget: SettingChart(
                    constraints: constraints,
                  ),
                ),
              ])),
              TabBar(
                controller: _tabController,
                tabs: tabs.map((e) => Tab(text: e)).toList(),
              ),
            ],
          );
        }));
  }

  Widget getPc(constraints) {
    double getWidth() {
      if (constraints.maxWidth < 1350) return 300;
      return 400;
    }

    return Row(
      children: [
        Container(
          color: Theme.of(context).cardColor.withOpacity(0.7),
          width: getWidth(),
          height: double.infinity,
          child: Consumer(builder: (context, ref, child) {
            final state = ref.watch(themeStateProvider);
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: getWidth(),
                  height: getWidth(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Stack(children: [
                        Align(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // 使用多个阴影效果增强立体感
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withOpacity(0.2), // 更淡的阴影
                                  offset: const Offset(4, 4),
                                  blurRadius: 12,
                                  spreadRadius: 4,
                                ),
                                BoxShadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withOpacity(0.1),
                                  // 更淡的第二层阴影
                                  offset: const Offset(-4, -4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            width: getWidth() - 100,
                            height: getWidth() - 100,
                            child: ClipOval(
                                child: ImageModule.minioImage(
                                    Global.setting.userInfo?.cover,
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () => changeImage(),
                                    icon: const Icon(Icons.image_rounded)),
                                IconButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return userDetailForm(context);
                                        }),
                                    icon: const Icon(Icons.edit_note))
                              ],
                            ))
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          Global.setting.userInfo?.name ?? "",
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SingleChildScrollView(child: getListWidget())),
              ],
            );
          }),
        ),
        Expanded(
            child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SettingChart(
            constraints: constraints,
          ),
        ))
      ],
    );
  }

  Widget getListWidget() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.email_rounded),
          title: const Text(
            "邮箱:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            Global.setting.userInfo?.email ?? "",
            style: const TextStyle(fontSize: 15),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text(
            "服务器地址",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            Global.setting.serverConfig.baseUrl,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: const Icon(Icons.edit),
          onTap: () => Global.showSetBaseUrlDialog(context),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.color_lens_sharp),
          title: const Text(
            "切换主题",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Text("当前：${Global.setting.light ? "暗色" : "亮色"}"),
          onTap: () => ref.read(themeStateProvider.notifier).changeTheme(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_attributes),
          title: const Text(
            "神秘开关",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Switch(
              value: Global.setting.userInfo?.mystery == 1,
              onChanged: (value) {
                if (Global.setting.userInfo?.mystery == 1) {
                  ref
                      .read(themeStateProvider.notifier)
                      .changeMystery(mystery: 2);
                } else {
                  showDialog(
                      context: context, builder: (context) => show(context));
                }
              }),
        ),
        const Divider(),
        if (Global.setting.userInfo?.mystery == 1)
          ListTile(
            leading: const Icon(Icons.create),
            title: const Text(
              "修改神秘开关密码",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => showDialog(
                context: context,
                builder: (context) {
                  if (size.width > MyApp.width) {
                    return Dialog(child: editPassWord(2));
                  }
                  return editPassWord(2);
                }),
          ),
        if (Global.setting.userInfo?.mystery == 1) const Divider(),
        ListTile(
          leading: const Icon(Icons.create),
          title: const Text(
            "修改密码",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () => showDialog(
              context: context,
              builder: (context) {
                if (size.width > MyApp.width) {
                  return Dialog(child: editPassWord(1));
                }
                return editPassWord(1);
              }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: const Text(
            "退出登录",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () => Global.logout(context),
        ),
        const Divider(),
      ],
    );
  }

  Widget show(context) {
    String password = "";
    return Form(
        child: AlertDialog(
      title: const Text("神秘开关"),
      content: SizedBox(
        width: 300,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                autocorrect: true,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "开关密码",
                    hintText: "请输入开关密码",
                    prefixIcon: Icon(
                      Icons.password,
                      size: 18,
                    )),
                onSaved: (value) => password = value!,
                validator: (value) {
                  if (value!.trim().isEmpty) return "开关密码不可为空";
                  return null;
                }),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("请输入密码确认开启神秘开关"),
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () => Navigator.of(context).pop(), //关闭对话框
        ),
        Builder(builder: (context) {
          return TextButton(
            child: const Text("确认"),
            onPressed: () async {
              bool status = Form.of(context).validate();
              if (status) {
                Form.of(context).save();
                password = md5.convert(utf8.encode(password)).toString();
                bool isTrue = await ref
                    .read(themeStateProvider.notifier)
                    .changeMystery(mystery: 1, mysteryPassword: password);
                if (isTrue) Navigator.of(context).pop(true); //关闭对话框
              }
            },
          );
        })
      ],
    ));
  }

  Widget userDetailForm(context) {
    UserInfo? userInfo = Global.setting.userInfo!;
    Size size = MediaQuery.of(context).size;
    return Form(
        child: AlertDialog(
      title: const Text("修改用户信息"),
      content: SizedBox(
        width: size.width > MyApp.width ? 400 : double.infinity,
        height: size.width > MyApp.width ? 200 : 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                decoration: const InputDecoration(
                    labelText: "名称",
                    hintText: "请输入名称",
                    prefixIcon: Icon(
                      Icons.person,
                      size: 18,
                    )),
                onSaved: (value) => userInfo.name = value!,
                initialValue: Global.setting.userInfo?.name ?? "",
                validator: (value) {
                  if (value!.trim().isEmpty) return "名称不可为空";
                  return null;
                }),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: "邮箱",
                        hintText: "请输入邮箱",
                        prefixIcon: Icon(
                          Icons.email,
                          size: 18,
                        )),
                    onSaved: (value) => userInfo.email = value!,
                    keyboardType: TextInputType.emailAddress,
                    initialValue: Global.setting.userInfo?.email ?? "",
                    validator: (value) {
                      if (value!.trim().isEmpty) return "邮箱不可为空";
                      return null;
                    })),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("取消"),
          onPressed: () => Navigator.of(context).pop(), //关闭对话框
        ),
        Builder(builder: (context) {
          return TextButton(
            child: const Text("确认"),
            onPressed: () async {
              bool status = Form.of(context).validate();
              if (status) {
                Form.of(context).save();
                BaseResult baseResult = await HttpApi.request(
                    method: "post",
                    params: userInfo.toJson(),
                    "/user/setInfo",
                    (json) => UserInfo.fromJson(json));
                if ("2000" == baseResult.code) {
                  ref
                      .read(themeStateProvider.notifier)
                      .changeUserInfo(userInfo);
                  Navigator.of(context).pop(true); //关闭对话框
                }
              }
            },
          );
        })
      ],
    ));
  }

  Widget editPassWord(int type) {
    Size size = MediaQuery.of(context).size;
    TextEditingController oldPassWordController = TextEditingController();
    TextEditingController secondaryController = TextEditingController();
    TextEditingController newPassWordController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: size.width > MyApp.width ? 400 : double.infinity,
      height: size.width > MyApp.width ? 400 : double.infinity,
      color: Theme.of(context).cardColor,
      child: Form(
          child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type == 1 ? "修改密码" : "修改神秘开关密码",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      autocorrect: true,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "旧密码",
                          hintText: "请输入旧密码",
                          prefixIcon: Icon(
                            Icons.password,
                            size: 18,
                          )),
                      controller: oldPassWordController,
                      validator: (value) {
                        if (value!.trim().isEmpty) return "旧密码不可为空";
                        return null;
                      })),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      autocorrect: true,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "新密码",
                          hintText: "请输入新密码",
                          prefixIcon: Icon(
                            Icons.password,
                            size: 18,
                          )),
                      controller: newPassWordController,
                      validator: (value) {
                        if (value!.trim().isEmpty) return "新密码不可为空";
                        if (value == oldPassWordController.text) {
                          return "新密码不能和旧密码一致";
                        }
                        return null;
                      })),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      autocorrect: true,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "二次确认密码",
                          hintText: "二次确认密码",
                          prefixIcon: Icon(
                            Icons.check,
                            size: 18,
                          )),
                      controller: secondaryController,
                      validator: (value) {
                        if (value!.trim().isEmpty) return "二次确认密码不可为空";

                        if (value != newPassWordController.text) {
                          return "两次输入的密码不一致";
                        }
                        return null;
                      })),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Builder(builder: (context) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      child: const Text("取消"),
                      onPressed: () => Navigator.of(context).pop(), //关闭对话框
                    ),
                  ),
                  ElevatedButton(
                    child: const Text("确认"),
                    onPressed: () async {
                      bool status = Form.of(context).validate();
                      if (status) {
                        BaseResult baseResult = await HttpApi.request(
                            method: "post",
                            params: {
                              "oldPassWord":
                                  md5Encrypt(oldPassWordController.text),
                              "newPassWord":
                                  md5Encrypt(secondaryController.text),
                            },
                            "/user/${type == 1 ? "updatePassWord" : "updateMysteryPassWord"}",
                            (json) => {json});
                        if ("2000" == baseResult.code) {
                          if (type == 1) {
                            EasyLoading.showSuccess("修改成功，请重新登录");
                            context.go("/login");
                          } else {
                            EasyLoading.showSuccess("修改神秘开关成功");
                            Navigator.of(context).pop();
                          }
                        }
                      }
                    },
                  ),
                ],
              );
            }),
          )
        ],
      )),
    );
  }

  String md5Encrypt(text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  void changeImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(result.files.single.path!,
            filename: "cover"),
      });
      BaseResult baseResult = await HttpApi.request(
          formData: formData,
          method: "post",
          "/user/uploadCover",
          (json) => json);
      if ("2000" == baseResult.code) {
        UserInfo userInfo = Global.setting.userInfo!;
        userInfo.cover = baseResult.result;
        ref.read(themeStateProvider.notifier).changeUserInfo(userInfo);
      }
    }
  }

// String splicingPath(String? filePath) {
//   String originalString = "${HttpApi.options.baseUrl}$filePath";
//   String modifiedString = originalString.replaceFirst('\\', '');
//   modifiedString = modifiedString.replaceAll('\\', '/');
//
//   return modifiedString;
// }

// Widget imageModule(String? path, {BoxFit? fit}) {
//   // if(kIsWeb){
//   //   return Image.network(path,width: double.infinity,height: double.infinity,headers: map,errorBuilder:(context,object,stackTrace) => Image.asset("images/2.png"));
//   // }else{
//   if (path == null) return const Icon(Icons.folder, size: 150);
//   return CachedNetworkImage(
//     width: double.infinity,
//     height: double.infinity,
//     imageUrl: path,
//     progressIndicatorBuilder: (context, url, downloadProgress) =>
//         CircularProgressIndicator(value: downloadProgress.progress),
//     httpHeaders: map,
//     errorWidget: (context, url, error) {
//       CachedNetworkImage.evictFromCache(url);
//       return const Icon(Icons.folder, size: 150);
//     },
//     fit: fit ?? BoxFit.cover,
//   );
//   // }
// }
}
