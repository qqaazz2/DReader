import 'package:json_annotation/json_annotation.dart';

part 'Tags.g.dart';

@JsonSerializable()
class Tags extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  int id;

  Tags(this.name, this.id);

  factory Tags.fromJson(Map<String, dynamic> srcJson) => _$TagsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TagsToJson(this);
}