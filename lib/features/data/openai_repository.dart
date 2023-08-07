import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_repository.g.dart';

class OpenAIRepository {
  OpenAIRepository(this._openAI);
  final OpenAI _openAI;

  List<OpenAIChatCompletionChoiceMessageModel> context = [
    const OpenAIChatCompletionChoiceMessageModel(
      content:
          "The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.",
      role: OpenAIChatMessageRole.system,
    )
  ];

  Future<OpenAIChatCompletionModel> fetchChatCompletion(
      List<OpenAIChatCompletionChoiceMessageModel> messages,
      {String model = 'gpt-3.5-turbo',
      double temperature = 1}) {
    return _openAI.chat.create(
      model: model,
      messages: messages,
      temperature: temperature,
    );
  }

  Future<String> fetchAnswer(String prompt) {
    context.add(OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user, content: prompt));

    final response = fetchChatCompletion(context).then((value) {
      context.add(value.choices.first.message);
      return value.choices.first.message.content;
    });

    return response;
  }
}

@Riverpod(keepAlive: true)
OpenAIRepository openAIRepostitory(OpenAIRepostitoryRef ref) {
  return OpenAIRepository(OpenAI.instance);
}

@riverpod
Future<String> chatCompletionFuture(
    ChatCompletionFutureRef ref, String prompt) {
  final openAIRepository = ref.read(openAIRepostitoryProvider);
  return openAIRepository.fetchAnswer(prompt);
}
