import 'ReadRecord.dart';

class SyncProgressItem extends ReadRecord {
  String hash;

  SyncProgressItem({
    required super.progress,
    required super.readTagNum,
    required this.hash,
  });

  Map<String, dynamic> toJson() => {
    'hash': hash,
    'progress': progress,
    'readTagNum': readTagNum,
  };
}
