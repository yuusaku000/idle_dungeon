import 'package:shared_preferences/shared_preferences.dart';

/// ゲーム全体の数値と進行を管理するクラス。
/// 画面から独立しているので、どのタブを開いていても戦闘は進む。
class GameState {
  int floor = 1;              // 現在の階層
  double coins = 0;           // 所持コイン
  double enemyHp = 10;        // 敵の現在HP

  int attackLevel = 0;        // 攻撃力の強化回数
  int speedLevel = 0;         // 攻撃速度の強化回数

  /// リセットで得た永久バフの合計（% 単位。50 なら +50%）
  double prestigeBonus = 0;

  /// 到達した最高階層
  int maxFloor = 1;

  /// リセット回数
  int prestigeCount = 0;

  /// 前回の攻撃から経過した秒数の蓄積
  double _attackTimer = 0;

  /// バフの残り秒数
  double attackBuffRemaining = 0;
  double coinBuffRemaining = 0;

  /// バフの効果時間（秒）
  static const double buffDuration = 180; // 3分

  /// バフの価格
  static const double attackBuffCost = 100;
  static const double coinBuffCost = 100;

  /// オフライン進行の上限（秒）＝ 8時間
  static const double maxOfflineSeconds = 8 * 60 * 60;

  /// リセットできる最低階層
  static const int minPrestigeFloor = 10;

  /// バフが有効か
  bool get isAttackBuffActive => attackBuffRemaining > 0;
  bool get isCoinBuffActive => coinBuffRemaining > 0;

  /// 今リセットしたら得られるボーナス（%）
  double get pendingPrestigeBonus => floor.toDouble();

  /// リセット可能か
  bool get canPrestige => floor >= minPrestigeFloor;

  /// バフを含まない素の攻撃力（永久バフは含む）
  double get baseAttack {
    final double raw = 5.0 + attackLevel * 2;
    return raw * (1 + prestigeBonus / 100);
  }

  /// 実際に戦闘で使う攻撃力（バフ中は2倍）
  double get attack => isAttackBuffActive ? baseAttack * 2 : baseAttack;

  /// 攻撃速度（初期1.0回/秒、強化ごとに+0.1、上限3.0）
  double get attackSpeed {
    final double speed = 1.0 + speedLevel * 0.1;
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

  /// バフを含まない素のドロップコイン
  double get baseDropCoin => 5 * _pow(1.12, floor - 1);

  /// 実際に得られるコイン（バフ中は2倍）
  double get dropCoin => isCoinBuffActive ? baseDropCoin * 2 : baseDropCoin;

  /// 時間を進める。deltaSeconds 秒ぶんの戦闘を処理する。
  void tick(double deltaSeconds) {
    // バフの残り時間を減らす
    if (attackBuffRemaining > 0) {
      attackBuffRemaining -= deltaSeconds;
      if (attackBuffRemaining < 0) attackBuffRemaining = 0;
    }
    if (coinBuffRemaining > 0) {
      coinBuffRemaining -= deltaSeconds;
      if (coinBuffRemaining < 0) coinBuffRemaining = 0;
    }

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
      if (floor > maxFloor) maxFloor = floor;
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

  /// 攻撃力2倍薬を買う。成功したら true。
  bool buyAttackBuff() {
    if (coins < attackBuffCost) return false;
    coins -= attackBuffCost;
    attackBuffRemaining = buffDuration;
    return true;
  }

  /// コイン2倍薬を買う。成功したら true。
  bool buyCoinBuff() {
    if (coins < coinBuffCost) return false;
    coins -= coinBuffCost;
    coinBuffRemaining = buffDuration;
    return true;
  }

  /// リセットして永久バフを獲得する。成功したら true。
  bool prestige() {
    if (!canPrestige) return false;

    prestigeBonus += pendingPrestigeBonus;
    prestigeCount++;

    // 失うもの
    floor = 1;
    coins = 0;
    attackLevel = 0;
    speedLevel = 0;
    attackBuffRemaining = 0;
    coinBuffRemaining = 0;
    _attackTimer = 0;
    enemyHp = enemyMaxHp;

    return true;
  }

  // ---------- セーブ / ロード ----------

  /// 現在の状態を端末に保存する
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('floor', floor);
    await prefs.setDouble('coins', coins);
    await prefs.setDouble('enemyHp', enemyHp);
    await prefs.setInt('attackLevel', attackLevel);
    await prefs.setInt('speedLevel', speedLevel);
    await prefs.setDouble('attackBuffRemaining', attackBuffRemaining);
    await prefs.setDouble('coinBuffRemaining', coinBuffRemaining);
    await prefs.setDouble('prestigeBonus', prestigeBonus);
    await prefs.setInt('maxFloor', maxFloor);
    await prefs.setInt('prestigeCount', prestigeCount);
    // 保存した時刻をミリ秒で記録（オフライン計算に使う）
    await prefs.setInt('savedAt', DateTime.now().millisecondsSinceEpoch);
  }

  /// 保存された状態を読み込み、離れていた時間ぶん進める。
  /// 戻り値は「オフラインで経過した秒数」（初回起動なら 0）。
  Future<double> load() async {
    final prefs = await SharedPreferences.getInstance();

    final savedAt = prefs.getInt('savedAt');
    if (savedAt == null) {
      // セーブデータなし（初回起動）
      return 0;
    }

    floor = prefs.getInt('floor') ?? 1;
    coins = prefs.getDouble('coins') ?? 0;
    enemyHp = prefs.getDouble('enemyHp') ?? 10;
    attackLevel = prefs.getInt('attackLevel') ?? 0;
    speedLevel = prefs.getInt('speedLevel') ?? 0;
    attackBuffRemaining = prefs.getDouble('attackBuffRemaining') ?? 0;
    coinBuffRemaining = prefs.getDouble('coinBuffRemaining') ?? 0;
    prestigeBonus = prefs.getDouble('prestigeBonus') ?? 0;
    maxFloor = prefs.getInt('maxFloor') ?? 1;
    prestigeCount = prefs.getInt('prestigeCount') ?? 0;

    // 離れていた秒数を計算
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    double elapsed = (nowMs - savedAt) / 1000.0;

    if (elapsed < 0) elapsed = 0; // 端末の時刻が巻き戻された場合の保険
    if (elapsed > maxOfflineSeconds) elapsed = maxOfflineSeconds;

    if (elapsed > 0) {
      tick(elapsed);
    }
    return elapsed;
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