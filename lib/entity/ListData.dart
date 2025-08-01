import 'package:json_annotation/json_annotation.dart';

part 'ListData.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ListData<T> extends Object {
  @JsonKey(name: 'limit')
  int limit = 50;

  @JsonKey(name: 'page')
  int page = 0;

  @JsonKey(name: 'pages')
  int pages;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'data')
  List<T>? data;

  ListData(this.limit, this.page, this.pages, this.count, this.data);

  factory ListData.fromJson(
      Map<String, dynamic> srcJson,
      T Function(dynamic json) fromJsonT,
      ) =>
      _$ListDataFromJson<T>(srcJson, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$ListDataToJson(this,toJsonT);

  ListData<T> copyWith({
    List<T>? data,
    int? page,
    int? limit,
    int? pages,
    int? count,
  }) {
    return ListData<T>(
      limit ?? this.limit,
      page ?? this.page,
      pages ?? this.pages,
      count ?? this.count,
      data ?? this.data,
    );
  }
}