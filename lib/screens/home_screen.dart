import 'package:flutter/material.dart';
import '../game_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('ホーム（キャラ表示予定）'));
  }
}