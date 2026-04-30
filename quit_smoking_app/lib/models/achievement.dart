/// 成就类型
enum AchievementType {
  realm, // 境界成就
  cultivation, // 修炼成就
  challenge, // 挑战成就
  special, // 特殊成就
}

/// 成就模型
class Achievement {
  final String id; // 成就ID
  final String name; // 成就名称
  final String cultivationName; // 修仙名称
  final String icon; // 图标
  final String description; // 描述
  final AchievementType type; // 类型
  final int requiredCount; // 需要完成的次数
  final bool isUnlocked; // 是否解锁
  final DateTime? unlockedAt; // 解锁时间
  final int currentProgress; // 当前进度

  const Achievement({
    required this.id,
    required this.name,
    required this.cultivationName,
    required this.icon,
    required this.description,
    required this.type,
    required this.requiredCount,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  /// 创建成就副本
  Achievement copyWith({
    String? id,
    String? name,
    String? cultivationName,
    String? icon,
    String? description,
    AchievementType? type,
    int? requiredCount,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? currentProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      cultivationName: cultivationName ?? this.cultivationName,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      type: type ?? this.type,
      requiredCount: requiredCount ?? this.requiredCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cultivationName': cultivationName,
      'icon': icon,
      'description': description,
      'type': type.index,
      'requiredCount': requiredCount,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'currentProgress': currentProgress,
    };
  }

  /// 从JSON创建
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      cultivationName: json['cultivationName'],
      icon: json['icon'],
      description: json['description'],
      type: AchievementType.values[json['type']],
      requiredCount: json['requiredCount'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }
}

/// 成就数据
class AchievementData {
  /// 境界成就
  static const List<Achievement> realmAchievements = [
    Achievement(
      id: 'realm_start',
      name: '初心者',
      cultivationName: '入门弟子',
      icon: '🌱',
      description: '开始戒烟计划',
      type: AchievementType.realm,
      requiredCount: 1,
    ),
    Achievement(
      id: 'realm_3',
      name: '坚持3天',
      cultivationName: '炼气修士',
      icon: '⭐',
      description: '完成第3天',
      type: AchievementType.realm,
      requiredCount: 3,
    ),
    Achievement(
      id: 'realm_7',
      name: '坚持7天',
      cultivationName: '融合修士',
      icon: '🔥',
      description: '完成第1周',
      type: AchievementType.realm,
      requiredCount: 7,
    ),
    Achievement(
      id: 'realm_14',
      name: '坚持14天',
      cultivationName: '合体修士',
      icon: '💫',
      description: '完成第2周',
      type: AchievementType.realm,
      requiredCount: 14,
    ),
    Achievement(
      id: 'realm_21',
      name: '坚持21天',
      cultivationName: '大罗金仙',
      icon: '👑',
      description: '完成全部计划',
      type: AchievementType.realm,
      requiredCount: 21,
    ),
  ];

  /// 修炼成就
  static const List<Achievement> cultivationAchievements = [
    Achievement(
      id: 'cult_breathing_10',
      name: '吐纳小成',
      cultivationName: '吐纳修士',
      icon: '🌬️',
      description: '完成10次深呼吸',
      type: AchievementType.cultivation,
      requiredCount: 10,
    ),
    Achievement(
      id: 'cult_breathing_50',
      name: '吐纳大成',
      cultivationName: '吐纳宗师',
      icon: '🌪️',
      description: '完成50次深呼吸',
      type: AchievementType.cultivation,
      requiredCount: 50,
    ),
    Achievement(
      id: 'cult_meditation_10',
      name: '定心初成',
      cultivationName: '定心修士',
      icon: '🧘',
      description: '完成10次冥想',
      type: AchievementType.cultivation,
      requiredCount: 10,
    ),
    Achievement(
      id: 'cult_meditation_50',
      name: '定心圆满',
      cultivationName: '定心宗师',
      icon: '🪷',
      description: '完成50次冥想',
      type: AchievementType.cultivation,
      requiredCount: 50,
    ),
    Achievement(
      id: 'cult_diary_7',
      name: '日记初成',
      cultivationName: '记录修士',
      icon: '📝',
      description: '写满7篇日记',
      type: AchievementType.cultivation,
      requiredCount: 7,
    ),
    Achievement(
      id: 'cult_diary_21',
      name: '日记圆满',
      cultivationName: '记录宗师',
      icon: '📚',
      description: '写满21篇日记',
      type: AchievementType.cultivation,
      requiredCount: 21,
    ),
  ];

  /// 特殊成就
  static const List<Achievement> specialAchievements = [
    Achievement(
      id: 'special_demon_10',
      name: '心魔克星',
      cultivationName: '除魔修士',
      icon: '🛡️',
      description: '抵御10次心魔',
      type: AchievementType.special,
      requiredCount: 10,
    ),
    Achievement(
      id: 'special_demon_50',
      name: '心魔终结者',
      cultivationName: '除魔宗师',
      icon: '⚔️',
      description: '抵御50次心魔',
      type: AchievementType.special,
      requiredCount: 50,
    ),
    Achievement(
      id: 'special_money_100',
      name: '省钱达人',
      cultivationName: '聚财修士',
      icon: '💰',
      description: '省下100元',
      type: AchievementType.special,
      requiredCount: 100,
    ),
    Achievement(
      id: 'special_money_500',
      name: '省钱大师',
      cultivationName: '聚财宗师',
      icon: '💎',
      description: '省下500元',
      type: AchievementType.special,
      requiredCount: 500,
    ),
    Achievement(
      id: 'special_perfect_day',
      name: '完美一天',
      cultivationName: '无念修士',
      icon: '✨',
      description: '一天烟瘾评分≤2',
      type: AchievementType.special,
      requiredCount: 1,
    ),
    Achievement(
      id: 'special_perfect_week',
      name: '完美一周',
      cultivationName: '无念宗师',
      icon: '🌈',
      description: '一周烟瘾评分≤3',
      type: AchievementType.special,
      requiredCount: 1,
    ),
  ];

  /// 隐藏成就
  static const List<Achievement> hiddenAchievements = [
    Achievement(
      id: 'hidden_restart',
      name: '重修之路',
      cultivationName: '重修修士',
      icon: '🔄',
      description: '中断后重新开始',
      type: AchievementType.special,
      requiredCount: 1,
    ),
    Achievement(
      id: 'hidden_nirvana',
      name: '涅槃重生',
      cultivationName: '涅槃修士',
      icon: '🔥',
      description: '中断后完成21天',
      type: AchievementType.special,
      requiredCount: 1,
    ),
    Achievement(
      id: 'hidden_share',
      name: '传道授业',
      cultivationName: '传道修士',
      icon: '📤',
      description: '邀请朋友使用',
      type: AchievementType.special,
      requiredCount: 1,
    ),
  ];

  /// 获取所有成就
  static List<Achievement> getAllAchievements() {
    return [
      ...realmAchievements,
      ...cultivationAchievements,
      ...specialAchievements,
      ...hiddenAchievements,
    ];
  }

  /// 检查成就是否解锁
  static bool checkAchievementUnlock(
      Achievement achievement, int currentProgress) {
    return currentProgress >= achievement.requiredCount;
  }
}
