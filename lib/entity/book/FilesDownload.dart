import 'package:json_annotation/json_annotation.dart';

part 'FilesDownload.g.dart';

@JsonSerializable()
class FilesDownload extends Object {
  @JsonKey(name: 'hash')
  String hash;

  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'cover')
  String? cover;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'filesId')
  String filesId;

  @JsonKey(name: 'progress')
  double progress;

  @JsonKey(name: 'readTagNum')
  int readTagNum;

  @JsonKey(name: 'readStatus')
  int readStatus;

  FilesDownload(
    this.hash,
    this.status,
    this.cover,
    this.name,
    this.filesId,
    this.progress,
    this.readTagNum,
    this.readStatus,
  );

  factory FilesDownload.fromJson(Map<String, dynamic> srcJson) =>
      _$FilesDownloadFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FilesDownloadToJson(this);

  FilesDownload copyWith({
    String? hash,
    int? status,
    String? cover,
    String? name,
    String? filesId,
    double? progress,
    int? readTagNum,
    int? readStatus
  }) {
    return FilesDownload(
      hash ?? this.hash,
      status ?? this.status,
      cover ?? this.cover,
      name ?? this.name,
      filesId ?? this.filesId,
      progress ?? this.progress,
      readTagNum ?? this.readTagNum,
      readStatus ?? this.readStatus,
    );
  }
}
