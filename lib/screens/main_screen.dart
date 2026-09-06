import 'dart:async';
import 'package:flutter/material.dart';
import '../game_state.dart';
import 'home_screen.dart';
import 'battle_screen.dart';
import 'training_screen.dart';
import 'shop_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GameState _gameState = GameState();
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _saveTimer;

  /// ロードが終わるまで true
  bool _loading = true;

  /// ゲームループの間隔（秒）
  static const double _tickInterval = 0.1;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  Future<void> _startGame() async {
    final offlineSeconds = await _gameState.load();

    if (!mounted) return;
    setState(() => _loading = false);

    // オフライン進行があれば知らせる
    if (offlineSeconds > 60) {
      final minutes = (offlineSeconds / 60).floor();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$minutes 分ぶん戦闘が進みました')),
      );
    }

    // ゲームループ開始
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        _gameState.tick(_tickInterval);
      });
    });

    // 10秒ごとに自動セーブ
    _saveTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _gameState.save();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _saveTimer?.cancel();
    _gameState.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final screens = [
      HomeScreen(gameState: _gameState),
      TrainingScreen(gameState: _gameState),
      BattleScreen(gameState: _gameState),
      ShopScreen(gameState: _gameState),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: '育成'),
          NavigationDestination(icon: Icon(Icons.sports_kabaddi), label: 'バトル'),
          NavigationDestination(icon: Icon(Icons.store), label: 'ショップ'),
        ],
      ),
    );
  }
}