import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:interacting_tom/features/providers/openai_response_controller.dart';

class TextToSpeech extends ConsumerStatefulWidget {
  const TextToSpeech({super.key, this.child});
  final Widget? child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextToSpeechState();
}

enum TtsState { playing, stopped, paused, continued }

class _TextToSpeechState extends ConsumerState<TextToSpeech> {
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  TtsState ttsState = TtsState.stopped;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    initTts();
  }
  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future<dynamic> _getVoices() async => await flutterTts.getVoices;

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    _getEngines().then((value) => print("engines: $value"));
    _getLanguages().then((value) => print("languages: $value"));
    _getVoices().then((values) => print("voices: ${values}"));

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    // flutterTts.setStartHandler(() {
    //   setState(() {
    //     print("Playing");
    //     ttsState = TtsState.playing;
    //   });
    // });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      print("Complete");
      // setState(() {
      //   
      //   ttsState = TtsState.stopped;
      // });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak(String textToSpeak) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (textToSpeak.isNotEmpty) {
      await flutterTts.speak(textToSpeak);
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  Widget build(BuildContext context) {
    print('Built text to speech');
    ref.listen(openAIResponseControllerProvider, (previous, next) {
      if (previous != next) {
        _speak(next ?? '');
        print('STATE: $next');
      }
    });

    

    return widget.child ?? const SizedBox();
  }
}
