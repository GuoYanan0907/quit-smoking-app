import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/check_in.dart';
import '../services/storage_service.dart';
import '../widgets/cultivation_background.dart';

/// 打卡页面
class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  CheckInStatus _selectedStatus = CheckInStatus.normal;
  int _cravingLevel = 5;
  final TextEditingController _noteController = TextEditingController();
  List<CheckIn> _checkIns = [];

  @override
  void initState() {
    super.initState();
    _loadCheckIns();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadCheckIns() {
    setState(() {
      _checkIns = StorageService.getCheckIns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CultivationBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('每日修行'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 今日打卡状态
              _buildTodayCheckIn(),
              const SizedBox(height: 20),

              // 打卡表单
              _buildCheckInForm(),
              const SizedBox(height: 20),

              // 打卡历史
              _buildCheckInHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayCheckIn() {
    final today = DateTime.now();
    final todayCheckIn = _checkIns.where((c) =>
        c.date.year == today.year &&
        c.date.month == today.month &&
        c.date.day == today.day);

    final isCheckedIn = todayCheckIn.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCheckedIn
              ? [
                  AppConstants.spiritColor.withValues(alpha:0.9),
                  AppConstants.accentColor.withValues(alpha:0.9),
                ]
              : [
                  AppConstants.primaryColor.withValues(alpha:0.9),
                  AppConstants.secondaryColor.withValues(alpha:0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCheckedIn
              ? AppConstants.spiritColor.withValues(alpha:0.5)
              : AppConstants.goldColor.withValues(alpha:0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (isCheckedIn
                    ? AppConstants.spiritColor
                    : AppConstants.goldColor)
                .withValues(alpha:0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCheckedIn
                    ? AppConstants.goldColor
                    : AppConstants.cloudColor.withValues(alpha:0.5),
                width: 2,
              ),
              boxShadow: isCheckedIn
                  ? [
                      BoxShadow(
                        color: AppConstants.goldColor.withValues(alpha:0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isCheckedIn ? Icons.check_circle : Icons.radio_button_unchecked,
              color: AppConstants.goldColor,
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCheckedIn ? '今日已修行' : '今日未修行',
                  style: TextStyle(
                    fontSize: 22,
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
                const SizedBox(height: 4),
                Text(
                  isCheckedIn
                      ? '状态：${CheckInData.getStatusDescription(todayCheckIn.first.status)}'
                      : '完成修行，记录今日心境',
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
    );
  }

  Widget _buildCheckInForm() {
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
                Icons.edit_note,
                color: AppConstants.goldColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '记录修行',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 状态选择
          _buildSectionTitle('今日心境'),
          const SizedBox(height: 10),
          _buildStatusSelector(),
          const SizedBox(height: 20),

          // 烟瘾程度
          _buildSectionTitle('心魔强度'),
          const SizedBox(height: 10),
          _buildCravingSlider(),
          const SizedBox(height: 20),

          // 日记输入
          _buildSectionTitle('修行日记（选填）'),
          const SizedBox(height: 10),
          _buildNoteInput(),
          const SizedBox(height: 24),

          // 打卡按钮
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _submitCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.goldColor,
                foregroundColor: AppConstants.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
                shadowColor: AppConstants.goldColor.withValues(alpha:0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    '完成修行',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppConstants.goldColor,
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: CheckInStatus.values.map((status) {
        final isSelected = _selectedStatus == status;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedStatus = status;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AppConstants.goldColor.withValues(alpha:0.3),
                        AppConstants.goldColor.withValues(alpha:0.2),
                      ],
                    )
                  : null,
              color: isSelected ? null : AppConstants.backgroundColor.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppConstants.goldColor
                    : AppConstants.cloudColor.withValues(alpha:0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppConstants.goldColor.withValues(alpha:0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  CheckInData.getStatusIcon(status),
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  CheckInData.getStatusDescription(status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppConstants.goldColor
                        : AppConstants.cloudColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCravingSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor.withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.cloudColor.withValues(alpha:0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '心如止水',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.cloudColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _getCravingColor(_cravingLevel).withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getCravingColor(_cravingLevel).withValues(alpha:0.5),
                  ),
                ),
                child: Text(
                  '$_cravingLevel',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _getCravingColor(_cravingLevel),
                    shadows: [
                      Shadow(
                        color: _getCravingColor(_cravingLevel).withValues(alpha:0.5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                '心魔肆虐',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.cloudColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getCravingColor(_cravingLevel),
              inactiveTrackColor: AppConstants.cloudColor.withValues(alpha:0.2),
              thumbColor: _getCravingColor(_cravingLevel),
              overlayColor: _getCravingColor(_cravingLevel).withValues(alpha:0.2),
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _cravingLevel.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (value) {
                setState(() {
                  _cravingLevel = value.round();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCravingColor(int level) {
    if (level <= 3) return AppConstants.spiritColor;
    if (level <= 6) return AppConstants.goldColor;
    return AppConstants.poisonColor;
  }

  Widget _buildNoteInput() {
    return TextField(
      controller: _noteController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: '记录今日修行感悟...',
        hintStyle: TextStyle(
          color: AppConstants.cloudColor.withValues(alpha:0.5),
        ),
        filled: true,
        fillColor: AppConstants.backgroundColor.withValues(alpha:0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppConstants.cloudColor.withValues(alpha:0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppConstants.cloudColor.withValues(alpha:0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppConstants.goldColor,
          ),
        ),
      ),
      style: const TextStyle(
        color: AppConstants.cloudColor,
      ),
    );
  }

  Widget _buildCheckInHistory() {
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
                Icons.history,
                color: AppConstants.goldColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '修行记录',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.goldColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_checkIns.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.book,
                    color: AppConstants.cloudColor.withValues(alpha:0.5),
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '暂无修行记录',
                    style: TextStyle(
                      color: AppConstants.cloudColor.withValues(alpha:0.7),
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(
              _checkIns.length > 7 ? 7 : _checkIns.length,
              (index) {
                final checkIn = _checkIns[_checkIns.length - 1 - index];
                return _buildCheckInItem(checkIn);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCheckInItem(CheckIn checkIn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstants.backgroundColor.withValues(alpha:0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.cloudColor.withValues(alpha:0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(CheckInData.getStatusColor(checkIn.status)).withValues(alpha:0.8),
                    Color(CheckInData.getStatusColor(checkIn.status)).withValues(alpha:0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  CheckInData.getStatusIcon(checkIn.status),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${checkIn.date.month}月${checkIn.date.day}日',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.cloudColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '心魔强度：',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.cloudColor.withValues(alpha:0.7),
                        ),
                      ),
                      Text(
                        '${checkIn.cravingLevel}/10',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getCravingColor(checkIn.cravingLevel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (checkIn.note != null && checkIn.note!.isNotEmpty)
              Icon(
                Icons.note,
                color: AppConstants.goldColor.withValues(alpha:0.7),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  void _submitCheckIn() async {
    final checkIn = CheckIn(
      date: DateTime.now(),
      status: _selectedStatus,
      cravingLevel: _cravingLevel,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      createdAt: DateTime.now(),
    );

    await StorageService.saveCheckIn(checkIn);
    _loadCheckIns();

    // 清空表单
    setState(() {
      _selectedStatus = CheckInStatus.normal;
      _cravingLevel = 5;
      _noteController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('修行记录已完成！'),
            ],
          ),
          backgroundColor: AppConstants.spiritColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
