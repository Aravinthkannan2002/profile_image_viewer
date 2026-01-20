import 'package:flutter/material.dart';

/// A customizable loading indicator widget used by ProfileImageViewer.
///
/// Can be used standalone or as part of the ProfileImageViewer.
/// Features entrance animations and optional progress display.
class ProfileImageLoader extends StatefulWidget {
  /// Size of the loader.
  final double size;

  /// Color of the spinner.
  final Color color;

  /// Stroke width of the circular progress indicator.
  final double strokeWidth;

  /// Optional progress value (0.0 to 1.0). If null, shows indeterminate spinner.
  final double? progress;

  /// Whether to show the progress percentage text.
  final bool showProgressText;

  /// Text style for progress percentage.
  final TextStyle? progressTextStyle;

  const ProfileImageLoader({
    super.key,
    this.size = 40.0,
    this.color = const Color(0xFF004C99),
    this.strokeWidth = 4.0,
    this.progress,
    this.showProgressText = false,
    this.progressTextStyle,
  });

  @override
  State<ProfileImageLoader> createState() => _ProfileImageLoaderState();
}

class _ProfileImageLoaderState extends State<ProfileImageLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.color.withValues(alpha: 0.15);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.progress != null)
              CircularProgressIndicator(
                value: widget.progress,
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                strokeWidth: widget.strokeWidth,
              )
            else
              CircularProgressIndicator.adaptive(
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                strokeWidth: widget.strokeWidth,
              ),
            if (widget.showProgressText && widget.progress != null)
              Text(
                '${(widget.progress! * 100).toInt()}%',
                style: widget.progressTextStyle ??
                    TextStyle(
                      color: widget.color,
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.bold,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
