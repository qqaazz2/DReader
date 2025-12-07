import 'package:json_annotation/json_annotation.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/FilesItem.dart';

part 'BookList.g.dart';

@JsonSerializable()
class BookList extends Object {
  @JsonKey(name: 'limit')
  int limit = 50;

  @JsonKey(name: 'page')
  int page = 0;

  @JsonKey(name: 'pages')
  int pages;

  @JsonKey(name: 'count')
  int count;

  @JsonKey(name: 'data')
  List<BookItem>? data;

  BookList(this.limit, this.page, this.pages, this.count, this.data);

  factory BookList.fromJson(Map<String, dynamic> srcJson) =>
      _$BookListFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BookListToJson(this);

  BookList copyWith({
    List<BookItem>? data,
    int? page,
    int? limit,
    int? pages,
    int? count,
  }) {
    return BookList(
      limit ?? this.limit,
      page ?? this.page,
      pages ?? this.pages,
      count ?? this.count,
      data ?? this.data,
    );
  }
}
