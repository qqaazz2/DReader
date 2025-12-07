import 'package:json_annotation/json_annotation.dart';

part 'AuthorItem.g.dart';

@JsonSerializable()
class AuthorItem extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'avatar')
  String? avatar;

  AuthorItem(this.id, this.name, this.avatar);

  factory AuthorItem.fromJson(Map<String, dynamic> srcJson) =>
      _$AuthorItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthorItemToJson(this);
}
