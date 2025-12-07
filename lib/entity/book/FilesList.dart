import 'package:json_annotation/json_annotation.dart';
import 'package:DReader/entity/book/FilesItem.dart';

part 'FilesList.g.dart';

@JsonSerializable()
class FilesList extends Object {
  @JsonKey(name: 'limit')
  int limit = 50;

  @JsonKey(name: 'page')
  int page = 1;

  @JsonKey(name: 'pages')
  int pages;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'data')
  List<FilesItem> data;

  FilesList(this.limit, this.page, this.pages, this.count, this.data);

  factory FilesList.fromJson(Map<String, dynamic> srcJson) =>
      _$FilesListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesListToJson(this);

  FilesList copyWith({
    List<FilesItem>? data,
    int? page,
    int? limit,
    int? pages,
    int? count,
  }) {
    return FilesList(
      limit ?? this.limit,
      page ?? this.page,
      pages ?? this.pages,
      count ?? this.count,
      data ?? this.data,
    );
  }
}
