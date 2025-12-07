import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:DReader/entity/author/AuthorItem.dart';
import 'package:DReader/entity/book/FilesDetailsAuthor.dart';
import 'package:DReader/entity/book/FilesDetailsAuthor.dart';
import 'package:flutter/material.dart';

class FilesAuthorBox extends StatefulWidget {
  const FilesAuthorBox({super.key, required this.author});

  final List<FilesDetailsAuthor> author;

  @override
  State<StatefulWidget> createState() => FilesAuthorBoxState();
}

class FilesAuthorBoxState extends State<FilesAuthorBox> {
  List<AuthorItem> items = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void getTagList() async {
    BaseResult<List<AuthorItem>> baseResult =
        await HttpApi.request<List<AuthorItem>>("/author/getAuthorListAll", (
          json,
        ) {
          if (json is List) {
            return json.map((item) => AuthorItem.fromJson(item)).toList();
          }
          return [];
        });
    if (baseResult.code == "2000") {
      if (baseResult.result == null || baseResult.result!.isEmpty) return;
      items = baseResult.result!;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTagList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RawAutocomplete<AuthorItem>(
            textEditingController: _controller,
            displayStringForOption: (AuthorItem opt) => opt.name,
            focusNode: _focusNode,
            optionsBuilder: (TextEditingValue value) {
              return items.where((item) => item.name.contains(value.text));
            },
            onSelected: (AuthorItem value) {
              _controller.clear();
              _focusNode.unfocus();
              if (widget.author.any((t) => t.authorId == value.id)) return;
              int? id;
              widget.author.add(FilesDetailsAuthor(-1, value.name, value.id));
              setState(() {});
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 0,
                    maxHeight: 200,
                  ),
                  child: ListView(
                    children: options.map((opt) {
                      return ListTile(
                        title: Text(opt.name),
                        onTap: () => onSelected(opt),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Wrap(
            children: widget.author
                .map(
                  (item) => Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 5),
                    child: RawChip(
                      label: Text(item.name),
                      onDeleted: () => setState(
                        () => widget.author.removeWhere(
                          (value) => value.authorId == item.authorId,
                        ),
                      ),
                      deleteIcon: const Icon(Icons.delete),
                      deleteIconColor: Colors.redAccent,
                      deleteButtonTooltipMessage: "删除",
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
