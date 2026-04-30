/// 心魔等级
enum InnerDemonLevel {
  level1, // 杂念
  level2, // 心猿
  level3, // 意马
  level4, // 贪念
  level5, // 嗔念
}

/// 心魔模型
class InnerDemon {
  final String name; // 心魔名称
  final InnerDemonLevel level; // 心魔等级
  final int intensity; // 强度 1-5
  final String cause; // 出现原因
  final DateTime appearedAt; // 出现时间
  final bool isDefeated; // 是否被击败
  final String? defeatMethod; // 抵御方法
  final DateTime? defeatedAt; // 击败时间

  const InnerDemon({
    required this.name,
    required this.level,
    required this.intensity,
    required this.cause,
    required this.appearedAt,
    this.isDefeated = false,
    this.defeatMethod,
    this.defeatedAt,
  });

  /// 创建心魔副本
  InnerDemon copyWith({
    String? name,
    InnerDemonLevel? level,
    int? intensity,
    String? cause,
    DateTime? appearedAt,
    bool? isDefeated,
    String? defeatMethod,
    DateTime? defeatedAt,
  }) {
    return InnerDemon(
      name: name ?? this.name,
      level: level ?? this.level,
      intensity: intensity ?? this.intensity,
      cause: cause ?? this.cause,
      appearedAt: appearedAt ?? this.appearedAt,
      isDefeated: isDefeated ?? this.isDefeated,
      defeatMethod: defeatMethod ?? this.defeatMethod,
      defeatedAt: defeatedAt ?? this.defeatedAt,
    );
  }
}

/// 抵御心魔的方法
class DemonDefeatMethod {
  final String name; // 方法名称
  final String icon; // 图标
  final String description; // 描述
  final int effectiveness; // 效果 1-5
  final String instruction; // 指导说明

  const DemonDefeatMethod({
    required this.name,
    required this.icon,
    required this.description,
    required this.effectiveness,
    required this.instruction,
  });
}

/// 心魔系统数据
class InnerDemonData {
  /// 心魔等级定义
  static const Map<InnerDemonLevel, Map<String, dynamic>> levelData = {
    InnerDemonLevel.level1: {
      'name': '杂念',
      'icon': '💭',
      'intensity': 1,
      'description': '微弱的烟瘾念头',
    },
    InnerDemonLevel.level2: {
      'name': '心猿',
      'icon': '🐒',
      'intensity': 2,
      'description': '难以控制的烟瘾',
    },
    InnerDemonLevel.level3: {
      'name': '意马',
      'icon': '🐎',
      'intensity': 3,
      'description': '强烈的吸烟欲望',
    },
    InnerDemonLevel.level4: {
      'name': '贪念',
      'icon': '😈',
      'intensity': 4,
      'description': '难以抗拒的诱惑',
    },
    InnerDemonLevel.level5: {
      'name': '嗔念',
      'icon': '👿',
      'intensity': 5,
      'description': '极度强烈的烟瘾',
    },
  };

  /// 抵御心魔的方法
  static const List<DemonDefeatMethod> defeatMethods = [
    DemonDefeatMethod(
      name: '吐纳功',
      icon: '🌬️',
      description: '深呼吸练习',
      effectiveness: 3,
      instruction: '闭上眼睛，深吸一口气，慢慢吐出。\n重复5-10次，感受气息流动。',
    ),
    DemonDefeatMethod(
      name: '定心诀',
      icon: '🧘',
      description: '冥想静心',
      effectiveness: 4,
      instruction: '找一个安静的地方，闭上眼睛。\n专注于呼吸，让思绪平静下来。',
    ),
    DemonDefeatMethod(
      name: '转念术',
      icon: '📖',
      description: '转移注意力',
      effectiveness: 3,
      instruction: '做其他事情转移注意力：\n- 听音乐\n- 看书\n- 散步\n- 和朋友聊天',
    ),
    DemonDefeatMethod(
      name: '甘露法',
      icon: '💧',
      description: '喝水缓解',
      effectiveness: 2,
      instruction: '喝一杯温水，慢慢品味。\n水可以帮助缓解烟瘾。',
    ),
    DemonDefeatMethod(
      name: '金刚咒',
      icon: '📿',
      description: '励志语录',
      effectiveness: 3,
      instruction: '默念励志语录：\n"一念坚持，万魔皆散"\n"我比烟瘾更强大"',
    ),
  ];

  /// 根据戒烟天数获取心魔出现概率
  static double getDemonProbability(int daysPassed) {
    if (daysPassed <= 3) return 0.8; // 第1-3天：心魔频繁
    if (daysPassed <= 7) return 0.5; // 第4-7天：心魔减少
    if (daysPassed <= 14) return 0.3; // 第8-14天：心魔偶发
    return 0.1; // 第15-21天：心魔罕见
  }

  /// 根据戒烟天数获取心魔等级
  static InnerDemonLevel getDemonLevel(int daysPassed) {
    if (daysPassed <= 3) return InnerDemonLevel.level3;
    if (daysPassed <= 7) return InnerDemonLevel.level2;
    if (daysPassed <= 14) return InnerDemonLevel.level1;
    return InnerDemonLevel.level1;
  }

  /// 获取心魔出现原因
  static String getDemonCause() {
    final causes = [
      '饭后',
      '压力大',
      '看到别人吸烟',
      '无聊',
      '喝酒',
      '早上起床',
      '工作间隙',
      '社交场合',
    ];
    return causes[DateTime.now().millisecond % causes.length];
  }

  /// 创建心魔
  static InnerDemon createDemon(int daysPassed) {
    final level = getDemonLevel(daysPassed);
    final levelInfo = levelData[level]!;

    return InnerDemon(
      name: levelInfo['name'],
      level: level,
      intensity: levelInfo['intensity'],
      cause: getDemonCause(),
      appearedAt: DateTime.now(),
    );
  }
}
