import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/body_recovery.dart';
import '../models/check_in.dart';
import '../services/storage_service.dart';
import '../widgets/cultivation_background.dart';

/// 统计页面
class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime? _quitDate;
  List<CheckIn> _checkIns = [];
  Map<String, double> _recoveryData = {};
  double _savedMoney = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final quitDate = StorageService.getQuitDate();
    if (quitDate != null) {
      setState(() {
        _quitDate = quitDate;
        _checkIns = StorageService.getCheckIns();
        _recoveryData = BodyRecoveryData.getAllRecoveryData(quitDate);
        _savedMoney = StorageService.calculateSavedMoney();
      });
    }
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
          title: const Text('修行统计'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 省钱统计
              _buildMoneyCard(),
              const SizedBox(height: 16),

              // 打卡统计
              _buildCheckInStats(),
              const SizedBox(height: 16),

              // 身体恢复详情
              _buildRecoveryDetails(),
              const SizedBox(height: 16),

              // 烟瘾趋势
              _buildCravingTrend(),
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
          title: const Text('修行统计'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            '道友，请先开始修仙之路',
            style: TextStyle(
              fontSize: 18,
              color: AppConstants.cloudColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoneyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '💰',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(width: 10),
              Text(
                '聚财成果',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '¥${_savedMoney.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
              shadows: [
                Shadow(
                  color: AppConstants.primaryColor.withValues(alpha:0.3),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '已省下的烟钱',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.primaryColor.withValues(alpha:0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInStats() {
    final streak = CheckInData.calculateStreak(_checkIns);
    final averageCraving = CheckInData.calculateAverageCraving(_checkIns);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.goldColor.withValues(alpha:0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: AppConstants.goldColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '修行统计',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('连续修行', '$streak天', AppConstants.spiritColor),
              _buildStatItem(
                '平均心魔',
                averageCraving.toStringAsFixed(1),
                _getCravingColor(averageCraving.round()),
              ),
              _buildStatItem('总修行', '${_checkIns.length}次', AppConstants.goldColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha:0.5),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: [
                Shadow(
                  color: color.withValues(alpha:0.5),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppConstants.cloudColor,
          ),
        ),
      ],
    );
  }

  Color _getCravingColor(int level) {
    if (level <= 3) return AppConstants.spiritColor;
    if (level <= 6) return AppConstants.goldColor;
    return AppConstants.poisonColor;
  }

  Widget _buildRecoveryDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.spiritColor.withValues(alpha:0.3),
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
                '仙体恢复详情',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(_recoveryData.length, (index) {
            final entry = _recoveryData.entries.elementAt(index);
            return _buildRecoveryDetailItem(entry.key, entry.value);
          }),
        ],
      ),
    );
  }

  Widget _buildRecoveryDetailItem(String name, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.cloudColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.spiritColor.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.spiritColor.withValues(alpha:0.5),
                  ),
                ),
                child: Text(
                  '${progress.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.spiritColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: AppConstants.cloudColor.withValues(alpha:0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.spiritColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            BodyRecoveryData.getRecoveryDescription(name, progress),
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.spiritColor.withValues(alpha:0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCravingTrend() {
    if (_checkIns.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppConstants.cardColor.withValues(alpha:0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.goldColor.withValues(alpha:0.3),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.show_chart,
                color: AppConstants.cloudColor.withValues(alpha:0.5),
                size: 48,
              ),
              const SizedBox(height: 8),
              const Text(
                '暂无修行数据',
                style: TextStyle(
                  color: AppConstants.cloudColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 获取最近7天的打卡数据
    final recentCheckIns = _checkIns.length > 7
        ? _checkIns.sublist(_checkIns.length - 7)
        : _checkIns;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.goldColor.withValues(alpha:0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_down,
                color: AppConstants.goldColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '近7天心魔趋势',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: recentCheckIns.map((checkIn) {
                final height = (checkIn.cravingLevel / 10) * 180;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCravingColor(checkIn.cravingLevel).withValues(alpha:0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${checkIn.cravingLevel}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getCravingColor(checkIn.cravingLevel),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _getCravingColor(checkIn.cravingLevel),
                            _getCravingColor(checkIn.cravingLevel).withValues(alpha:0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: _getCravingColor(checkIn.cravingLevel).withValues(alpha:0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${checkIn.date.day}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.cloudColor,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
