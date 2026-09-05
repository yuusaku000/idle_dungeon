import 'package:flutter/material.dart';

void main() {
  runApp(const IdleDungeonApp());
}

class IdleDungeonApp extends StatelessWidget {
  const IdleDungeonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idle Dungeon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Idle Dungeon')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MenuButton(
              label: '育成',
              onPressed: () => debugPrint('育成が押されました'),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'バトル',
              onPressed: () => debugPrint('バトルが押されました'),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'ショップ',
              onPressed: () => debugPrint('ショップが押されました'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}