import 'package:json_annotation/json_annotation.dart';

part 'AuthorDetail.g.dart';

@JsonSerializable()
class AuthorDetail extends Object {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'avatar')
  String? avatar;

  @JsonKey(name: 'profile')
  String? profile;

  @JsonKey(name: 'vocational')
  String? vocational;

  @JsonKey(name: 'bgmId')
  int? bgmId;

  @JsonKey(name: 'date')
  String? date;

  AuthorDetail(this.id, this.name, this.avatar,this.profile,this.vocational,this.bgmId,this.date);

  factory AuthorDetail.fromJson(Map<String, dynamic> srcJson) =>
      _$AuthorDetailFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthorDetailToJson(this);

  AuthorDetail copyWith({
    int? id,
    String? name,
    String? avatar,
    String? profile,
    String? vocational,
    int? bgmId,
    String? date,
  }) {
    return AuthorDetail(
      id ?? this.id,
      name ?? this.name,
      avatar ?? this.avatar,
      profile ?? this.profile,
      vocational ?? this.vocational,
      bgmId ?? this.bgmId,
      date ?? this.date,
    );
  }
}
