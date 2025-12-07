import 'package:json_annotation/json_annotation.dart';

part 'FilesDetailsTag.g.dart';

@JsonSerializable()
class FilesDetailsTag extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'tagId')
  int? tagId;

  FilesDetailsTag(
    this.id,
    this.name,
    this.tagId,
  );

  factory FilesDetailsTag.fromJson(Map<String, dynamic> srcJson) =>
      _$FilesDetailsTagFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesDetailsTagToJson(this);
}
