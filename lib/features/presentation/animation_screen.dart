import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  Artboard? riveArtboard;
  SMIBool? isHearing;
  SMITrigger? wave;

  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/bear_character.riv').then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          final controller =
              StateMachineController.fromArtboard(artboard, 'State Machine 1');
          if (controller != null) {
            artboard.addController(controller);
            isHearing = controller.findSMI('Hear');
            wave = controller.findSMI('Wave');
            setState(() => riveArtboard = artboard);
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  void _toggleHearing() {
    if (isHearing != null) {
      isHearing!.value = !isHearing!.value;
    } else {
      isHearing!.value = true;
    }
  }

  bool get isHearingValue => isHearing?.value ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: riveArtboard == null
              ? const SizedBox()
              : Rive(
                  artboard: riveArtboard!,
                  fit: BoxFit.cover,
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleHearing,
        tooltip: isHearingValue ? 'Pause' : 'Play',
        child: Icon(
          isHearingValue ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
