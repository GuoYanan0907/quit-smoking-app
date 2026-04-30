import 'package:flutter/material.dart';
import 'dart:math';

/// 修仙风格背景组件
class CultivationBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;

  const CultivationBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  State<CultivationBackground> createState() => _CultivationBackgroundState();
}

class _CultivationBackgroundState extends State<CultivationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // 初始化粒子
    for (int i = 0; i < 30; i++) {
      _particles.add(_createParticle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Particle _createParticle() {
    return Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 4 + 1,
      speed: _random.nextDouble() * 0.001 + 0.0005,
      opacity: _random.nextDouble() * 0.5 + 0.1,
      color: _random.nextBool()
          ? const Color(0xFFE6B422) // 金色
          : const Color(0xFF4CAF50), // 绿色
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景渐变
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D1117), // 深蓝黑
                Color(0xFF161B22), // 深蓝
                Color(0xFF1A1A2E), // 深紫
              ],
            ),
          ),
        ),

        // 粒子效果
        if (widget.showParticles)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_particles),
                size: Size.infinite,
              );
            },
          ),

        // 内容
        widget.child,
      ],
    );
  }
}

/// 粒子类
class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}

/// 粒子绘制器
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // 更新粒子位置
      particle.y -= particle.speed;
      if (particle.y < -0.1) {
        particle.y = 1.1;
        particle.x = Random().nextDouble();
      }

      // 绘制粒子
      final paint = Paint()
        ..color = particle.color.withValues(alpha:particle.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
