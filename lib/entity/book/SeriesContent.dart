import 'package:json_annotation/json_annotation.dart';
import 'package:DReader/entity/book/BookItem.dart';
import 'package:DReader/entity/book/SeriesItem.dart';


@JsonSerializable()
class SeriesContent extends Object {
  SeriesItem? seriesItem;

  List<BookItem>? bookItem;

  SeriesContent({required this.seriesItem,required this.bookItem});

  SeriesContent copyWith({
    SeriesItem? seriesItem,
    List<BookItem>? bookItem,
  }) {
    return SeriesContent(seriesItem: seriesItem ?? this.seriesItem, bookItem: bookItem ?? this.bookItem);
  }
}
