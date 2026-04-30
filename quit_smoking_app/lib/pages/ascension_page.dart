import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/cultivation_realm.dart';
import '../services/storage_service.dart';
import '../widgets/cultivation_background.dart';

/// 登神长阶页面 - 回首来时路
class AscensionPage extends StatefulWidget {
  const AscensionPage({super.key});

  @override
  State<AscensionPage> createState() => _AscensionPageState();
}

class _AscensionPageState extends State<AscensionPage> {
  DateTime? _quitDate;
  int _currentDay = 0;

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
        _currentDay = DateTime.now().difference(quitDate).inDays + 1;
        if (_currentDay > 21) _currentDay = 21;
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
          title: const Text('登神长阶'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 顶部说明
              _buildHeader(),
              const SizedBox(height: 20),

              // 21重境界长阶
              _buildAscensionStairs(),
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
          title: const Text('登神长阶'),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // 图标
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.goldColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.goldColor.withValues(alpha:0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🏔️',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 标题
          Text(
            '登神长阶',
            style: TextStyle(
              fontSize: 32,
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
          const SizedBox(height: 10),

          // 描述
          const Text(
            '二十一重境界，步步登天\n回首来时路，方知修行不易',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.cloudColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // 当前境界
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppConstants.spiritColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.spiritColor.withValues(alpha:0.5),
              ),
            ),
            child: Text(
              '当前：第 $_currentDay 重境界',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.spiritColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAscensionStairs() {
    return Column(
      children: List.generate(21, (index) {
        final realm = CultivationRealms.realms[index];
        final day = index + 1;
        final isCompleted = day < _currentDay;
        final isCurrent = day == _currentDay;
        final isLocked = day > _currentDay;

        return _buildStairItem(
          realm: realm,
          day: day,
          isCompleted: isCompleted,
          isCurrent: isCurrent,
          isLocked: isLocked,
        );
      }),
    );
  }

  Widget _buildStairItem({
    required CultivationRealm realm,
    required int day,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLocked,
  }) {
    return GestureDetector(
      onTap: () => _showRealmDetail(realm, day, isCompleted, isCurrent),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            // 左侧：境界图标和连接线
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  // 连接线（除了第一个）
                  if (day > 1)
                    Container(
                      width: 2,
                      height: 20,
                      color: isCompleted
                          ? AppConstants.goldColor
                          : AppConstants.cloudColor.withValues(alpha:0.3),
                    ),
                  // 境界图标
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppConstants.goldColor.withValues(alpha:0.3)
                          : isCurrent
                              ? AppConstants.spiritColor.withValues(alpha:0.3)
                              : AppConstants.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppConstants.goldColor
                            : isCurrent
                                ? AppConstants.spiritColor
                                : AppConstants.cloudColor.withValues(alpha:0.3),
                        width: isCurrent ? 3 : 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: AppConstants.spiritColor.withValues(alpha:0.5),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ]
                          : isCompleted
                              ? [
                                  BoxShadow(
                                    color: AppConstants.goldColor.withValues(alpha:0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                    ),
                    child: Center(
                      child: isLocked
                          ? Icon(
                              Icons.lock,
                              color: AppConstants.cloudColor.withValues(alpha:0.5),
                              size: 24,
                            )
                          : Text(
                              realm.icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                    ),
                  ),
                  // 连接线（除了最后一个）
                  if (day < 21)
                    Container(
                      width: 2,
                      height: 20,
                      color: isCompleted
                          ? AppConstants.goldColor
                          : AppConstants.cloudColor.withValues(alpha:0.3),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 右侧：境界信息
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isCompleted
                        ? [
                            AppConstants.goldColor.withValues(alpha:0.2),
                            AppConstants.goldColor.withValues(alpha:0.1),
                          ]
                        : isCurrent
                            ? [
                                AppConstants.spiritColor.withValues(alpha:0.2),
                                AppConstants.spiritColor.withValues(alpha:0.1),
                              ]
                            : [
                                AppConstants.cardColor.withValues(alpha:0.9),
                                AppConstants.cardColor.withValues(alpha:0.8),
                              ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCompleted
                        ? AppConstants.goldColor.withValues(alpha:0.3)
                        : isCurrent
                            ? AppConstants.spiritColor.withValues(alpha:0.3)
                            : AppConstants.cloudColor.withValues(alpha:0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '第 $day 重境界',
                          style: TextStyle(
                            fontSize: 12,
                            color: isCompleted
                                ? AppConstants.goldColor
                                : isCurrent
                                    ? AppConstants.spiritColor
                                    : AppConstants.cloudColor,
                          ),
                        ),
                        if (isCompleted)
                          Icon(
                            Icons.check_circle,
                            color: AppConstants.goldColor,
                            size: 20,
                          ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.spiritColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '修炼中',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      realm.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isLocked
                            ? AppConstants.cloudColor.withValues(alpha:0.5)
                            : AppConstants.goldColor,
                        shadows: isCurrent
                            ? [
                                Shadow(
                                  color: AppConstants.goldColor.withValues(alpha:0.3),
                                  blurRadius: 5,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '称号：${realm.title}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isLocked
                            ? AppConstants.cloudColor.withValues(alpha:0.3)
                            : AppConstants.cloudColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLocked ? '尚未解锁' : realm.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isLocked
                            ? AppConstants.cloudColor.withValues(alpha:0.3)
                            : AppConstants.cloudColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRealmDetail(
    CultivationRealm realm,
    int day,
    bool isCompleted,
    bool isCurrent,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryColor,
              AppConstants.secondaryColor,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: AppConstants.goldColor.withValues(alpha:0.3),
          ),
        ),
        child: Column(
          children: [
            // 拖动条
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppConstants.cloudColor.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstants.goldColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.goldColor.withValues(alpha:0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                realm.icon,
                                style: const TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '第 $day 重境界',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.cloudColor,
                            ),
                          ),
                          Text(
                            realm.name,
                            style: TextStyle(
                              fontSize: 32,
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
                              fontSize: 16,
                              color: AppConstants.cloudColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 境界描述
                    _buildDetailSection('境界描述', realm.description),
                    const SizedBox(height: 20),

                    // 身体状态
                    _buildDetailSection('仙体状态', realm.bodyStatus),
                    const SizedBox(height: 20),

                    // 修炼任务
                    _buildDetailSection('修行任务', realm.tasks.join('\n')),
                    const SizedBox(height: 20),

                    // 境界诗
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.goldColor.withValues(alpha:0.2),
                            AppConstants.goldColor.withValues(alpha:0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
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
                                Icons.auto_stories,
                                color: AppConstants.goldColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '境界诗',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.goldColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            realm.poem,
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppConstants.cloudColor,
                              height: 1.8,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 状态标签
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCompleted
                                ? [
                                    AppConstants.goldColor,
                                    AppConstants.goldColor.withValues(alpha:0.8),
                                  ]
                                : isCurrent
                                    ? [
                                        AppConstants.spiritColor,
                                        AppConstants.spiritColor.withValues(alpha:0.8),
                                      ]
                                    : [
                                        AppConstants.cloudColor.withValues(alpha:0.3),
                                        AppConstants.cloudColor.withValues(alpha:0.2),
                                      ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: isCompleted || isCurrent
                              ? [
                                  BoxShadow(
                                    color: (isCompleted
                                            ? AppConstants.goldColor
                                            : AppConstants.spiritColor)
                                        .withValues(alpha:0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          isCompleted ? '已突破' : isCurrent ? '修炼中' : '未解锁',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isCompleted || isCurrent
                                ? AppConstants.primaryColor
                                : AppConstants.cloudColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: AppConstants.goldColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConstants.goldColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.cloudColor,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
