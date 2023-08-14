import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interacting_tom/features/providers/animation_state_controller.dart';

class FlagSwitch extends ConsumerWidget {
  const FlagSwitch({super.key});

  void _toggleLanguage(BuildContext context, ref) {
    ref.read(animationStateControllerProvider.notifier).toggleLanguage();
  }

  @override
  Widget build(BuildContext context, ref) {
    final animState = ref.watch(animationStateControllerProvider);
    final isEnglish = animState.language == 'en';
    return FloatingActionButton(
      // add rectangle border shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,

      onPressed: () {
        _toggleLanguage(context, ref);
      },
      child: Flag.fromCode(
        isEnglish ? FlagsCode.US : FlagsCode.JP,
      ),
    );
  }
}
