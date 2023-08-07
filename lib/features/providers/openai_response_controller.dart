import 'package:interacting_tom/features/data/openai_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_response_controller.g.dart';

@riverpod
class OpenAIResponseController extends _$OpenAIResponseController {
  @override
  build() {
    // no-op
    return null;
  }

  void getResponse(String prompt) async {
    final openAIRepository = ref.read(openAIRepostitoryProvider);

    state = const AsyncLoading();
    final responseValue = await AsyncValue.guard(() async {
      return openAIRepository.fetchAnswer(prompt);
    });

    responseValue.when(
        data: (data) => state = data,
        error: (error, stackTrace) => print(error),
        loading: () => null);
  }
}
