import 'package:flutter/material.dart';
import '../game_state.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('育成'));
  }
}