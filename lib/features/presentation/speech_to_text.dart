import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interacting_tom/features/providers/openai_response_controller.dart';
import 'package:interacting_tom/features/providers/stt_state_provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STTWidget extends ConsumerStatefulWidget {
  const STTWidget({super.key});

  @override
  ConsumerState<STTWidget> createState() => _STTWidgetState();
}

class _STTWidgetState extends ConsumerState<STTWidget> {
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    updateIsHearing(true);
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      updateIsHearing(false);
      _lastWords = result.recognizedWords;
      ref
          .read(openAIResponseControllerProvider.notifier)
          .getResponse(_lastWords);
      // setState(() {
      //   _lastWords = result.recognizedWords;

      //   print('Last words: $_lastWords');
      //   print('Confidence: ${result.confidence}');
      // });
    }
  }

  void updateIsHearing(bool isHearing) {
    ref.read(isHearingControllerProvider.notifier).toggleHearing(isHearing);
  }

  bool get _isListening => _speechToText.isListening;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(openAIResponseControllerProvider);
    print('STATE: $state');
    return FloatingActionButton(
      onPressed:
          _speechToText.isNotListening ? _startListening : _stopListening,
      tooltip: _isListening ? 'Pause' : 'Play',
      child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
    );
  }
}
