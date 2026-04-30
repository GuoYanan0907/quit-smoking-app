import 'package:flutter/material.dart';
import 'dart:math';

/// 境界突破动画
class BreakthroughAnimation extends StatefulWidget {
  final String realmName;
  final String realmIcon;
  final VoidCallback? onComplete;

  const BreakthroughAnimation({
    super.key,
    required this.realmName,
    required this.realmIcon,
    this.onComplete,
  });

  @override
  State<BreakthroughAnimation> createState() => _BreakthroughAnimationState();
}

class _BreakthroughAnimationState extends State<BreakthroughAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final List<Confetti> _confetti = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // 主动画控制器
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 粒子动画控制器
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 文字动画控制器
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // 缩放动画
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // 透明度动画
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 初始化彩带
    for (int i = 0; i < 50; i++) {
      _confetti.add(Confetti(
        x: _random.nextDouble(),
        y: -_random.nextDouble() * 0.5,
        rotation: _random.nextDouble() * pi * 2,
        speed: _random.nextDouble() * 0.02 + 0.01,
        color: [
          const Color(0xFFE6B422), // 金色
          const Color(0xFF4CAF50), // 绿色
          const Color(0xFFFF9800), // 橙色
          const Color(0xFFE91E63), // 粉色
        ][_random.nextInt(4)],
        size: _random.nextDouble() * 8 + 4,
      ));
    }

    // 启动动画
    _mainController.forward();
    _particleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });

    // 动画完成后回调
    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          widget.onComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _particleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: Stack(
        children: [
          // 彩带效果
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(_confetti, _particleController.value),
                size: Size.infinite,
              );
            },
          ),

          // 中心内容
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 境界图标
                        Text(
                          widget.realmIcon,
                          style: const TextStyle(fontSize: 80),
                        ),
                        const SizedBox(height: 20),

                        // 突破文字
                        AnimatedBuilder(
                          animation: _textController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textController.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - _textController.value)),
                                child: Column(
                                  children: [
                                    Text(
                                      '突破成功',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFE6B422),
                                        shadows: [
                                          Shadow(
                                            color: const Color(0xFFE6B422).withValues(alpha:0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      widget.realmName,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: const Color(0xFF4CAF50).withValues(alpha:0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '修为大进，道心稳固',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 彩带类
class Confetti {
  double x;
  double y;
  double rotation;
  double speed;
  Color color;
  double size;

  Confetti({
    required this.x,
    required this.y,
    required this.rotation,
    required this.speed,
    required this.color,
    required this.size,
  });
}

/// 彩带绘制器
class ConfettiPainter extends CustomPainter {
  final List<Confetti> confetti;
  final double progress;

  ConfettiPainter(this.confetti, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var conf in confetti) {
      // 更新位置
      conf.y += conf.speed;
      conf.rotation += 0.1;

      if (conf.y > 1.2) {
        conf.y = -0.2;
        conf.x = Random().nextDouble();
      }

      // 绘制彩带
      final paint = Paint()
        ..color = conf.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(conf.x * size.width, conf.y * size.height);
      canvas.rotate(conf.rotation);

      // 绘制矩形彩带
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: conf.size,
          height: conf.size * 0.4,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
