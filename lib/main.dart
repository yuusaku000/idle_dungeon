import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

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
      home: const MainScreen(),
    );
  }
}