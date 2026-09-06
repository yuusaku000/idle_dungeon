import 'package:flutter/foundation.dart';

/// ゲーム全体の数値を保持するクラス。
/// 画面から独立しているので、タブを切り替えても値は消えない。
class GameState extends ChangeNotifier {
  int floor = 1;        // 現在の階層
  double coins = 0;     // 所持コイン
  double attack = 5;    // 攻撃力

  /// 現在の階層の敵の最大HP
  double get enemyMaxHp => 10 * pow15(floor - 1);

  /// 現在の階層で倒したときに得られるコイン
  double get dropCoin => 5 * pow12(floor - 1);

  // 1.15 の n乗
  double pow15(int n) {
    double result = 1;
    for (int i = 0; i < n; i++) {
      result *= 1.15;
    }
    return result;
  }

  // 1.12 の n乗
  double pow12(int n) {
    double result = 1;
    for (int i = 0; i < n; i++) {
      result *= 1.12;
    }
    return result;
  }
}