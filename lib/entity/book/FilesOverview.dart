import 'package:json_annotation/json_annotation.dart';

part 'FilesOverview.g.dart';


@JsonSerializable()
class FilesOverview extends Object {

  @JsonKey(name: 'seriesCount')
  int seriesCount;
  @JsonKey(name: 'bookCount')
  int bookCount;
  @JsonKey(name: 'overCount')
  int overCount;
  @JsonKey(name: 'unreadCount')
  int unreadCount;
  @JsonKey(name: 'readingCount')
  int readingCount;
  @JsonKey(name: 'loveSeriesCount')
  int loveSeriesCount;
  @JsonKey(name: 'loveBookCount')
  int loveBookCount;
  @JsonKey(name: 'overSeriesCount')
  int overSeriesCount;
  @JsonKey(name: 'unOverSeriesCount')
  int unOverSeriesCount;
  @JsonKey(name: 'discardedSeriesCount')
  int discardedSeriesCount;

  FilesOverview(this.seriesCount,this.bookCount,this.overCount,this.unreadCount,this.readingCount,this.loveSeriesCount,this.loveBookCount,this.overSeriesCount,this.unOverSeriesCount,this.discardedSeriesCount);

  factory FilesOverview.fromJson(Map<String, dynamic> srcJson) => _$FilesOverviewFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesOverviewToJson(this);
}