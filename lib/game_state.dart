/// ゲーム全体の数値と進行を管理するクラス。
/// 画面から独立しているので、どのタブを開いていても戦闘は進む。
class GameState {
  int floor = 1;              // 現在の階層
  double coins = 0;           // 所持コイン
  double enemyHp = 10;        // 敵の現在HP

  int attackLevel = 0;        // 攻撃力の強化回数
  int speedLevel = 0;         // 攻撃速度の強化回数

  /// 前回の攻撃から経過した秒数の蓄積
  double _attackTimer = 0;

  /// 攻撃力（初期5、強化ごとに+2）
  double get attack => 5 + attackLevel * 2;

  /// 攻撃速度（初期1.0回/秒、強化ごとに+0.1、上限3.0）
  double get attackSpeed {
    final speed = 1.0 + speedLevel * 0.1;
    return speed > 3.0 ? 3.0 : speed;
  }

  /// 攻撃1回にかかる秒数
  double get attackInterval => 1.0 / attackSpeed;

  /// 攻撃力強化のコスト
  double get attackUpgradeCost => 10 * _pow(1.15, attackLevel);

  /// 攻撃速度強化のコスト
  double get speedUpgradeCost => 50 * _pow(1.3, speedLevel);

  /// 速度が上限に達しているか
  bool get isSpeedMaxed => attackSpeed >= 3.0;

  /// 現在の階層の敵の最大HP
  double get enemyMaxHp => 10 * _pow(1.15, floor - 1);

  /// 現在の階層で倒したときに得られるコイン
  double get dropCoin => 5 * _pow(1.12, floor - 1);

  /// 時間を進める。deltaSeconds 秒ぶんの戦闘を処理する。
  void tick(double deltaSeconds) {
    _attackTimer += deltaSeconds;
    // 攻撃間隔ぶん溜まっている限り攻撃する
    while (_attackTimer >= attackInterval) {
      _attackTimer -= attackInterval;
      _attackOnce();
    }
  }

  /// 1回攻撃する
  void _attackOnce() {
    enemyHp -= attack;
    if (enemyHp <= 0) {
      coins += dropCoin;
      floor++;
      enemyHp = enemyMaxHp;
    }
  }

  /// 攻撃力を強化する。成功したら true。
  bool upgradeAttack() {
    if (coins < attackUpgradeCost) return false;
    coins -= attackUpgradeCost;
    attackLevel++;
    return true;
  }

  /// 攻撃速度を強化する。成功したら true。
  bool upgradeSpeed() {
    if (isSpeedMaxed) return false;
    if (coins < speedUpgradeCost) return false;
    coins -= speedUpgradeCost;
    speedLevel++;
    return true;
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