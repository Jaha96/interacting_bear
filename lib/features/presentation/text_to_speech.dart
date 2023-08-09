import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:interacting_tom/features/providers/animation_state_controller.dart';
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

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
      updateTalkingAnimation(false);
      // setState(() {
      //
      //   ttsState = TtsState.stopped;
      // });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        updateTalkingAnimation(false);
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      updateTalkingAnimation(false);
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      updateTalkingAnimation(false);
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      updateTalkingAnimation(false);
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  void updateTalkingAnimation(bool isTalking) {
    ref
        .read(animationStateControllerProvider.notifier)
        .updateTalking(isTalking);
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
      updateTalkingAnimation(true);
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
