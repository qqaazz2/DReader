import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';

@JsonSerializable()
class UserInfo extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'mystery')
  int mystery;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'minioCover')
  String? minioCover;


  UserInfo(this.name, this.email, this.mystery,this.cover,this.minioCover);

  factory UserInfo.fromJson(Map<String, dynamic> srcJson) => _$UserInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  UserInfo copyWith({
    String? name,
    String? email,
    int? mystery,
    String? cover,
    String? minioCover,
  }) {
    return UserInfo(
      name ?? this.name,
      email ?? this.email,
      mystery ?? this.mystery,
      cover?? this.cover,
      minioCover ?? this.minioCover
    );
  }
}