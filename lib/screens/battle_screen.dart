import 'package:flutter/material.dart';
import '../game_state.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    final hpRatio =
        (gameState.enemyHp / gameState.enemyMaxHp).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: Text('${gameState.floor} 階')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'コイン: ${gameState.coins.floor()}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            const Icon(Icons.bug_report, size: 96),
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: hpRatio,
              minHeight: 20,
              color: Colors.red,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            Text(
              'HP ${gameState.enemyHp.ceil()} / ${gameState.enemyMaxHp.ceil()}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              '攻撃力: ${gameState.attack.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}