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
            const SizedBox(height: 12),
            // 有効中のバフをバッジで表示
            Wrap(
              spacing: 8,
              children: [
                if (gameState.isAttackBuffActive)
                  const _BuffBadge(label: '攻撃力2倍', color: Colors.orange),
                if (gameState.isCoinBuffActive)
                  const _BuffBadge(label: 'コイン2倍', color: Colors.amber),
              ],
            ),
            const SizedBox(height: 28),
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
            _AttackText(gameState: gameState),
          ],
        ),
      ),
    );
  }
}

/// 攻撃力の表示。バフ中は「素の値 → 2倍の値」を並べる。
class _AttackText extends StatelessWidget {
  const _AttackText({required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    if (!gameState.isAttackBuffActive) {
      return Text(
        '攻撃力: ${gameState.baseAttack.toStringAsFixed(1)}',
        style: const TextStyle(fontSize: 16),
      );
    }

    return Row(
      children: [
        const Text('攻撃力: ', style: TextStyle(fontSize: 16)),
        Text(
          gameState.baseAttack.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const Text('  →  ', style: TextStyle(fontSize: 16)),
        Text(
          gameState.attack.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// バフ有効中を示す小さなバッジ
class _BuffBadge extends StatelessWidget {
  const _BuffBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}