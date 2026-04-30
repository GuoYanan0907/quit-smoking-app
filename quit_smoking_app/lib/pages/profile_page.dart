import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/achievement.dart';
import '../services/storage_service.dart';
import 'setup_page.dart';

/// 个人资料页面
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? _quitDate;
  List<Achievement> _achievements = [];
  int _demonDefeatedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _quitDate = StorageService.getQuitDate();
      _achievements = StorageService.getAchievements();
      _demonDefeatedCount = StorageService.getInnerDemonDefeatedCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('洞府'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 个人信息卡片
            _buildProfileCard(),
            const SizedBox(height: 16),

            // 成就系统
            _buildAchievements(),
            const SizedBox(height: 16),

            // 设置选项
            _buildSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final daysPassed = _quitDate != null
        ? DateTime.now().difference(_quitDate!).inDays
        : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.secondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 头像
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppConstants.goldColor.withValues(alpha:0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: AppConstants.goldColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '修仙者',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.goldColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _quitDate != null ? '已坚持 $daysPassed 天' : '尚未开始修仙',
            style: const TextStyle(
              fontSize: 16,
              color: AppConstants.cloudColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileStat(
                '击败心魔',
                '$_demonDefeatedCount',
                AppConstants.poisonColor,
              ),
              _buildProfileStat(
                '解锁成就',
                '${_achievements.where((a) => a.isUnlocked).length}',
                AppConstants.goldColor,
              ),
              _buildProfileStat(
                '坚持天数',
                '$daysPassed',
                AppConstants.spiritColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildAchievements() {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '成就墙',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
              Text(
                '$unlockedCount / ${_achievements.length}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppConstants.cloudColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _achievements.length,
            itemBuilder: (context, index) {
              final achievement = _achievements[index];
              return _buildAchievementItem(achievement);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(Achievement achievement) {
    return GestureDetector(
      onTap: () => _showAchievementDetail(achievement),
      child: Container(
        decoration: BoxDecoration(
          color: achievement.isUnlocked
              ? AppConstants.goldColor.withValues(alpha:0.2)
              : AppConstants.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: achievement.isUnlocked
                ? AppConstants.goldColor
                : AppConstants.cloudColor.withValues(alpha:0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 24,
                color: achievement.isUnlocked ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              achievement.cultivationName,
              style: TextStyle(
                fontSize: 8,
                color: achievement.isUnlocked
                    ? AppConstants.goldColor
                    : AppConstants.cloudColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetail(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: Row(
          children: [
            Text(achievement.icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                achievement.name,
                style: const TextStyle(
                  color: AppConstants.goldColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '修仙名称：${achievement.cultivationName}',
              style: const TextStyle(
                color: AppConstants.cloudColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: const TextStyle(
                color: AppConstants.cloudColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.isUnlocked ? '已参悟' : '尚未参悟',
              style: TextStyle(
                color: achievement.isUnlocked
                    ? AppConstants.spiritColor
                    : AppConstants.poisonColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (achievement.isUnlocked && achievement.unlockedAt != null)
              Text(
                '参悟时间：${achievement.unlockedAt!.year}-${achievement.unlockedAt!.month}-${achievement.unlockedAt!.day}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.cloudColor,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '闭关',
              style: TextStyle(
                color: AppConstants.goldColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '仙府设置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.goldColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            '重塑仙基',
            '调整修行参数：日吸烟量、烟价',
            Icons.settings,
            () => _navigateToSetup(),
          ),
          _buildSettingsItem(
            '散功重修',
            '清除修为，重新踏上修仙之路',
            Icons.delete_forever,
            () => _showClearDataDialog(),
          ),
          _buildSettingsItem(
            '仙卷',
            '版本与天道信息',
            Icons.info,
            () => _showAboutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppConstants.goldColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppConstants.cloudColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppConstants.cloudColor.withValues(alpha:0.7),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppConstants.cloudColor,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _navigateToSetup() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetupPage()),
    );
    _loadData();
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: const Text(
          '散功重修',
          style: TextStyle(
            color: AppConstants.goldColor,
          ),
        ),
        content: const Text(
          '此举将散尽修为，灰飞烟灭，道友三思？\n\n此操作不可撤销，将导致：\n- 境界归零\n- 修行记录尽数消散\n- 成就全部清空',
          style: TextStyle(
            color: AppConstants.cloudColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '罢了',
              style: TextStyle(
                color: AppConstants.cloudColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.clearAll();
              if (!context.mounted) return;
              Navigator.pop(context);
              _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('修为已散，可重新踏上修仙之路'),
                  backgroundColor: AppConstants.poisonColor,
                ),
              );
            },
            child: const Text(
              '散功',
              style: TextStyle(
                color: AppConstants.poisonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: Row(
          children: [
            const Text('🧘'),
            const SizedBox(width: 8),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                color: AppConstants.goldColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '版本：${AppConstants.appVersion}',
              style: const TextStyle(
                color: AppConstants.cloudColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '21天修仙戒烟计划\n\n'
              '踏上戒烟修仙之路，\n'
              '历经二十一重境界，\n'
              '涤荡烟毒，重铸仙体。\n\n'
              '数据基于公开医学资料推算，\n'
              '仅供参考，实际情况因人而异。',
              style: TextStyle(
                color: AppConstants.cloudColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '闭关',
              style: TextStyle(
                color: AppConstants.goldColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
