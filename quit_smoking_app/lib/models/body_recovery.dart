/// 身体恢复模型
class BodyRecovery {
  final String organName; // 器官名称
  final String icon; // 图标
  final String description; // 描述
  final List<RecoveryStage> stages; // 恢复阶段

  const BodyRecovery({
    required this.organName,
    required this.icon,
    required this.description,
    required this.stages,
  });
}

/// 恢复阶段
class RecoveryStage {
  final String timePoint; // 时间点
  final String description; // 描述
  final String scientificExplanation; // 科学解释
  final List<HealthMetric> metrics; // 数据指标
  final bool isCompleted; // 是否完成

  const RecoveryStage({
    required this.timePoint,
    required this.description,
    required this.scientificExplanation,
    required this.metrics,
    this.isCompleted = false,
  });
}

/// 健康指标
class HealthMetric {
  final String name; // 指标名称
  final double initialValue; // 初始值
  final double currentValue; // 当前值
  final double targetValue; // 目标值
  final String unit; // 单位
  final String trend; // 趋势（上升/下降）

  const HealthMetric({
    required this.name,
    required this.initialValue,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.trend,
  });

  /// 计算进度百分比
  double get progress {
    if (trend == '上升') {
      return (currentValue - initialValue) / (targetValue - initialValue);
    } else {
      return (initialValue - currentValue) / (initialValue - targetValue);
    }
  }
}

/// 身体恢复数据
class BodyRecoveryData {
  /// 烟毒（尼古丁）清除进度
  static double getNicotineProgress(DateTime quitDate) {
    final hoursPassed = DateTime.now().difference(quitDate).inHours;
    // 尼古丁半衰期约2小时，24小时基本清除
    if (hoursPassed >= 24) return 0.0;
    return 1.0 - (hoursPassed / 24);
  }

  /// 浊气（一氧化碳）清除进度
  static double getCarbonMonoxideProgress(DateTime quitDate) {
    final hoursPassed = DateTime.now().difference(quitDate).inHours;
    // 一氧化碳12小时基本清除
    if (hoursPassed >= 12) return 0.0;
    return 1.0 - (hoursPassed / 12);
  }

  /// 灵气（血氧）恢复进度
  static double getBloodOxygenProgress(DateTime quitDate) {
    final hoursPassed = DateTime.now().difference(quitDate).inHours;
    // 8小时血氧恢复正常
    if (hoursPassed >= 8) return 99.0;
    return 90.0 + (hoursPassed / 8) * 9.0;
  }

  /// 气海（肺功能）恢复进度
  static double getLungFunctionProgress(DateTime quitDate) {
    final daysPassed = DateTime.now().difference(quitDate).inDays;
    // 21天肺功能提升约50%
    if (daysPassed >= 21) return 100.0;
    return 60.0 + (daysPassed / 21) * 40.0;
  }

  /// 六识（味觉/嗅觉）恢复进度
  static double getSensoryProgress(DateTime quitDate) {
    final daysPassed = DateTime.now().difference(quitDate).inDays;
    // 7天开始明显改善，21天基本恢复
    if (daysPassed >= 21) return 95.0;
    if (daysPassed >= 7) return 70.0 + ((daysPassed - 7) / 14) * 25.0;
    return 50.0 + (daysPassed / 7) * 20.0;
  }

  /// 心脉（心率）恢复进度
  static double getHeartRateProgress(DateTime quitDate) {
    final minutesPassed = DateTime.now().difference(quitDate).inMinutes;
    // 20分钟心率恢复正常
    if (minutesPassed >= 20) return 100.0;
    return 70.0 + (minutesPassed / 20) * 30.0;
  }

  /// 获取所有恢复数据
  static Map<String, double> getAllRecoveryData(DateTime quitDate) {
    return {
      '烟毒浓度': getNicotineProgress(quitDate),
      '浊气含量': getCarbonMonoxideProgress(quitDate),
      '灵气浓度': getBloodOxygenProgress(quitDate),
      '气海容量': getLungFunctionProgress(quitDate),
      '六识灵敏': getSensoryProgress(quitDate),
      '心脉稳定': getHeartRateProgress(quitDate),
    };
  }

  /// 获取恢复描述
  static String getRecoveryDescription(String organ, double progress) {
    if (progress >= 90) return '恢复良好';
    if (progress >= 70) return '明显改善';
    if (progress >= 50) return '正在恢复';
    if (progress >= 30) return '初步改善';
    return '开始恢复';
  }
}
