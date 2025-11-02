import 'package:DReader/common/HttpApi.dart';
import 'package:DReader/entity/BaseResult.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'SettingCountState.g.dart';

@riverpod
class SettingCountState extends _$SettingCountState {
  @override
  Future<Map> build() async {
    BaseResult baseResult = await HttpApi.request(
      "/setting/count",
      (json) => json,
    );
    if (baseResult.code == "2000") {
      return baseResult.result!;
    }
    return {"count": 0, "size": 0};
  }
}
