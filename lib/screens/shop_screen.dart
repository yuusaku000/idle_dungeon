import 'package:flutter/material.dart';
import '../game_state.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('ショップ'));
  }
}