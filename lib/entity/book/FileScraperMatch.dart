import 'package:json_annotation/json_annotation.dart';

part 'FileScraperMatch.g.dart';

@JsonSerializable()
class FileScraperMatch extends Object {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "selectId")
  int? selectId;

  FileScraperMatch({required this.id, this.selectId});

  factory FileScraperMatch.fromJson(Map<String, dynamic> json) =>
      _$FileScraperMatchFromJson(json);

  Map<String, dynamic> toJson() => _$FileScraperMatchToJson(this);
}
