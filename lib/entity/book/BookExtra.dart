import 'package:DReader/entity/book/FilesItem.dart';
import 'package:DReader/entity/book/ReadRecord.dart';

class BookExtra {
  ReadRecord? readRecord;
  FilesItem filesItem;
  bool isLocal;

  BookExtra({required this.filesItem, this.readRecord, this.isLocal = false});
}
