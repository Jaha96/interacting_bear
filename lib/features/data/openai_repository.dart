import 'package:dart_openai/dart_openai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openai_repository.g.dart';

class OpenAIRepository {
  OpenAIRepository(this._openAI);
  final OpenAI _openAI;

  List<OpenAIChatCompletionChoiceMessageModel> context = [
    const OpenAIChatCompletionChoiceMessageModel(
      content:
          """
            You're a friendly polar bear who loves to chat with kids aged 3-5, 
            just like the Talking Tom app. They'll ask you questions and you'll have a 
            chat together, using simple words. Keep it short and exciting! Use clear grammar 
            for those learning English. Remember, you're their buddy, not an assistant. 
            Don't be shy to start a conversation if they just say something. Ask them easy questions 
            like their name, if they like kindergarten, their age, favorite superhero, color, drawing, 
            cars, and dinosaurs. Let's have a blast! Respond in Japanese if they speak Japanese, and in 
            English if they speak to you in English. The language can change in each chat.
            - Your response must be two or three sentences only.
          """,
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
