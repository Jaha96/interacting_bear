import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STTWidget extends StatefulWidget {
  const STTWidget({super.key});

  @override
  State<STTWidget> createState() => _STTWidgetState();
}

class _STTWidgetState extends State<STTWidget> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    _isListening = true;
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      print('Is listening: ${_speechToText.isListening}');
      print('Last words: $_lastWords');
      print('Confidence: ${result.confidence}');

    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed:
          _speechToText.isNotListening ? _startListening : _stopListening,
      tooltip: _isListening ? 'Pause' : 'Play',
      child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
    );
  }
}
