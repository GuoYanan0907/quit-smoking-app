import 'package:flutter/material.dart';
import 'dart:math';

/// 心魔来袭动画
class InnerDemonAnimation extends StatefulWidget {
  final String demonName;
  final String demonIcon;
  final int intensity;
  final VoidCallback? onDefeat;
  final VoidCallback? onFail;

  const InnerDemonAnimation({
    super.key,
    required this.demonName,
    required this.demonIcon,
    required this.intensity,
    this.onDefeat,
    this.onFail,
  });

  @override
  State<InnerDemonAnimation> createState() => _InnerDemonAnimationState();
}

class _InnerDemonAnimationState extends State<InnerDemonAnimation>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDefeated = false;

  @override
  void initState() {
    super.initState();

    // 震动动画
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    // 脉冲动画
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 淡出动画
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _defeat() {
    setState(() {
      _isDefeated = true;
    });
    _shakeController.stop();
    _pulseController.stop();
    _fadeController.forward().then((_) {
      widget.onDefeat?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _isDefeated ? _fadeAnimation.value : 1.0,
          child: Material(
            color: Colors.black87,
            child: Stack(
              children: [
                // 背景烟雾效果
                CustomPaint(
                  painter: SmokePainter(),
                  size: Size.infinite,
                ),

                // 心魔内容
                Center(
                  child: AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 心魔图标
                                  Text(
                                    widget.demonIcon,
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                  const SizedBox(height: 20),

                                  // 心魔名称
                                  Text(
                                    '心魔来袭',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF9C27B0),
                                      shadows: [
                                        Shadow(
                                          color: const Color(0xFF9C27B0).withValues(alpha:0.5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    widget.demonName,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: const Color(0xFFF44336).withValues(alpha:0.5),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '强度：${'★' * widget.intensity}${'☆' * (5 - widget.intensity)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFFF9800),
                                    ),
                                  ),
                                  const SizedBox(height: 30),

                                  // 抵御按钮
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildDefeatButton('降魔', Icons.shield, _defeat),
                                      _buildDefeatButton('遁走', Icons.close, () {
                                        widget.onFail?.call();
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefeatButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: text == '降魔'
                ? [const Color(0xFF4CAF50), const Color(0xFF2E7D32)]
                : [const Color(0xFFF44336), const Color(0xFFC62828)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (text == '降魔'
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336))
                  .withValues(alpha:0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 烟雾绘制器
class SmokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      final paint = Paint()
        ..color = const Color(0xFF9C27B0).withValues(alpha:0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 50 + 20,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
