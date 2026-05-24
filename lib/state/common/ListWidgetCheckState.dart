import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ListWidgetCheckState.g.dart';

@riverpod
class ListWidgetCheckState extends _$ListWidgetCheckState {
  @override
  Set<int> build(String key) {
    return {};
  }

   void toggle(int index) {
    final newState = {...state};
    if (newState.contains(index)) {
      newState.remove(index);
    } else {
      newState.add(index);
    }
    state = newState;
  }

  void clean(){
    state = {};
  }
}
