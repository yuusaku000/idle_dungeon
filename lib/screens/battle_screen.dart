import 'package:flutter/material.dart';
import '../game_state.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('バトル'));
  }
}