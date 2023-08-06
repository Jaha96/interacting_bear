import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stt_state_provider.g.dart';

@riverpod
class IsHearingController extends _$IsHearingController {
  @override
  bool build() {
    return false;
  }

  void toggleHearing(bool newState) {
    state = newState;
  }
}
