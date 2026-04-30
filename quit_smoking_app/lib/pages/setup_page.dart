import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/storage_service.dart';

/// 设置页面（首次运行）
class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int _dailyCigarettes = 20;
  double _cigarettePrice = 20.0;
  DateTime _quitDate = DateTime.now();
  bool _isTodayStart = true; // 是否从今天开始

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修仙准备'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎信息
            Container(
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
                  const Text(
                    '🧘',
                    style: TextStyle(fontSize: 60),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '欢迎踏上修仙之路',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.goldColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '二十一重境界，涤荡烟毒，重铸仙体',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.cloudColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 开始时间选择
            _buildSectionTitle('开坛时辰'),
            const SizedBox(height: 10),
            _buildStartTimeSelector(),
            const SizedBox(height: 20),

            // 每日吸烟量
            _buildSectionTitle('每日吸烟量'),
            const SizedBox(height: 10),
            _buildSlider(
              value: _dailyCigarettes.toDouble(),
              min: 1,
              max: 40,
              divisions: 39,
              label: '$_dailyCigarettes 支',
              onChanged: (value) {
                setState(() {
                  _dailyCigarettes = value.round();
                });
              },
            ),
            const SizedBox(height: 20),

            // 每包烟价格
            _buildSectionTitle('每包烟价格'),
            const SizedBox(height: 10),
            _buildSlider(
              value: _cigarettePrice,
              min: 5,
              max: 100,
              divisions: 19,
              label: '¥${_cigarettePrice.toStringAsFixed(0)}',
              onChanged: (value) {
                setState(() {
                  _cigarettePrice = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // 戒烟日期（如果不是今天开始）
            if (!_isTodayStart) ...[
              _buildSectionTitle('戒烟日期'),
              const SizedBox(height: 10),
              _buildDatePicker(),
              const SizedBox(height: 20),
            ],

            // 开始按钮
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _startCultivation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.goldColor,
                  foregroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _isTodayStart ? '今天开始修仙' : '继续修仙之路',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstants.goldColor,
      ),
    );
  }

  Widget _buildStartTimeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 今天开始
          GestureDetector(
            onTap: () {
              setState(() {
                _isTodayStart = true;
                _quitDate = DateTime.now();
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isTodayStart
                    ? AppConstants.spiritColor.withValues(alpha:0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isTodayStart
                      ? AppConstants.spiritColor
                      : AppConstants.cloudColor.withValues(alpha:0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isTodayStart
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: _isTodayStart
                        ? AppConstants.spiritColor
                        : AppConstants.cloudColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '今日开坛',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isTodayStart
                                ? AppConstants.spiritColor
                                : AppConstants.cloudColor,
                          ),
                        ),
                        const Text(
                          '今日起，踏上修仙之路',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.cloudColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '🌱',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 继续之前的进度
          GestureDetector(
            onTap: () {
              setState(() {
                _isTodayStart = false;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: !_isTodayStart
                    ? AppConstants.goldColor.withValues(alpha:0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: !_isTodayStart
                      ? AppConstants.goldColor
                      : AppConstants.cloudColor.withValues(alpha:0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    !_isTodayStart
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: !_isTodayStart
                        ? AppConstants.goldColor
                        : AppConstants.cloudColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '续接前缘',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !_isTodayStart
                                ? AppConstants.goldColor
                                : AppConstants.cloudColor,
                          ),
                        ),
                        const Text(
                          '若道友已有修行根基，选择起始之日',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.cloudColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '🔄',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.spiritColor,
            ),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppConstants.goldColor,
            inactiveColor: AppConstants.cloudColor.withValues(alpha:0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '${_quitDate.year}年${_quitDate.month}月${_quitDate.day}日',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.spiritColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _quitDate = DateTime.now().subtract(const Duration(days: 1));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentColor,
                ),
                child: const Text('昨天'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _quitDate = DateTime.now().subtract(const Duration(days: 2));
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentColor,
                ),
                child: const Text('前天'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _quitDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _quitDate = date;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentColor,
                ),
                child: const Text('选择日期'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startCultivation() async {
    // 保存设置
    await StorageService.setQuitDate(_quitDate);
    await StorageService.setDailyCigarettes(_dailyCigarettes);
    await StorageService.setCigarettePrice(_cigarettePrice);

    // 返回首页
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isTodayStart ? '修仙之路已开启！' : '继续修仙之路！'),
          backgroundColor: AppConstants.spiritColor,
        ),
      );
    }
  }
}
