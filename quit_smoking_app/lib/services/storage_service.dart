import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/check_in.dart';
import '../models/achievement.dart';

/// 本地存储服务
class StorageService {
  static SharedPreferences? _prefs;

  /// 初始化
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 获取戒烟日期
  static DateTime? getQuitDate() {
    final dateStr = _prefs?.getString(AppConstants.keyQuitDate);
    if (dateStr == null) return null;
    return DateTime.parse(dateStr);
  }

  /// 设置戒烟日期
  static Future<bool> setQuitDate(DateTime date) async {
    return await _prefs?.setString(
          AppConstants.keyQuitDate,
          date.toIso8601String(),
        ) ??
        false;
  }

  /// 获取每日吸烟量
  static int getDailyCigarettes() {
    return _prefs?.getInt(AppConstants.keyDailyCigarettes) ?? 20;
  }

  /// 设置每日吸烟量
  static Future<bool> setDailyCigarettes(int count) async {
    return await _prefs?.setInt(
          AppConstants.keyDailyCigarettes,
          count,
        ) ??
        false;
  }

  /// 获取每包烟价格
  static double getCigarettePrice() {
    return _prefs?.getDouble(AppConstants.keyCigarettePrice) ?? 20.0;
  }

  /// 设置每包烟价格
  static Future<bool> setCigarettePrice(double price) async {
    return await _prefs?.setDouble(
          AppConstants.keyCigarettePrice,
          price,
        ) ??
        false;
  }

  /// 获取当前境界等级
  static int getCurrentRealmLevel() {
    return _prefs?.getInt(AppConstants.keyCurrentRealm) ?? 1;
  }

  /// 设置当前境界等级
  static Future<bool> setCurrentRealmLevel(int level) async {
    return await _prefs?.setInt(
          AppConstants.keyCurrentRealm,
          level,
        ) ??
        false;
  }

  /// 获取打卡记录
  static List<CheckIn> getCheckIns() {
    final jsonStr = _prefs?.getString(AppConstants.keyCheckIns);
    if (jsonStr == null) return [];

    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => CheckIn.fromJson(json)).toList();
  }

  /// 保存打卡记录
  static Future<bool> saveCheckIn(CheckIn checkIn) async {
    final checkIns = getCheckIns();

    // 检查今天是否已打卡
    final today = DateTime.now();
    final todayIndex = checkIns.indexWhere((c) =>
        c.date.year == today.year &&
        c.date.month == today.month &&
        c.date.day == today.day);

    if (todayIndex >= 0) {
      // 更新今天的打卡
      checkIns[todayIndex] = checkIn;
    } else {
      // 添加新的打卡
      checkIns.add(checkIn);
    }

    final jsonStr = json.encode(checkIns.map((c) => c.toJson()).toList());
    return await _prefs?.setString(AppConstants.keyCheckIns, jsonStr) ?? false;
  }

  /// 获取成就列表
  static List<Achievement> getAchievements() {
    final jsonStr = _prefs?.getString(AppConstants.keyAchievements);
    if (jsonStr == null) return AchievementData.getAllAchievements();

    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((json) => Achievement.fromJson(json)).toList();
  }

  /// 保存成就列表
  static Future<bool> saveAchievements(List<Achievement> achievements) async {
    final jsonStr =
        json.encode(achievements.map((a) => a.toJson()).toList());
    return await _prefs?.setString(AppConstants.keyAchievements, jsonStr) ??
        false;
  }

  /// 解锁成就
  static Future<bool> unlockAchievement(String achievementId) async {
    final achievements = getAchievements();
    final index = achievements.indexWhere((a) => a.id == achievementId);

    if (index >= 0) {
      achievements[index] = achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      return await saveAchievements(achievements);
    }

    return false;
  }

  /// 获取击败心魔数量
  static int getInnerDemonDefeatedCount() {
    return _prefs?.getInt(AppConstants.keyInnerDemonDefeated) ?? 0;
  }

  /// 增加击败心魔数量
  static Future<bool> incrementInnerDemonDefeated() async {
    final current = getInnerDemonDefeatedCount();
    return await _prefs?.setInt(
          AppConstants.keyInnerDemonDefeated,
          current + 1,
        ) ??
        false;
  }

  /// 计算省钱金额
  static double calculateSavedMoney() {
    final quitDate = getQuitDate();
    if (quitDate == null) return 0;

    final daysPassed = DateTime.now().difference(quitDate).inDays;
    final dailyCigarettes = getDailyCigarettes();
    final cigarettePrice = getCigarettePrice();

    // 每包20支，计算省下的钱
    final packsPerDay = dailyCigarettes / 20;
    final savedMoney = daysPassed * packsPerDay * cigarettePrice;

    return savedMoney;
  }

  /// 清除所有数据
  static Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }

  /// 检查是否已初始化
  static bool isInitialized() {
    return _prefs?.containsKey(AppConstants.keyQuitDate) ?? false;
  }
}
