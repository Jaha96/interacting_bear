import 'package:flutter/material.dart';
import 'package:interacting_tom/features/presentation/animation_screen.dart';
import 'package:interacting_tom/features/presentation/speech_to_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('home screen built');
    return const Scaffold(
      body: AnimationScreen(),
      floatingActionButton: STTWidget(),
    );
  }
}
