import 'package:json_annotation/json_annotation.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/SeriesItem.dart';


part 'SeriesCover.g.dart';

@JsonSerializable()
class SeriesCover extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'coverId')
  int coverId;

  @JsonKey(name: 'coverPath')
  String coverPath;


  SeriesCover(this.id, this.name, this.coverId, this.coverPath,);

  factory SeriesCover.fromJson(Map<String, dynamic> srcJson) =>
      _$SeriesCoverFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SeriesCoverToJson(this);
}
