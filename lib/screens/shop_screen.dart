import 'package:flutter/material.dart';
import '../game_state.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;

    return Scaffold(
      appBar: AppBar(title: const Text('ショップ')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'コイン: ${state.coins.floor()}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            _BuffCard(
              title: '攻撃力2倍薬',
              subtitle: '3分間、攻撃力が2倍になる',
              cost: GameState.attackBuffCost,
              remaining: state.attackBuffRemaining,
              canAfford: state.coins >= GameState.attackBuffCost,
              onPressed: () {
                setState(() => state.buyAttackBuff());
              },
            ),
            const SizedBox(height: 16),
            _BuffCard(
              title: 'コイン2倍薬',
              subtitle: '3分間、獲得コインが2倍になる',
              cost: GameState.coinBuffCost,
              remaining: state.coinBuffRemaining,
              canAfford: state.coins >= GameState.coinBuffCost,
              onPressed: () {
                setState(() => state.buyCoinBuff());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BuffCard extends StatelessWidget {
  const _BuffCard({
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.remaining,
    required this.canAfford,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final double cost;
  final double remaining;
  final bool canAfford;
  final VoidCallback onPressed;

  /// 秒数を「1:23」形式にする
  String _formatTime(double seconds) {
    final total = seconds.ceil();
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = remaining > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 4),
                    Text(
                      '効果中 残り ${_formatTime(remaining)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ElevatedButton(
              onPressed: canAfford ? onPressed : null,
              child: Text('${cost.ceil()} で購入'),
            ),
          ],
        ),
      ),
    );
  }
}