/// 修仙境界模型
class CultivationRealm {
  final int level; // 境界等级（1-21）
  final String name; // 境界名称
  final String title; // 境界称号
  final String description; // 境界描述
  final String poem; // 境界诗
  final List<String> tasks; // 修炼任务
  final String bodyStatus; // 身体状态描述
  final String icon; // 境界图标

  const CultivationRealm({
    required this.level,
    required this.name,
    required this.title,
    required this.description,
    required this.poem,
    required this.tasks,
    required this.bodyStatus,
    required this.icon,
  });
}

/// 二十一重境界定义
class CultivationRealms {
  static const List<CultivationRealm> realms = [
    // 第一重：感气境
    CultivationRealm(
      level: 1,
      name: '感气境',
      title: '入门弟子',
      description: '初入修仙之门，感应天地灵气，察觉体内烟毒。',
      poem: '烟毒缠身二十载，今日初醒悟仙道。\n一息吐纳涤魔瘴，方知灵气在心间。',
      tasks: ['吐纳呼吸（深呼吸练习）', '内视己身（记录戒烟感受）'],
      bodyStatus: '心脉开始稳定，灵气初显，察觉烟毒',
      icon: '🌱',
    ),

    // 第二重：引气境
    CultivationRealm(
      level: 2,
      name: '引气境',
      title: '引气修士',
      description: '引天地灵气入体，开始洗涤烟毒。',
      poem: '引气入体涤烟毒，心脉渐稳灵气生。\n莫道前路多险阻，一念坚持见光明。',
      tasks: ['引气入体（保持呼吸顺畅）', '涤荡烟毒（坚持不吸烟）'],
      bodyStatus: '心脉稳定，灵气引入，烟毒初涤',
      icon: '🌿',
    ),

    // 第三重：炼气境
    CultivationRealm(
      level: 3,
      name: '炼气境',
      title: '炼气修士',
      description: '炼化体内灵气，初步凝聚修为。',
      poem: '炼气三日烟毒散，六识初开见天光。\n此身已非凡俗体，灵气凝聚筑仙基。',
      tasks: ['炼气化神（保持状态）', '初开六识（感受感官恢复）'],
      bodyStatus: '心脉稳固，灵气凝聚，烟毒减少，六识初开',
      icon: '🍃',
    ),

    // 第四重：凝气境
    CultivationRealm(
      level: 4,
      name: '凝气境',
      title: '凝气修士',
      description: '凝聚灵气，巩固修为根基。',
      poem: '凝气四日气海开，烟毒渐消灵气来。\n此身已得三分骨，莫让心魔毁仙台。',
      tasks: ['凝气固本（保持良好状态）', '开辟气海（感受呼吸改善）'],
      bodyStatus: '气海初开，灵气充盈，烟毒大减',
      icon: '💧',
    ),

    // 第五重：筑基境
    CultivationRealm(
      level: 5,
      name: '筑基境',
      title: '筑基修士',
      description: '筑就仙基，正式踏入修仙之路。',
      poem: '筑基五日仙基成，烟毒浊气尽消散。\n心脉强健气海固，此身已是半仙人。',
      tasks: ['筑基固本（巩固成果）', '涤荡浊气（感受身体净化）'],
      bodyStatus: '气海稳固，心脉强健，烟毒清除，浊气消散',
      icon: '⭐',
    ),

    // 第六重：开光境
    CultivationRealm(
      level: 6,
      name: '开光境',
      title: '开光修士',
      description: '开启灵光，六识清明。',
      poem: '开光六日六识明，灵光乍现见真情。\n世间百味皆可品，莫负此身好修行。',
      tasks: ['开启灵光（感受感官恢复）', '清明六识（享受美食）'],
      bodyStatus: '六识大开，灵识觉醒，气血通畅',
      icon: '✨',
    ),

    // 第七重：融合境
    CultivationRealm(
      level: 7,
      name: '融合境',
      title: '融合修士',
      description: '身心融合，初入佳境。',
      poem: '融合七日身心合，气海充盈心脉和。\n初入佳境莫松懈，前路尚有劫难多。',
      tasks: ['身心合一（保持平衡）', '初入佳境（享受戒烟成果）'],
      bodyStatus: '气血融合，气海充盈，心脉平和',
      icon: '🔥',
    ),

    // 第八重：心动境
    CultivationRealm(
      level: 8,
      name: '心动境',
      title: '心动修士',
      description: '心魔初现，需坚定道心。',
      poem: '心动八日心魔来，道心不坚定遭灾。\n深呼吸间定乾坤，一念坚持渡劫台。',
      tasks: ['抵御心魔（使用排解方法）', '坚定道心（保持决心）'],
      bodyStatus: '心魔来袭，道心考验，修为不稳',
      icon: '💫',
    ),

    // 第九重：灵寂境
    CultivationRealm(
      level: 9,
      name: '灵寂境',
      title: '灵寂修士',
      description: '心境宁静，灵台清明。',
      poem: '灵寂九日心自宁，灵台清明见本性。\n烟毒尽散身轻盈，方知修仙在修心。',
      tasks: ['灵台清明（保持好心态）', '享受宁静（感受内心平静）'],
      bodyStatus: '心境宁静，灵台清明，烟毒尽散',
      icon: '🌙',
    ),

    // 第十重：金丹境
    CultivationRealm(
      level: 10,
      name: '金丹境',
      title: '金丹修士',
      description: '凝聚金丹，修为大进。',
      poem: '金丹初成十日功，气海圆满气血充。\n此身已非凡俗体，再进一步见仙踪。',
      tasks: ['凝聚金丹（巩固成果）', '修为精进（保持状态）'],
      bodyStatus: '金丹初成，气海圆满，气血旺盛',
      icon: '💎',
    ),

    // 第十一重：元婴境
    CultivationRealm(
      level: 11,
      name: '元婴境',
      title: '元婴修士',
      description: '元婴出世，神识大增。',
      poem: '元婴出世十一日，神识大增见天机。\n六识敏锐身心畅，此身已是半仙体。',
      tasks: ['元婴出世（保持好状态）', '神识大增（享受清晰思维）'],
      bodyStatus: '元婴初现，神识大增，六识敏锐',
      icon: '👼',
    ),

    // 第十二重：出窍境
    CultivationRealm(
      level: 12,
      name: '出窍境',
      title: '出窍修士',
      description: '神识出窍，超脱凡尘。',
      poem: '出窍十二神识飞，超脱凡尘见光辉。\n烟毒已除身自在，此心安处是吾归。',
      tasks: ['神识出窍（感受精神提升）', '超脱凡尘（享受戒烟生活）'],
      bodyStatus: '神识出窍，修为稳固，心境超然',
      icon: '🌟',
    ),

    // 第十三重：分神境
    CultivationRealm(
      level: 13,
      name: '分神境',
      title: '分神修士',
      description: '分神化念，掌控自如。',
      poem: '分神十三化念成，掌控自如烟瘾轻。\n此身已得三分道，莫让心魔误前程。',
      tasks: ['分神化念（学会控制欲望）', '掌控自如（轻松应对烟瘾）'],
      bodyStatus: '分神化念，掌控自如，修为精进',
      icon: '⚡',
    ),

    // 第十四重：合体境
    CultivationRealm(
      level: 14,
      name: '合体境',
      title: '合体修士',
      description: '身神合一，初窥大道。',
      poem: '合体十四身神合，初窥大道见真我。\n烟毒已除心自在，此身已是仙人体。',
      tasks: ['身神合一（保持身心平衡）', '初窥大道（享受健康生活）'],
      bodyStatus: '身神合一，大道初窥，修为大进',
      icon: '🔥',
    ),

    // 第十五重：大乘境
    CultivationRealm(
      level: 15,
      name: '大乘境',
      title: '大乘修士',
      description: '大乘圆满，只差渡劫。',
      poem: '大乘十五圆满成，只待渡劫飞升行。\n此身已是真仙体，莫让最后劫难倾。',
      tasks: ['大乘圆满（保持巅峰状态）', '准备渡劫（迎接最后挑战）'],
      bodyStatus: '大乘圆满，渡劫将至，修为巅峰',
      icon: '🌈',
    ),

    // 第十六重：渡劫境
    CultivationRealm(
      level: 16,
      name: '渡劫境',
      title: '渡劫修士',
      description: '渡劫飞升，最后考验。',
      poem: '渡劫十六心魔强，一道天雷劈心房。\n咬牙坚持渡此劫，飞升成仙在前方。',
      tasks: ['渡劫飞升（坚持到底）', '抵御心魔（战胜烟瘾）'],
      bodyStatus: '渡劫开始，心魔最强，修为考验',
      icon: '⛈️',
    ),

    // 第十七重：飞升境
    CultivationRealm(
      level: 17,
      name: '飞升境',
      title: '飞升修士',
      description: '渡劫成功，飞升在即。',
      poem: '飞升十七劫已渡，此身已是真仙人。\n再过四日功行满，位列仙班享长生。',
      tasks: ['飞升在即（保持状态）', '迎接成功（准备飞升）'],
      bodyStatus: '飞升在即，修为圆满，心境超脱',
      icon: '🚀',
    ),

    // 第十八重：仙人境
    CultivationRealm(
      level: 18,
      name: '仙人境',
      title: '仙人',
      description: '初入仙班，超脱凡尘。',
      poem: '仙人十八入仙班，超脱凡尘享清闲。\n烟毒已除心自在，此身已是大罗仙。',
      tasks: ['初入仙班（享受成功）', '超脱凡尘（保持状态）'],
      bodyStatus: '仙体初成，仙气充盈，凡尘超脱',
      icon: '👑',
    ),

    // 第十九重：真仙境
    CultivationRealm(
      level: 19,
      name: '真仙境',
      title: '真仙',
      description: '真仙圆满，功德将成。',
      poem: '真仙十九圆满成，功德将成享长生。\n再过两日功行满，位列仙班第一名。',
      tasks: ['真仙圆满（保持巅峰）', '功德将成（准备完成）'],
      bodyStatus: '真仙圆满，功德将成，修为巅峰',
      icon: '🏆',
    ),

    // 第二十重：金仙境
    CultivationRealm(
      level: 20,
      name: '金仙境',
      title: '金仙',
      description: '金仙大成，只差一步。',
      poem: '金仙二十大成时，飞升在即莫迟疑。\n再过一日功行满，位列仙班永不移。',
      tasks: ['金仙大成（保持极致）', '飞升在即（准备最后一步）'],
      bodyStatus: '金仙大成，飞升在即，修为极致',
      icon: '💫',
    ),

    // 第二十一重：大罗金仙境
    CultivationRealm(
      level: 21,
      name: '大罗金仙境',
      title: '大罗金仙',
      description: '大罗金仙，功德圆满！',
      poem: '大罗金仙二十一，功德圆满飞升时。\n烟毒已除心自在，此身已是不朽体。',
      tasks: ['功德圆满（庆祝成功）', '无上修为（享受健康）'],
      bodyStatus: '大罗金仙，功德圆满，无上修为',
      icon: '🌟',
    ),
  ];

