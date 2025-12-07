import 'package:json_annotation/json_annotation.dart';

part 'BookItem.g.dart';


@JsonSerializable()
class BookItem extends Object {

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'filesId')
  int filesId;

  @JsonKey(name: 'progress')
  double progress;

  @JsonKey(name: 'readTagNum')
  int readTagNum;

  BookItem(this.id,this.filesId,this.progress,this.readTagNum);

  factory BookItem.fromJson(Map<String, dynamic> srcJson) => _$BookItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BookItemToJson(this);

}