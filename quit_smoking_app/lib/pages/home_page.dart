import 'package:flutter/material.dart';
import 'dart:async';
import '../constants/app_constants.dart';
import '../models/cultivation_realm.dart';
import '../models/body_recovery.dart';
import '../services/storage_service.dart';
import '../widgets/cultivation_background.dart';
import '../widgets/breakthrough_animation.dart';
import 'ascension_page.dart';

/// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  DateTime? _quitDate;
  CultivationRealm? _currentRealm;
  Map<String, double> _recoveryData = {};
  int _lastDay = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadData() {
    final quitDate = StorageService.getQuitDate();
    if (quitDate != null) {
      final currentDay = DateTime.now().difference(quitDate).inDays + 1;
      setState(() {
        _quitDate = quitDate;
        _currentRealm = CultivationRealms.getCurrentRealm(quitDate);
        _recoveryData = BodyRecoveryData.getAllRecoveryData(quitDate);

        // 检查是否突破新境界
        if (_lastDay > 0 && currentDay > _lastDay && currentDay <= 21) {
          _showBreakthroughAnimation();
        }
        _lastDay = currentDay > 21 ? 21 : currentDay;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _showBreakthroughAnimation() {
    final realm = _currentRealm!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BreakthroughAnimation(
        realmName: realm.name,
        realmIcon: realm.icon,
        onComplete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_quitDate == null) {
      return _buildEmptyState();
    }

    return CultivationBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('修仙戒烟录'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 境界信息卡片
              _buildRealmCard(),
              const SizedBox(height: 16),

              // 计时器卡片
              _buildTimerCard(),
              const SizedBox(height: 16),

              // 身体恢复概览
              _buildRecoveryOverview(),
              const SizedBox(height: 16),

              // 今日任务
              _buildTodayTasks(),
              const SizedBox(height: 16),

              // 登神长阶入口
              _buildAscensionEntry(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return CultivationBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('修仙戒烟录'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🧘',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              Text(
                '道友，请开始你的修仙之路',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '点击下方按钮，踏上戒烟修仙之旅',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.cloudColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRealmCard() {
    final realm = _currentRealm!;
    final progress = CultivationRealms.getProgress(_quitDate!);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withValues(alpha:0.9),
            AppConstants.secondaryColor.withValues(alpha:0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.goldColor.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.goldColor.withValues(alpha:0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // 境界图标和名称
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstants.goldColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.goldColor.withValues(alpha:0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    realm.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '道友境界',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.cloudColor.withValues(alpha:0.7),
                      ),
                    ),
                    Text(
                      realm.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.goldColor,
                        shadows: [
                          Shadow(
                            color: AppConstants.goldColor.withValues(alpha:0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '称号：${realm.title}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppConstants.cloudColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 进度条
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '修仙进度',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.cloudColor.withValues(alpha:0.7),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.goldColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppConstants.cloudColor.withValues(alpha:0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.goldColor),
                  minHeight: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    final daysPassed = CultivationRealms.getDaysPassed(_quitDate!);
    final hoursPassed = CultivationRealms.getHoursPassed(_quitDate!);
    final minutesPassed = CultivationRealms.getMinutesPassed(_quitDate!);
    final secondsPassed = CultivationRealms.getSecondsPassed(_quitDate!);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.spiritColor.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
                color: AppConstants.spiritColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '修炼时长',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit('天', daysPassed),
              _buildTimeUnit('时', hoursPassed % 24),
              _buildTimeUnit('分', minutesPassed % 60),
              _buildTimeUnit('秒', secondsPassed % 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String label, int value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.accentColor.withValues(alpha:0.8),
                AppConstants.primaryColor.withValues(alpha:0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.goldColor.withValues(alpha:0.3),
            ),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppConstants.goldColor,
              shadows: [
                Shadow(
                  color: AppConstants.goldColor.withValues(alpha:0.5),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppConstants.cloudColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.spiritColor.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.healing,
                color: AppConstants.spiritColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '仙体恢复',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(_recoveryData.length, (index) {
            final entry = _recoveryData.entries.elementAt(index);
            return _buildRecoveryItem(entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildRecoveryItem(String name, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.cloudColor,
                ),
              ),
              Text(
                '${progress.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.spiritColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: AppConstants.cloudColor.withValues(alpha:0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.spiritColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTasks() {
    final realm = _currentRealm!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.goldColor.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment,
                color: AppConstants.goldColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '今日修行',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...realm.tasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppConstants.spiritColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task,
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.cloudColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAscensionEntry() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AscensionPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.goldColor.withValues(alpha:0.9),
              AppConstants.goldColor.withValues(alpha:0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppConstants.goldColor.withValues(alpha:0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.primaryColor.withValues(alpha:0.5),
                ),
              ),
              child: const Center(
                child: Text(
                  '🏔️',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '登神长阶',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '回首来时路，步步皆修行',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.primaryColor.withValues(alpha:0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.primaryColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
