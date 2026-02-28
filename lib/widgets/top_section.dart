import 'package:flutter/material.dart';
import 'dart:math' as math;

class TopSection extends StatefulWidget {
  const TopSection({super.key});

  @override
  State<TopSection> createState() => _TopSectionState();
}

class _TopSectionState extends State<TopSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A3028),
            Color(0xFF0F1F18),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF4ADE80).withOpacity(0.12),
          width: 1,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: -40 + 30 * math.sin(_controller.value * 2 * math.pi),
                top: -40 + 20 * math.cos(_controller.value * 2 * math.pi),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4ADE80).withOpacity(0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          Positioned(
            right: -20,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF4ADE80).withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -50,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.04),
                  width: 1,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: _DotGridPainter(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF4ADE80).withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Color(0xFF4ADE80),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Idea DEPT.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Idea Generator',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.4),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '1000 curated app ideas\nat your fingertips',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.4),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => false;
}