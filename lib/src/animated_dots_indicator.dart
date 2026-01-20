import 'package:flutter/material.dart';

/// An animated dots page indicator for galleries.
class AnimatedDotsIndicator extends StatelessWidget {
  /// Total number of pages.
  final int count;

  /// Current page index.
  final int currentIndex;

  /// Active dot color.
  final Color activeColor;

  /// Inactive dot color.
  final Color inactiveColor;

  /// Size of each dot.
  final double dotSize;

  /// Spacing between dots.
  final double spacing;

  /// Animation duration.
  final Duration animationDuration;

  /// Maximum number of visible dots (for large galleries).
  final int maxVisibleDots;

  const AnimatedDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = Colors.white,
    this.inactiveColor = const Color(0x80FFFFFF),
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.maxVisibleDots = 7,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();

    // For small number of pages, show all dots
    if (count <= maxVisibleDots) {
      return _buildSimpleDots();
    }

    // For larger galleries, use scrolling dots
    return _buildScrollingDots();
  }

  Widget _buildSimpleDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: animationDuration,
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? dotSize * 2 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      }),
    );
  }

  Widget _buildScrollingDots() {
    // Calculate visible range
    final halfVisible = maxVisibleDots ~/ 2;
    int startIndex = currentIndex - halfVisible;
    int endIndex = currentIndex + halfVisible;

    // Adjust bounds
    if (startIndex < 0) {
      endIndex -= startIndex;
      startIndex = 0;
    }
    if (endIndex >= count) {
      startIndex -= (endIndex - count + 1);
      endIndex = count - 1;
    }
    startIndex = startIndex.clamp(0, count - 1);
    endIndex = endIndex.clamp(0, count - 1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Leading indicator for more pages
        if (startIndex > 0)
          _buildFadeDot(0.3),

        // Visible dots
        ...List.generate(endIndex - startIndex + 1, (i) {
          final index = startIndex + i;
          final isActive = index == currentIndex;
          final distanceFromCenter = (index - currentIndex).abs();
          final scale = isActive ? 1.0 : (1.0 - (distanceFromCenter * 0.1)).clamp(0.5, 1.0);

          return AnimatedContainer(
            duration: animationDuration,
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            width: isActive ? dotSize * 2 : dotSize * scale,
            height: dotSize * scale,
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor.withValues(alpha: scale),
              borderRadius: BorderRadius.circular(dotSize / 2),
            ),
          );
        }),

        // Trailing indicator for more pages
        if (endIndex < count - 1)
          _buildFadeDot(0.3),
      ],
    );
  }

  Widget _buildFadeDot(double opacity) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: dotSize * 0.5,
      height: dotSize * 0.5,
      decoration: BoxDecoration(
        color: inactiveColor.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// A smooth page indicator with animated transitions.
class SmoothPageIndicator extends StatelessWidget {
  /// Page controller to sync with.
  final PageController controller;

  /// Total number of pages.
  final int count;

  /// Active dot color.
  final Color activeColor;

  /// Inactive dot color.
  final Color inactiveColor;

  /// Size of each dot.
  final double dotSize;

  /// Spacing between dots.
  final double spacing;

  /// Effect type for animation.
  final IndicatorEffect effect;

  const SmoothPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.activeColor = Colors.white,
    this.inactiveColor = const Color(0x80FFFFFF),
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.effect = IndicatorEffect.worm,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.hasClients
            ? (controller.page ?? controller.initialPage.toDouble())
            : controller.initialPage.toDouble();

        return CustomPaint(
          size: Size(
            (dotSize + spacing) * count - spacing,
            dotSize,
          ),
          painter: _IndicatorPainter(
            count: count,
            currentPage: page,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            dotSize: dotSize,
            spacing: spacing,
            effect: effect,
          ),
        );
      },
    );
  }
}

/// Effect types for smooth page indicator.
enum IndicatorEffect {
  /// Worm-like sliding effect.
  worm,

  /// Expanding dot effect.
  expanding,

  /// Jumping dot effect.
  jumping,

  /// Scale effect.
  scale,
}

class _IndicatorPainter extends CustomPainter {
  final int count;
  final double currentPage;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;
  final IndicatorEffect effect;

  _IndicatorPainter({
    required this.count,
    required this.currentPage,
    required this.activeColor,
    required this.inactiveColor,
    required this.dotSize,
    required this.spacing,
    required this.effect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final radius = dotSize / 2;
    final totalWidth = dotSize + spacing;

    // Draw inactive dots
    for (int i = 0; i < count; i++) {
      final x = i * totalWidth + radius;
      final y = size.height / 2;

      switch (effect) {
        case IndicatorEffect.scale:
          final distance = (i - currentPage).abs();
          final scale = (1.0 - distance * 0.3).clamp(0.5, 1.0);
          canvas.drawCircle(
            Offset(x, y),
            radius * scale,
            distance < 0.5 ? activePaint : inactivePaint,
          );
          break;
        default:
          canvas.drawCircle(Offset(x, y), radius, inactivePaint);
      }
    }

    // Draw active indicator based on effect
    switch (effect) {
      case IndicatorEffect.worm:
        _drawWormEffect(canvas, size, activePaint, radius, totalWidth);
        break;
      case IndicatorEffect.expanding:
        _drawExpandingEffect(canvas, size, activePaint, radius, totalWidth);
        break;
      case IndicatorEffect.jumping:
        _drawJumpingEffect(canvas, size, activePaint, radius, totalWidth);
        break;
      case IndicatorEffect.scale:
        // Already handled above
        break;
    }
  }

  void _drawWormEffect(
    Canvas canvas,
    Size size,
    Paint paint,
    double radius,
    double totalWidth,
  ) {
    final currentIndex = currentPage.floor();
    final progress = currentPage - currentIndex;

    final startX = currentIndex * totalWidth + radius;
    final endX = (currentIndex + 1) * totalWidth + radius;
    final y = size.height / 2;

    // Calculate worm bounds
    final left = startX + (endX - startX) * (progress < 0.5 ? 0 : (progress - 0.5) * 2);
    final right = startX + (endX - startX) * (progress < 0.5 ? progress * 2 : 1);

    canvas.drawRRect(
      RRect.fromLTRBR(
        left - radius,
        y - radius,
        right + radius,
        y + radius,
        Radius.circular(radius),
      ),
      paint,
    );
  }

  void _drawExpandingEffect(
    Canvas canvas,
    Size size,
    Paint paint,
    double radius,
    double totalWidth,
  ) {
    final currentIndex = currentPage.round();
    final x = currentIndex * totalWidth + radius;
    final y = size.height / 2;

    final distance = (currentPage - currentIndex).abs();
    final scale = 1.0 + (1.0 - distance) * 0.5;

    canvas.drawCircle(Offset(x, y), radius * scale, paint);
  }

  void _drawJumpingEffect(
    Canvas canvas,
    Size size,
    Paint paint,
    double radius,
    double totalWidth,
  ) {
    final currentIndex = currentPage.floor();
    final progress = currentPage - currentIndex;

    final startX = currentIndex * totalWidth + radius;
    final endX = (currentIndex + 1) * totalWidth + radius;

    // Parabolic jump
    final x = startX + (endX - startX) * progress;
    final jumpHeight = radius * 2;
    final y = size.height / 2 - jumpHeight * 4 * progress * (1 - progress);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) {
    return oldDelegate.currentPage != currentPage ||
        oldDelegate.count != count ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
