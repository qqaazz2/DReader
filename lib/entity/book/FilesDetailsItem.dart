import 'package:DReader/entity/book/FilesDetailsAuthor.dart';
import 'package:json_annotation/json_annotation.dart';

import 'FilesDetailsTag.dart';

part 'FilesDetailsItem.g.dart';

@JsonSerializable()
class FilesDetailsItem extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'overStatus')
  int overStatus;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'love')
  int love;

  @JsonKey(name: 'filesId')
  int filesId;

  @JsonKey(name: 'isFolder')
  int isFolder;

  @JsonKey(name: 'lastReadTime')
  String? lastReadTime;

  @JsonKey(name: 'profile')
  String? profile;

  @JsonKey(name: 'date')
  String? date;

  @JsonKey(name: 'originalName')
  String? originalName;

  @JsonKey(name: 'filePath')
  String filePath;

  @JsonKey(name: 'bgmId')
  int? bgmId;

  @JsonKey(name: 'parentId')
  int parentId;

  @JsonKey(name: 'filesAuthors')
  List<FilesDetailsAuthor> filesAuthors;

  @JsonKey(name: 'filesTags')
  List<FilesDetailsTag> filesTags;

  FilesDetailsItem(
    this.id,
    this.name,
    this.cover,
    this.overStatus,
    this.status,
    this.love,
    this.filesId,
    this.isFolder,
    this.lastReadTime,
    this.profile,
    this.date,
    this.originalName,
    this.filePath,
    this.bgmId,
    this.parentId,
    this.filesAuthors,
    this.filesTags,
  );

  factory FilesDetailsItem.fromJson(Map<String, dynamic> srcJson) =>
      _$FilesDetailsItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesDetailsItemToJson(this);

  FilesDetailsItem copyWith({
    int? id,
    String? name,
    String? cover,
    int? overStatus,
    int? status,
    int? love,
    int? filesId,
    int? isFolder,
    String? lastReadTime,
    String? profile,
    String? date,
    String? originalName,
    String? filePath,
    int? bgmId,
    int? parentId,
    List<FilesDetailsAuthor>? filesAuthors,
    List<FilesDetailsTag>? filesTags,
  }) {
    return FilesDetailsItem(
      id ?? this.id,
      name ?? this.name,
      cover ?? this.cover,
      overStatus ?? this.overStatus,
      status ?? this.status,
      love ?? this.love,
      filesId ?? this.filesId,
      isFolder ?? this.isFolder,
      lastReadTime ?? this.lastReadTime,
      profile ?? this.profile,
      date ?? this.date,
      originalName ?? this.originalName,
      filePath ?? this.filePath,
      bgmId ?? this.bgmId,
      parentId ?? this.parentId,
      filesAuthors ?? this.filesAuthors,
      filesTags ?? this.filesTags,
    );
  }
}
