import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/common/ImageModule.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorDetail.dart';
import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/main.dart';
import 'package:DReader/routes/author/widgets/AuthorBookPcList.dart';
import 'package:DReader/routes/author/widgets/AuthorDetailMobile.dart';
import 'package:DReader/routes/author/widgets/AuthorDetailPcCard.dart';
import 'package:DReader/routes/author/widgets/AuthorForm.dart';
import 'package:DReader/routes/book/widgets/FilesItems.dart';
import 'package:DReader/state/book/FilesListState.dart';
import 'package:DReader/widgets/ListWidget.dart';
import 'package:DReader/widgets/ToolBar.dart';
import 'package:DReader/widgets/TopTool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthorContent extends StatefulWidget {
  const AuthorContent({super.key, required this.id});

  final int id;

  @override
  State<AuthorContent> createState() => AuthorContentState();
}

class AuthorContentState extends State<AuthorContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > MyApp.width ? getPc() : getMobile();
      },
    );
  }

  Widget getPc() {
    return Row(
      spacing: 10,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          height: double.infinity,
          child: AuthorDetailPcCard(id: widget.id),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: AuthorBookPcList(id: widget.id),
          ),
        ),
      ],
    );
  }

  Widget getMobile() {
    return AuthorDetailMobile(id: widget.id);
  }
}
