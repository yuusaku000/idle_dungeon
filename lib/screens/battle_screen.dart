import 'dart:async';
import 'package:flutter/material.dart';
import '../game_state.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 1秒ごとに自動攻撃する
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        widget.gameState.attackOnce();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final hpRatio = (state.enemyHp / state.enemyMaxHp).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: Text('${state.floor} 階')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'コイン: ${state.coins.floor()}',
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
              'HP ${state.enemyHp.ceil()} / ${state.enemyMaxHp.ceil()}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Text(
              '攻撃力: ${state.attack.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}