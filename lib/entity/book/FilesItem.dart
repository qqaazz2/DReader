import 'package:json_annotation/json_annotation.dart';

part 'FilesItem.g.dart';

@JsonSerializable()
class FilesItem extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  // @JsonKey(name: 'author')
  // String? author;

  @JsonKey(name: 'overStatus')
  int overStatus;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'love')
  int love;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'filesId')
  int filesId;

  @JsonKey(name: 'isFolder')
  int isFolder;

  @JsonKey(name: 'parentId')
  int parentId;

  @JsonKey(name: "filePath")
  String filePath;

  FilesItem(
    this.id,
    this.love,
    this.cover,
    this.name,
    this.overStatus,
    this.status,
    this.filesId,
    this.isFolder,
    this.parentId,
    this.filePath,
  );

  factory FilesItem.fromJson(Map<String, dynamic> srcJson) =>
      _$FilesItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesItemToJson(this);

  @override
  int get hashCode => Object.hash(
    id,
    status,
    love,
    cover,
    overStatus,
    name,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilesItem &&
        other.id == id &&
        other.status == status &&
        other.love == love &&
        other.cover == cover &&
        other.overStatus == overStatus &&
        other.name == name;
  }

  FilesItem copyWith({
    int? id,
    String? name,
    int? overStatus,
    int? status,
    int? love,
    String? cover,
    int? filesId,
    int? isFolder,
    int? parentId,
    String? filePath,
  }) {
    return FilesItem(
      id ?? this.id,
      love ?? this.love,
      cover ?? this.cover,
      name ?? this.name,
      overStatus ?? this.overStatus,
      status ?? this.status,
      filesId ?? this.filesId,
      isFolder ?? this.isFolder,
      parentId ?? this.parentId,
      filePath ?? this.filePath,
    );
  }
}
