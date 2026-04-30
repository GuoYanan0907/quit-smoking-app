import 'package:flutter/material.dart';

/// 应用常量
class AppConstants {
  // 应用信息
  static const String appName = '这个APP能让你戒烟';
  static const String appVersion = '1.0.0';
  static const String appDescription = '21天修仙戒烟计划';

  // 修仙境界总数
  static const int totalDays = 21;

  // 颜色主题
  static const Color primaryColor = Color(0xFF1A1A2E);
  static const Color secondaryColor = Color(0xFF16213E);
  static const Color accentColor = Color(0xFF0F3460);
  static const Color goldColor = Color(0xFFE6B422);
  static const Color spiritColor = Color(0xFF4CAF50);
  static const Color poisonColor = Color(0xFF9C27B0);
  static const Color cloudColor = Color(0xFFE0E0E0);
  static const Color backgroundColor = Color(0xFF0D1117);
  static const Color cardColor = Color(0xFF161B22);

  // 本地存储键名
  static const String keyQuitDate = 'quit_date';
  static const String keyDailyCigarettes = 'daily_cigarettes';
  static const String keyCigarettePrice = 'cigarette_price';
  static const String keyCurrentRealm = 'current_realm';
  static const String keyAchievements = 'achievements';
  static const String keyCheckIns = 'check_ins';
  static const String keyInnerDemonDefeated = 'inner_demon_defeated';
}
