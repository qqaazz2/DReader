// import 'package:DReader/common/HttpApi.dart';
// import 'package:DReader/entity/ListData.dart';
// import 'package:DReader/entity/book/BookItem.dart';
// import 'package:DReader/entity/book/BookList.dart';
// import 'package:DReader/entity/book/SeriesCover.dart';
// import 'package:DReader/entity/book/SeriesCoverList.dart';
// import 'package:DReader/entity/book/SeriesItem.dart';
// import 'package:DReader/entity/BaseResult.dart';
// import 'package:DReader/state/home/BookRecentState.dart';
// import 'package:dio/dio.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:http_parser/http_parser.dart';
//
// part 'SeriesContentState.g.dart';
//
// @riverpod
// class SeriesContentState extends _$SeriesContentState {
//   int page = 0;
//   late int seriesId;
//
//   @override
//   SeriesContent build(id) {
//     seriesId = id;
//     return SeriesContent(seriesItem: null, bookItem: []);
//   }
//
//   void getData(int fileId) async {
//     Future.wait([
//       getDetails(seriesId),
//       getBookList(fileId),
//     ]).then((results) {
//       BaseResult baseResult = results[0];
//       BaseResult baseResult1 = results[1];
//       if (baseResult.code == "2000" && baseResult1.code == "2000") {
//         final newList = baseResult1.result!.data;
//         state = SeriesContent(seriesItem: baseResult.result, bookItem: newList);
//       }
//     });
//   }
//
//   Future<BaseResult> getDetails(int id) async {
//     BaseResult baseResult = await HttpApi.request(
//       "/series/getDetails",
//       (json) => SeriesItem.fromJson(json),
//       params: {
//         "id": id,
//       },
//     );
//     return baseResult;
//   }
//
//   Future<BaseResult> getBookList(int fileId) async {
//     BaseResult baseResult = await HttpApi.request(
//       "/book/getList",
//       (json) => BookList.fromJson(json),
//       params: {
//         "page": page,
//         "limit": 1000,
//         "id": fileId,
//       },
//     );
//     return baseResult;
//   }
//
//   void setLove() async {
//     int love = state.seriesItem!.love == 1 ? 2 : 1;
//     BaseResult baseResult =
//         await HttpApi.request("/series/updateLove", () => {}, params: {
//       'id': state.seriesItem!.id,
//       'love': love,
//     });
//     if (baseResult.code == "2000") {
//       state.seriesItem!.love = love;
//       state = SeriesContent(
//           seriesItem: state.seriesItem, bookItem: state.bookItem ?? []);
//     }
//   }
//
//   void setCover(BookItem bookItem) async {
//     BaseResult baseResult =
//         await HttpApi.request("/series/updateCover", () => {}, params: {
//       'id': state.seriesItem!.id,
//       'cover': bookItem.cover,
//     });
//     if (baseResult.code == "2000") {
//       state.seriesItem!.cover = bookItem.cover;
//       // state.seriesItem!.coverPath = bookItem.minioCover;
//       state = SeriesContent(
//           seriesItem: state.seriesItem, bookItem: state.bookItem ?? []);
//     }
//   }
//
//   Future<void> updateData(SeriesItem seriesItem) async {
//     BaseResult baseResult = await HttpApi.request(
//         "/series/updateData", () => {},
//         method: "post", successMsg: true, params: seriesItem.toJson());
//     if (baseResult.code == "2000") {
//       state = state.copyWith(
//           seriesItem: seriesItem, bookItem: state.bookItem ?? []);
//     }
//   }
//
//   Future<SeriesCoverList> getCoverList() async {
//     BaseResult baseResult = await HttpApi.request(
//       "/book/getCoverList",
//       (json) => SeriesCoverList.fromJson(json),
//       params: {
//         "page": page,
//         "size": 8,
//         "id": state.seriesItem!.filesId,
//       },
//     );
//     if (baseResult.code == "2000") {
//       return baseResult.result!;
//     }
//     return SeriesCoverList([]);
//   }
//
//   void updateProgress(BookItem bookItem) async {
//     BaseResult baseResult = await HttpApi.request(
//         "/book/updateProgress", (json) => json,
//         method: "post", successMsg: true, params: bookItem.toJson());
//     if (baseResult.code == "2000" && ref.mounted) {
//       BookItem item = BookItem.fromJson(baseResult.result['book']);
//       state.seriesItem?.status = baseResult.result['status'];
//
//       if (state.bookItem != null && state.bookItem!.isNotEmpty) {
//         int index = 0;
//         for (BookItem value in state.bookItem!) {
//           if (value.id == item.id) break;
//           index++;
//         }
//
//         state.bookItem![index] = item;
//       }
//
//       ref.read(bookRecentStateProvider.notifier).setData(item);
//       state = state.copyWith(seriesItem: state.seriesItem, bookItem: state.bookItem ?? []);
//     }
//   }
//
//   void updateLastReadTime(int seriesId) async {
//     BaseResult baseResult = await HttpApi.request(
//         "/series/updateLastReadTime", (json) => json,
//         successMsg: true, params: {"id": seriesId});
//     if (baseResult.code == "2000" && ref.mounted) {
//       // state.seriesItem?.lastReadTime = baseResult.result;
//       state = state.copyWith(
//           seriesItem: state.seriesItem, bookItem: state.bookItem ?? []);
//     }
//   }
//
//   void changeCover(int id, List<int> bytes, int index) async {
//     FormData formData = FormData.fromMap({
//       "id": id,
//       "file": MultipartFile.fromBytes(bytes,
//           filename: "cover.jpg", contentType: MediaType('image', 'jpeg'))
//     });
//     BaseResult baseResult = await HttpApi.request(
//         "/book/changeCover",
//         method: "post",
//         (json) => json,
//         isLoading: true,
//         successMsg: true,
//         formData: formData);
//     if (baseResult.code == "2000") {
//       if (state.bookItem != null && state.bookItem!.isNotEmpty) {
//         state.bookItem![index].cover = baseResult.result["cover"];
//         // state.bookItem![index].minioCover = baseResult.result["minioUrl"];
//         BookItem? recentBooks = ref.read(bookRecentStateProvider);
//         if (recentBooks != null &&
//             recentBooks.id == state.bookItem![index].id) {
//           ref
//               .read(bookRecentStateProvider.notifier)
//               .setData(state.bookItem![index]);
//         }
//       }
//
//       state = state.copyWith(
//           seriesItem: state.seriesItem, bookItem: state.bookItem ?? []);
//     }
//   }
// }
