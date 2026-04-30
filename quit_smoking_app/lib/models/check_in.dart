/// 打卡状态
enum CheckInStatus {
  easy, // 轻松
  normal, // 一般
  difficult, // 困难
  veryDifficult, // 很想放弃
}

/// 打卡记录模型
class CheckIn {
  final DateTime date; // 日期
  final CheckInStatus status; // 状态
  final int cravingLevel; // 烟瘾程度 1-10
  final String? note; // 日记/感受
  final List<String> usedMethods; // 使用的排解方法
  final int demonsDefeated; // 击败的心魔数量
  final DateTime createdAt; // 创建时间

  const CheckIn({
    required this.date,
    required this.status,
    required this.cravingLevel,
    this.note,
    this.usedMethods = const [],
    this.demonsDefeated = 0,
    required this.createdAt,
  });

  /// 创建打卡记录副本
  CheckIn copyWith({
    DateTime? date,
    CheckInStatus? status,
    int? cravingLevel,
    String? note,
    List<String>? usedMethods,
    int? demonsDefeated,
    DateTime? createdAt,
  }) {
    return CheckIn(
      date: date ?? this.date,
      status: status ?? this.status,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      note: note ?? this.note,
      usedMethods: usedMethods ?? this.usedMethods,
      demonsDefeated: demonsDefeated ?? this.demonsDefeated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status.index,
      'cravingLevel': cravingLevel,
      'note': note,
      'usedMethods': usedMethods,
      'demonsDefeated': demonsDefeated,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 从JSON创建
  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      date: DateTime.parse(json['date']),
      status: CheckInStatus.values[json['status']],
      cravingLevel: json['cravingLevel'],
      note: json['note'],
      usedMethods: List<String>.from(json['usedMethods'] ?? []),
      demonsDefeated: json['demonsDefeated'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// 打卡数据
class CheckInData {
  /// 获取状态描述
  static String getStatusDescription(CheckInStatus status) {
    switch (status) {
      case CheckInStatus.easy:
        return '轻松';
      case CheckInStatus.normal:
        return '一般';
      case CheckInStatus.difficult:
        return '困难';
      case CheckInStatus.veryDifficult:
        return '很想放弃';
    }
  }

  /// 获取状态图标
  static String getStatusIcon(CheckInStatus status) {
    switch (status) {
      case CheckInStatus.easy:
        return '😊';
      case CheckInStatus.normal:
        return '😐';
      case CheckInStatus.difficult:
        return '😤';
      case CheckInStatus.veryDifficult:
        return '😫';
    }
  }

  /// 获取状态颜色
  static int getStatusColor(CheckInStatus status) {
    switch (status) {
      case CheckInStatus.easy:
        return 0xFF4CAF50; // 绿色
      case CheckInStatus.normal:
        return 0xFFFFC107; // 黄色
      case CheckInStatus.difficult:
        return 0xFFFF9800; // 橙色
      case CheckInStatus.veryDifficult:
        return 0xFFF44336; // 红色
    }
  }

  /// 计算平均烟瘾程度
  static double calculateAverageCraving(List<CheckIn> checkIns) {
    if (checkIns.isEmpty) return 0;
    final total = checkIns.fold(0, (sum, checkIn) => sum + checkIn.cravingLevel);
    return total / checkIns.length;
  }

  /// 计算连续打卡天数
  static int calculateStreak(List<CheckIn> checkIns) {
    if (checkIns.isEmpty) return 0;

    // 按日期排序
    final sortedCheckIns = List<CheckIn>.from(checkIns)
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 1;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 检查今天是否已打卡
    final lastCheckIn = sortedCheckIns.first;
    final lastDate = DateTime(
      lastCheckIn.date.year,
      lastCheckIn.date.month,
      lastCheckIn.date.day,
    );

    if (lastDate != today) {
      return 0; // 今天未打卡
    }

    // 计算连续天数
    for (int i = 1; i < sortedCheckIns.length; i++) {
      final currentDate = DateTime(
        sortedCheckIns[i].date.year,
        sortedCheckIns[i].date.month,
        sortedCheckIns[i].date.day,
      );
      final previousDate = DateTime(
        sortedCheckIns[i - 1].date.year,
        sortedCheckIns[i - 1].date.month,
        sortedCheckIns[i - 1].date.day,
      );

      final difference = previousDate.difference(currentDate).inDays;
      if (difference == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
