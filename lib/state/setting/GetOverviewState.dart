import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'GetOverviewState.g.dart';

@riverpod
class GetOverviewState extends _$GetOverviewState {
  @override
  Future<Map> build() async {
    BaseResult<Map> baseResult = await HttpApi.request<Map>(
      "/book/getOverview",
      (json) => json,
    );
    Map<String, int> map = {"已读": 0, "未读": 0, "在读": 0, "合计": 0};
    if (baseResult.code == "2000") {
      map["已读"] = baseResult.result?['overCount'] ?? 0;
      map["未读"] = baseResult.result?['unreadCount'] ?? 0;
      map["在读"] = baseResult.result?['readingCount'] ?? 0;
      map["合计"] = baseResult.result?['bookCount'] ?? 0;
    }

    return map;
  }
}
