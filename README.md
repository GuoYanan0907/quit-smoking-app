# 这个APP能让你戒烟

一款以中国修仙文化为主题的戒烟辅助 Flutter 应用。将 21 天戒烟计划映射为 21 重修仙境界（感气境 -> 大罗金仙），通过游戏化机制帮助用户戒烟。

## 功能特性

- **修仙境界系统** - 21 天对应 21 重境界，随戒烟天数自动突破
- **每日打卡** - 记录戒烟状态、烟瘾评分、修行日记
- **身体恢复追踪** - 基于科学数据展示尼古丁清除、血氧恢复等指标
- **成就系统** - 多种成就解锁，激励持续戒烟
- **心魔抵御** - 烟瘾来袭时提供抵御方法和正念引导
- **登神长阶** - 21 重境界纵向总览，查看进度和详情
- **省钱统计** - 记录节省的香烟数量和金额

## 技术栈

- **框架**: Flutter (SDK ^3.11.4)
- **语言**: Dart
- **本地存储**: SharedPreferences
- **图表**: fl_chart
- **动画**: Lottie + Rive

## 项目结构

```
quit_smoking_app/lib/
├── main.dart                    # 入口
├── constants/app_constants.dart # 颜色主题、常量
├── models/                      # 数据模型
│   ├── cultivation_realm.dart   # 21 重境界
│   ├── check_in.dart            # 打卡记录
│   ├── achievement.dart         # 成就定义
│   ├── body_recovery.dart       # 身体恢复数据
│   └── inner_demon.dart         # 心魔系统
├── services/
│   └── storage_service.dart     # 数据存储服务
├── pages/                       # 页面
│   ├── home_page.dart           # 首页
│   ├── check_in_page.dart       # 打卡页
│   ├── stats_page.dart          # 统计页
│   ├── profile_page.dart        # 个人页
│   ├── setup_page.dart          # 首次设置
│   └── ascension_page.dart      # 登神长阶
└── widgets/                     # 组件
    ├── cultivation_background.dart
    ├── breakthrough_animation.dart
    └── inner_demon_animation.dart
```

## 快速开始

```bash
cd quit_smoking_app

# 安装依赖
flutter pub get

# 运行
flutter run

# 构建
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
flutter build windows    # Windows
```

## 设计理念

- **深色主题**: 深蓝黑底色 (#0D1117)，金色 (#E6B422) 和绿色 (#4CAF50) 点缀
- **修仙术语**: 烟毒、浊气、灵气、气海、六识、心脉等概念融入健康数据
- **无后端依赖**: 所有数据本地存储，无需联网

## License

MIT
