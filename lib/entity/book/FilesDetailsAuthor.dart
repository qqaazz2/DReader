import 'package:json_annotation/json_annotation.dart';

part 'FilesDetailsAuthor.g.dart';

@JsonSerializable()
class FilesDetailsAuthor extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'authorId')
  int authorId;

  FilesDetailsAuthor(
    this.id,
    this.name,
    this.authorId,
  );

  factory FilesDetailsAuthor.fromJson(Map<String, dynamic> srcJson) =>
      _$FilesDetailsAuthorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesDetailsAuthorToJson(this);
}