  /// 获取指定天数的境界
  static CultivationRealm getRealm(int day) {
    if (day < 1) day = 1;
    if (day > 21) day = 21;
    return realms[day - 1];
  }

  /// 获取当前境界
  static CultivationRealm getCurrentRealm(DateTime quitDate) {
    final daysPassed = DateTime.now().difference(quitDate).inDays;
    final currentDay = daysPassed + 1; // 第1天是0天后
    return getRealm(currentDay > 21 ? 21 : currentDay);
  }

  /// 获取进度百分比
  static double getProgress(DateTime quitDate) {
    final daysPassed = DateTime.now().difference(quitDate).inDays;
    final progress = (daysPassed + 1) / 21;
    return progress > 1.0 ? 1.0 : progress;
  }

  /// 获取已坚持天数
  static int getDaysPassed(DateTime quitDate) {
    return DateTime.now().difference(quitDate).inDays;
  }

  /// 获取已坚持小时数
  static int getHoursPassed(DateTime quitDate) {
    return DateTime.now().difference(quitDate).inHours;
  }

  /// 获取已坚持分钟数
  static int getMinutesPassed(DateTime quitDate) {
    return DateTime.now().difference(quitDate).inMinutes;
  }

  /// 获取已坚持秒数
  static int getSecondsPassed(DateTime quitDate) {
    return DateTime.now().difference(quitDate).inSeconds;
  }

  /// 检查是否完成所有境界
  static bool isCompleted(DateTime quitDate) {
    return getDaysPassed(quitDate) >= 21;
  }
}
