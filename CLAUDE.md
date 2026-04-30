# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

"这个APP能让你戒烟" — 一款以中国修仙文化为主题的戒烟辅助 Flutter 应用。将 21 天戒烟计划映射为 21 重修仙境界（感气境 → 大罗金仙），通过游戏化机制帮助用户戒烟。

## 常用命令

所有 Flutter 命令需在 `quit_smoking_app/` 子目录下执行：

```bash
cd quit_smoking_app

# 安装依赖
flutter pub get

# 运行应用（Web 为默认开发目标）
flutter run -d chrome

# 静态分析
flutter analyze

# 运行测试
flutter test

# 运行单个测试
flutter test test/widget_test.dart

# 构建
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
flutter build windows    # Windows
```

## 技术栈

- **框架**: Flutter (SDK ^3.11.4)
- **语言**: Dart
- **本地存储**: SharedPreferences（无数据库，所有数据 JSON 序列化后存入 SP）
- **图表**: fl_chart ^0.66.0
- **动画**: Lottie ^3.0.0 + Rive ^0.12.4
- **Lint**: flutter_lints ^6.0.0

## 架构

```
quit_smoking_app/lib/
├── main.dart                    # 入口，MaterialApp + MainScreen（底部导航栏 4 页）
├── constants/
│   └── app_constants.dart       # 颜色主题、SP 键名、应用元信息
├── models/
│   ├── cultivation_realm.dart   # 21 重境界定义（静态数据 + 时间计算工具方法）
│   ├── check_in.dart            # 每日打卡记录模型 + CheckInData 工具类
│   ├── achievement.dart         # 成就模型 + AchievementData 静态成就定义
│   ├── body_recovery.dart       # 身体恢复模型 + BodyRecoveryData 科学数据计算
│   └── inner_demon.dart         # 心魔系统模型 + 抵御方法定义
├── services/
│   └── storage_service.dart     # SharedPreferences 封装，所有数据读写的唯一入口
├── pages/
│   ├── home_page.dart           # 首页：境界卡片、计时器、恢复概览、今日任务
│   ├── check_in_page.dart       # 打卡页：状态选择、烟瘾评分、修行日记
│   ├── stats_page.dart          # 统计页：省钱金额、打卡统计、恢复详情、趋势图
│   ├── profile_page.dart        # 个人页：成就墙、设置（重设/清除/关于）
│   ├── setup_page.dart          # 首次运行设置：戒烟日期、每日吸烟量、烟价
│   └── ascension_page.dart      # 登神长阶：21 重境界纵向列表 + 详情弹窗
└── widgets/
    ├── cultivation_background.dart  # 修仙风格背景（渐变 + 粒子动画）
    ├── breakthrough_animation.dart  # 境界突破动画（缩放 + 彩带）
    └── inner_demon_animation.dart   # 心魔来袭动画（震动 + 脉冲）
```

## 关键设计决策

- **无状态管理库**: 未使用 Provider/Riverpod（README 中提到的计划尚未实现）。页面各自用 `StatefulWidget` 管理状态，通过 `StorageService` 静态方法读写数据。
- **数据持久化**: 全部使用 SharedPreferences，复杂对象（CheckIn、Achievement）通过 `json.encode/decode` 序列化为字符串存储。
- **修仙主题映射**: `CultivationRealms.realms` 是核心静态数据列表，索引 0-20 对应第 1-21 重境界。境界根据戒烟天数自动计算（`getCurrentRealm(quitDate)`）。
- **身体恢复数据**: `BodyRecoveryData` 中的计算方法基于时间差（小时/天/分钟）推算尼古丁清除、血氧恢复等指标，使用修仙术语（烟毒、浊气、灵气、气海、六识、心脉）。
- **深色主题**: 整个应用使用深色 Material 3 主题，主色调为深蓝黑 (`#0D1117`)，金色 (`#E6B422`) 和绿色 (`#4CAF50`) 作为强调色。
