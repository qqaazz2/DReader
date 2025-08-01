import 'package:json_annotation/json_annotation.dart';

import 'SeriesCover.dart';

part 'SeriesCoverList.g.dart';

@JsonSerializable()
class SeriesCoverList extends Object {
  List<SeriesCover>? list;

  SeriesCoverList(this.list);

  factory SeriesCoverList.fromJson(Map<String, dynamic> srcJson) =>
      _$SeriesCoverListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SeriesCoverListToJson(this);
}