import 'package:flutter/material.dart';
import '../game_state.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;

    return Scaffold(
      appBar: AppBar(title: const Text('育成')),
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
            _UpgradeCard(
              title: '攻撃力',
              currentValue: state.attack.toStringAsFixed(1),
              cost: state.attackUpgradeCost,
              canAfford: state.coins >= state.attackUpgradeCost,
              isMaxed: false,
              onPressed: () {
                setState(() => state.upgradeAttack());
              },
            ),
            const SizedBox(height: 16),
            _UpgradeCard(
              title: '攻撃速度',
              currentValue: '${state.attackSpeed.toStringAsFixed(1)} 回/秒',
              cost: state.speedUpgradeCost,
              canAfford: state.coins >= state.speedUpgradeCost,
              isMaxed: state.isSpeedMaxed,
              onPressed: () {
                setState(() => state.upgradeSpeed());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({
    required this.title,
    required this.currentValue,
    required this.cost,
    required this.canAfford,
    required this.isMaxed,
    required this.onPressed,
  });

  final String title;
  final String currentValue;
  final double cost;
  final bool canAfford;
  final bool isMaxed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
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
                    '現在: $currentValue',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: (isMaxed || !canAfford) ? null : onPressed,
              child: Text(isMaxed ? 'MAX' : '${cost.ceil()} で強化'),
            ),
          ],
        ),
      ),
    );
  }
}