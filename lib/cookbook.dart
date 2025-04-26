import 'dart:math' as math;

import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

const _borderRadius = BorderRadius.horizontal(
  left: Radius.circular(6),
  right: Radius.circular(4),
);

const _jointWidthFactor = 0.08;

class Cookbook extends StatefulWidget {
  const Cookbook({
    required this.title,
    required this.color,
    required this.textColor,
    super.key,
  });

  static const maxWidth = 150.0;

  static const aspectRatio = 49 / 60;

  final String title;

  final Color color;

  final Color textColor;

  @override
  State<Cookbook> createState() => _CookbookState();
}

class _CookbookState extends State<Cookbook>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        cursor: SystemMouseCursors.click,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Cookbook.maxWidth),
          child: AspectRatio(
            aspectRatio: Cookbook.aspectRatio,
            child: RepaintBoundary(
              child: MatrixTransition(
                animation: _animation,
                onTransform: (value) {
                  return Matrix4.identity()
                    ..setEntry(3, 2, 1 / -900)
                    ..rotateY((-math.pi / 9) * value)
                    ..scale(1 + .066 * value)
                    ..translate(-8 * value);
                },
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Positioned.fill(
                      child: _Back(color: widget.color),
                    ),
                    const Positioned.fill(
                      child: _Pages(),
                    ),
                    Positioned.fill(
                      child: _Front(
                        title: widget.title,
                        color: widget.color,
                        textColor: widget.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Front extends StatelessWidget {
  const _Front({
    required this.title,
    required this.color,
    required this.textColor,
  });

  final String title;

  final Color color;

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            foregroundPainter: _FrontShadowPainter(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                border: const Border.fromBorderSide(
                  BorderSide(color: Color(0x14000000)),
                ),
                borderRadius: _borderRadius,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    offset: Offset(0, 1),
                    blurRadius: 1,
                  ),
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 4),
                    blurRadius: 8,
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: Color(0x08000000),
                    offset: Offset(0, 16),
                    blurRadius: 24,
                    spreadRadius: -8,
                  ),
                  BoxShadow(
                    color: Color(0x4DFFFFFF),
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    inset: true,
                  ),
                ],
              ),
              child: const Center(),
            ),
          ),
        ),
        Positioned.fill(
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: 1 - _jointWidthFactor,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                style: TextStyle(
                  fontFamily: 'Geist',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.25,
                  letterSpacing: -0.28,
                  color: textColor,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 0.36),
                      blurRadius: 0.5,
                      color: Color.alphaBlend(
                        const Color(0x33FFFFFF),
                        color.withValues(alpha: 0.8),
                      ),
                    ),
                    Shadow(
                      offset: const Offset(-0.29, -0.29),
                      blurRadius: 0.5,
                      color: Color.alphaBlend(
                        const Color(0x33000000),
                        color.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FrontShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final frontRect = Offset.zero & size;

    final rect = Rect.fromLTWH(
      frontRect.left,
      frontRect.top,
      frontRect.width * _jointWidthFactor,
      frontRect.height,
    );
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: _borderRadius.topLeft,
      bottomLeft: _borderRadius.bottomLeft,
    );

    final blackGradientShader = const LinearGradient(
      colors: [
        Color(0x07000000),
        Color(0x1A000000),
        Color(0x00000000),
        Color(0x05000000),
        Color(0x33000000),
        Color(0x80000000),
        Color(0x26000000),
        Color(0x00000000),
      ],
      stops: [0.0, 0.12, 0.30, 0.50, 0.735, 0.7525, 0.8525, 1.0],
    ).createShader(rect);

    final whiteGradientShader = const LinearGradient(
      colors: [
        Color(0x00FFFFFF),
        Color(0x00FFFFFF),
        Color(0x40FFFFFF),
        Color(0x00FFFFFF),
        Color(0x00FFFFFF),
        Color(0x40FFFFFF),
        Color(0x00FFFFFF),
      ],
      stops: [0.0, 0.12, 0.2925, 0.505, 0.7525, 0.91, 1.0],
    ).createShader(rect);

    canvas
      ..drawRRect(
        rrect,
        Paint()
          ..shader = blackGradientShader
          ..blendMode = BlendMode.overlay,
      )
      ..drawRRect(
        rrect,
        Paint()
          ..shader = whiteGradientShader
          ..blendMode = BlendMode.overlay,
      );
  }

  @override
  bool shouldRepaint(_FrontShadowPainter oldDelegate) => false;
}

class _Pages extends StatelessWidget {
  const _Pages();

  @override
  Widget build(BuildContext context) {
    const bookDepth = 43.0;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0)
        ..translate(-bookDepth / 5)
        ..rotateY(math.pi / 2)
        ..translate(bookDepth + 10),
      alignment: Alignment.centerRight,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Align(
          alignment: Alignment.centerRight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFAFAFA),
                ],
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEAEAEA),
                    Color(0xFFEAEAEA),
                    Color(0x00EAEAEA),
                  ],
                  stops: [0.0, 0.5, 1],
                ),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.29,
                child: Center(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 1 / -3000)
        ..translate(0.0, 0, -43),
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: _borderRadius,
        ),
        child: const Center(),
      ),
    );
  }
}
