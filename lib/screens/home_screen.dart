import 'package:flutter/material.dart';
import '../game_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _confirmPrestige() async {
    final state = widget.gameState;

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('リセットしますか？'),
        content: Text(
          '攻撃力に +${state.pendingPrestigeBonus.toStringAsFixed(0)}% の'
          '永久ボーナスを獲得します。\n\n'
          '階層・コイン・強化はすべて失われます。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('やめる'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('リセットする'),
          ),
        ],
      ),
    );

    if (ok == true && mounted) {
      setState(() => state.prestige());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;

    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // キャラクター表示（後で差し替え）
            const Center(
              child: Icon(Icons.person, size: 120, color: Colors.deepPurple),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StatRow(label: '現在の階層', value: '${state.floor} 階'),
                    const Divider(),
                    _StatRow(label: '最高到達階層', value: '${state.maxFloor} 階'),
                    const Divider(),
                    _StatRow(
                      label: '永久ボーナス',
                      value: '+${state.prestigeBonus.toStringAsFixed(0)}%',
                    ),
                    const Divider(),
                    _StatRow(label: 'リセット回数', value: '${state.prestigeCount} 回'),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (state.canPrestige)
              Text(
                '今リセットすると +${state.pendingPrestigeBonus.toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              )
            else
              Text(
                '${GameState.minPrestigeFloor} 階以上でリセットできます',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: state.canPrestige ? _confirmPrestige : null,
                child: const Text('リセット', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}