import 'package:json_annotation/json_annotation.dart';
import 'package:DReader/entity/book/SeriesItem.dart';

part 'SeriesList.g.dart';

@JsonSerializable()
class SeriesList extends Object {
  @JsonKey(name: 'limit')
  int limit = 50;

  @JsonKey(name: 'page')
  int page = 1;

  @JsonKey(name: 'pages')
  int pages;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'data')
  List<SeriesItem> data;

  SeriesList(this.limit, this.page, this.pages, this.count, this.data);

  factory SeriesList.fromJson(Map<String, dynamic> srcJson) =>
      _$SeriesListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SeriesListToJson(this);

  SeriesList copyWith({
    List<SeriesItem>? data,
    int? page,
    int? limit,
    int? pages,
    int? count,
  }) {
    return SeriesList(
      limit ?? this.limit,
      page ?? this.page,
      pages ?? this.pages,
      count ?? this.count,
      data ?? this.data,
    );
  }
}
