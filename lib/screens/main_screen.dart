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

  @override
  Widget build(BuildContext context) {
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