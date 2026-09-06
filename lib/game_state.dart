/// ゲーム全体の数値を保持するクラス。
/// 画面から独立しているので、タブを切り替えても値は消えない。
class GameState {
  int floor = 1;         // 現在の階層
  double coins = 0;      // 所持コイン
  double attack = 5;     // 攻撃力
  double enemyHp = 10;   // 敵の現在HP

  /// 現在の階層の敵の最大HP
  double get enemyMaxHp => 10 * _pow(1.15, floor - 1);

  /// 現在の階層で倒したときに得られるコイン
  double get dropCoin => 5 * _pow(1.12, floor - 1);

  /// 1回攻撃する。敵を倒したら true を返す。
  bool attackOnce() {
    enemyHp -= attack;
    if (enemyHp <= 0) {
      coins += dropCoin;
      floor++;
      enemyHp = enemyMaxHp;
      return true;
    }
    return false;
  }

  /// base の exponent 乗
  double _pow(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}