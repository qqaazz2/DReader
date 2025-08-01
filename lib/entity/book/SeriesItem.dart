import 'package:json_annotation/json_annotation.dart';

part 'SeriesItem.g.dart';

@JsonSerializable()
class SeriesItem extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'author')
  String? author;

  @JsonKey(name: 'overStatus')
  int overStatus;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'love')
  int love;

  @JsonKey(name: 'profile')
  String? profile;

  @JsonKey(name: 'lastReadTime')
  String? lastReadTime;

  @JsonKey(name: 'num')
  int num;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'minioCover')
  String? minioCover;

  @JsonKey(name: 'filesId')
  int filesId;

  SeriesItem(this.id, this.love, this.author, this.cover,this.minioCover, this.lastReadTime, this.name, this.num, this.overStatus, this.profile, this.status,this.filesId);

  factory SeriesItem.fromJson(Map<String, dynamic> srcJson) =>
      _$SeriesItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SeriesItemToJson(this);
}
