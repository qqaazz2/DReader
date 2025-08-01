import 'package:json_annotation/json_annotation.dart';

part 'LoginCode.g.dart';
@JsonSerializable()
class LoginCode extends Object {

  @JsonKey(name: 'img')
  String img;

  @JsonKey(name: 'key')
  String key;

  LoginCode(this.img,this.key,);

  factory LoginCode.fromJson(Map<String, dynamic> srcJson) => _$LoginCodeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginCodeToJson(this);

  }
