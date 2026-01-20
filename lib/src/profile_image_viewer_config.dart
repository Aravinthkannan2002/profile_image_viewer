import 'package:flutter/material.dart';

/// Callback for analytics events.
typedef AnalyticsCallback = void Function(String event, Map<String, dynamic> data);

/// Context menu action for long-press.
class ContextMenuAction {
  /// Label displayed in the menu.
  final String label;

  /// Icon displayed next to the label.
  final IconData? icon;

  /// Callback when the action is tapped.
  final VoidCallback onTap;

  const ContextMenuAction({
    required this.label,
    this.icon,
    required this.onTap,
  });
}

/// Configuration class for customizing the ProfileImageViewer appearance and behavior.
///
/// This allows you to customize colors, sizes, placeholders, and more.
@immutable
class ProfileImageViewerConfig {
  /// Background color of the viewer screen.
  final Color backgroundColor;

  /// Color of the loading indicator.
  final Color loaderColor;

  /// Size of the loading indicator.
  final double loaderSize;

  /// Stroke width of the loading indicator.
  final double loaderStrokeWidth;

  /// Background color of the placeholder when no image is available.
  final Color placeholderBackgroundColor;

  /// Icon color for the placeholder.
  final Color placeholderIconColor;

  /// Icon to display when no image is available.
  final IconData placeholderIcon;

  /// Size of the placeholder relative to screen width (0.0 to 1.0).
  final double placeholderSizeRatio;

  /// Icon size relative to placeholder size (0.0 to 1.0).
  final double placeholderIconRatio;

  /// Enable/disable swipe-to-dismiss gesture.
  final bool enableSwipeToDismiss;

  /// Allow swipe up to dismiss in addition to swipe down.
  final bool enableSwipeUpToDismiss;

  /// Minimum drag distance (in pixels) required to dismiss.
  final double dismissThreshold;

  /// Minimum velocity (pixels/second) for quick-flick dismiss.
  final double dismissVelocity;

  /// Maximum drag offset before stopping.
  final double maxDragOffset;

  /// Minimum opacity when dragged to max offset.
  final double minOpacity;

  /// Enable/disable screenshot protection.
  final bool enableScreenProtection;

  /// Enable/disable haptic feedback on dismiss.
  final bool enableHapticFeedback;

  /// Minimum zoom scale.
  final double minScale;

  /// Maximum zoom scale multiplier (applied to covered scale).
  final double maxScaleMultiplier;

  /// Duration for animation when resetting position.
  final Duration resetAnimationDuration;

  /// Enable double-tap to zoom gesture.
  final bool enableDoubleTapZoom;

  /// Scale to zoom to on double-tap (relative to min scale).
  final double doubleTapZoomScale;

  /// Enable double-tap zoom to tap point instead of center.
  final bool doubleTapZoomToPoint;

  /// Enable rotation gestures (two-finger rotation).
  final bool enableRotation;

  /// Show rotation reset button in app bar.
  final bool showRotationResetButton;

  /// Hide status bar when viewer is shown.
  final bool hideStatusBar;

  /// Show download progress percentage.
  final bool showDownloadProgress;

  /// Show zoom level indicator overlay.
  final bool showZoomIndicator;

  /// Show image info overlay (dimensions, size).
  final bool showImageInfo;

  /// Enable long-press context menu.
  final bool enableContextMenu;

  /// Custom context menu actions.
  final List<ContextMenuAction>? contextMenuActions;

  /// Enable keyboard shortcuts (desktop/web).
  final bool enableKeyboardShortcuts;

  /// Use blurred image as background.
  final bool useBlurBackground;

  /// Blur sigma for background (when useBlurBackground is true).
  final double blurSigma;

  /// Show gradient overlay on app bar for better visibility.
  final bool showAppBarGradient;

  /// Use shimmer loading effect instead of spinner.
  final bool useShimmerLoading;

  /// Shimmer base color.
  final Color shimmerBaseColor;

  /// Shimmer highlight color.
  final Color shimmerHighlightColor;

  /// Enable animated page indicator dots for gallery.
  final bool useAnimatedDots;

  /// Active dot color for page indicator.
  final Color activeDotColor;

  /// Inactive dot color for page indicator.
  final Color inactiveDotColor;

  /// Dot size for page indicator.
  final double dotSize;

  /// Show thumbnail strip in gallery.
  final bool showThumbnailStrip;

  /// Thumbnail strip height.
  final double thumbnailStripHeight;

  /// Enable auto-slideshow mode in gallery.
  final bool enableSlideshow;

  /// Slideshow interval duration.
  final Duration slideshowInterval;

  /// Precache adjacent images in gallery.
  final bool precacheImages;

  /// Number of images to precache on each side.
  final int precacheCount;

  /// HTTP headers for network image requests.
  final Map<String, String>? httpHeaders;

  /// Cache key for network images.
  final String? cacheKey;

  /// Maximum cache age for network images.
  final Duration? maxCacheAge;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Analytics callback for tracking events.
  final AnalyticsCallback? onAnalyticsEvent;

  /// Custom app bar builder. If null, a default app bar is shown.
  final PreferredSizeWidget? Function(BuildContext context, String title)?
      appBarBuilder;

  /// Custom loading widget builder. If null, default loader is used.
  /// Receives optional progress value (0.0 to 1.0) for download progress.
  final Widget Function(BuildContext context, double? progress)? loadingBuilder;

  /// Custom error widget builder. If null, default placeholder is shown.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Custom placeholder widget builder. If null, default placeholder is shown.
  final Widget Function(BuildContext context)? placeholderBuilder;

  /// Custom zoom indicator builder.
  final Widget Function(BuildContext context, double zoomLevel)? zoomIndicatorBuilder;

  /// Custom image info builder.
  final Widget Function(BuildContext context, ViewerImageInfo info)? imageInfoBuilder;

  const ProfileImageViewerConfig({
    this.backgroundColor = Colors.black,
    this.loaderColor = const Color(0xFF004C99),
    this.loaderSize = 40.0,
    this.loaderStrokeWidth = 4.0,
    this.placeholderBackgroundColor = const Color(0xFF2A2A2A),
    this.placeholderIconColor = const Color(0xFF6B6B6B),
    this.placeholderIcon = Icons.person,
    this.placeholderSizeRatio = 0.6,
    this.placeholderIconRatio = 0.5,
    this.enableSwipeToDismiss = true,
    this.enableSwipeUpToDismiss = false,
    this.dismissThreshold = 100.0,
    this.dismissVelocity = 500.0,
    this.maxDragOffset = 300.0,
    this.minOpacity = 0.3,
    this.enableScreenProtection = true,
    this.enableHapticFeedback = true,
    this.minScale = 1.0,
    this.maxScaleMultiplier = 2.0,
    this.resetAnimationDuration = const Duration(milliseconds: 200),
    this.enableDoubleTapZoom = true,
    this.doubleTapZoomScale = 2.0,
    this.doubleTapZoomToPoint = true,
    this.enableRotation = false,
    this.showRotationResetButton = true,
    this.hideStatusBar = true,
    this.showDownloadProgress = false,
    this.showZoomIndicator = false,
    this.showImageInfo = false,
    this.enableContextMenu = false,
    this.contextMenuActions,
    this.enableKeyboardShortcuts = true,
    this.useBlurBackground = false,
    this.blurSigma = 20.0,
    this.showAppBarGradient = false,
    this.useShimmerLoading = false,
    this.shimmerBaseColor = const Color(0xFF2A2A2A),
    this.shimmerHighlightColor = const Color(0xFF3A3A3A),
    this.useAnimatedDots = true,
    this.activeDotColor = Colors.white,
    this.inactiveDotColor = const Color(0x80FFFFFF),
    this.dotSize = 8.0,
    this.showThumbnailStrip = false,
    this.thumbnailStripHeight = 60.0,
    this.enableSlideshow = false,
    this.slideshowInterval = const Duration(seconds: 3),
    this.precacheImages = true,
    this.precacheCount = 1,
    this.httpHeaders,
    this.cacheKey,
    this.maxCacheAge,
    this.semanticLabel,
    this.onAnalyticsEvent,
    this.appBarBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.placeholderBuilder,
    this.zoomIndicatorBuilder,
    this.imageInfoBuilder,
  })  : assert(placeholderSizeRatio >= 0.0 && placeholderSizeRatio <= 1.0,
            'placeholderSizeRatio must be between 0.0 and 1.0'),
        assert(placeholderIconRatio >= 0.0 && placeholderIconRatio <= 1.0,
            'placeholderIconRatio must be between 0.0 and 1.0'),
        assert(minOpacity >= 0.0 && minOpacity <= 1.0,
            'minOpacity must be between 0.0 and 1.0'),
        assert(loaderSize > 0, 'loaderSize must be positive'),
        assert(loaderStrokeWidth > 0, 'loaderStrokeWidth must be positive'),
        assert(dismissThreshold > 0, 'dismissThreshold must be positive'),
        assert(dismissVelocity > 0, 'dismissVelocity must be positive'),
        assert(maxDragOffset > 0, 'maxDragOffset must be positive'),
        assert(minScale > 0, 'minScale must be positive'),
        assert(maxScaleMultiplier > 0, 'maxScaleMultiplier must be positive'),
        assert(doubleTapZoomScale > 0, 'doubleTapZoomScale must be positive'),
        assert(blurSigma >= 0, 'blurSigma must be non-negative'),
        assert(dotSize > 0, 'dotSize must be positive'),
        assert(thumbnailStripHeight > 0, 'thumbnailStripHeight must be positive'),
        assert(precacheCount >= 0, 'precacheCount must be non-negative');

  /// Creates a copy of this config with the given fields replaced.
  ProfileImageViewerConfig copyWith({
    Color? backgroundColor,
    Color? loaderColor,
    double? loaderSize,
    double? loaderStrokeWidth,
    Color? placeholderBackgroundColor,
    Color? placeholderIconColor,
    IconData? placeholderIcon,
    double? placeholderSizeRatio,
    double? placeholderIconRatio,
    bool? enableSwipeToDismiss,
    bool? enableSwipeUpToDismiss,
    double? dismissThreshold,
    double? dismissVelocity,
    double? maxDragOffset,
    double? minOpacity,
    bool? enableScreenProtection,
    bool? enableHapticFeedback,
    double? minScale,
    double? maxScaleMultiplier,
    Duration? resetAnimationDuration,
    bool? enableDoubleTapZoom,
    double? doubleTapZoomScale,
    bool? doubleTapZoomToPoint,
    bool? enableRotation,
    bool? showRotationResetButton,
    bool? hideStatusBar,
    bool? showDownloadProgress,
    bool? showZoomIndicator,
    bool? showImageInfo,
    bool? enableContextMenu,
    List<ContextMenuAction>? contextMenuActions,
    bool? enableKeyboardShortcuts,
    bool? useBlurBackground,
    double? blurSigma,
    bool? showAppBarGradient,
    bool? useShimmerLoading,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    bool? useAnimatedDots,
    Color? activeDotColor,
    Color? inactiveDotColor,
    double? dotSize,
    bool? showThumbnailStrip,
    double? thumbnailStripHeight,
    bool? enableSlideshow,
    Duration? slideshowInterval,
    bool? precacheImages,
    int? precacheCount,
    Map<String, String>? httpHeaders,
    String? cacheKey,
    Duration? maxCacheAge,
    String? semanticLabel,
    AnalyticsCallback? onAnalyticsEvent,
    PreferredSizeWidget? Function(BuildContext context, String title)?
        appBarBuilder,
    Widget Function(BuildContext context, double? progress)? loadingBuilder,
    Widget Function(BuildContext context, Object error)? errorBuilder,
    Widget Function(BuildContext context)? placeholderBuilder,
    Widget Function(BuildContext context, double zoomLevel)? zoomIndicatorBuilder,
    Widget Function(BuildContext context, ViewerImageInfo info)? imageInfoBuilder,
  }) {
    return ProfileImageViewerConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      loaderColor: loaderColor ?? this.loaderColor,
      loaderSize: loaderSize ?? this.loaderSize,
      loaderStrokeWidth: loaderStrokeWidth ?? this.loaderStrokeWidth,
      placeholderBackgroundColor:
          placeholderBackgroundColor ?? this.placeholderBackgroundColor,
      placeholderIconColor: placeholderIconColor ?? this.placeholderIconColor,
      placeholderIcon: placeholderIcon ?? this.placeholderIcon,
      placeholderSizeRatio: placeholderSizeRatio ?? this.placeholderSizeRatio,
      placeholderIconRatio: placeholderIconRatio ?? this.placeholderIconRatio,
      enableSwipeToDismiss: enableSwipeToDismiss ?? this.enableSwipeToDismiss,
      enableSwipeUpToDismiss: enableSwipeUpToDismiss ?? this.enableSwipeUpToDismiss,
      dismissThreshold: dismissThreshold ?? this.dismissThreshold,
      dismissVelocity: dismissVelocity ?? this.dismissVelocity,
      maxDragOffset: maxDragOffset ?? this.maxDragOffset,
      minOpacity: minOpacity ?? this.minOpacity,
      enableScreenProtection:
          enableScreenProtection ?? this.enableScreenProtection,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      minScale: minScale ?? this.minScale,
      maxScaleMultiplier: maxScaleMultiplier ?? this.maxScaleMultiplier,
      resetAnimationDuration:
          resetAnimationDuration ?? this.resetAnimationDuration,
      enableDoubleTapZoom: enableDoubleTapZoom ?? this.enableDoubleTapZoom,
      doubleTapZoomScale: doubleTapZoomScale ?? this.doubleTapZoomScale,
      doubleTapZoomToPoint: doubleTapZoomToPoint ?? this.doubleTapZoomToPoint,
      enableRotation: enableRotation ?? this.enableRotation,
      showRotationResetButton:
          showRotationResetButton ?? this.showRotationResetButton,
      hideStatusBar: hideStatusBar ?? this.hideStatusBar,
      showDownloadProgress: showDownloadProgress ?? this.showDownloadProgress,
      showZoomIndicator: showZoomIndicator ?? this.showZoomIndicator,
      showImageInfo: showImageInfo ?? this.showImageInfo,
      enableContextMenu: enableContextMenu ?? this.enableContextMenu,
      contextMenuActions: contextMenuActions ?? this.contextMenuActions,
      enableKeyboardShortcuts: enableKeyboardShortcuts ?? this.enableKeyboardShortcuts,
      useBlurBackground: useBlurBackground ?? this.useBlurBackground,
      blurSigma: blurSigma ?? this.blurSigma,
      showAppBarGradient: showAppBarGradient ?? this.showAppBarGradient,
      useShimmerLoading: useShimmerLoading ?? this.useShimmerLoading,
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor: shimmerHighlightColor ?? this.shimmerHighlightColor,
      useAnimatedDots: useAnimatedDots ?? this.useAnimatedDots,
      activeDotColor: activeDotColor ?? this.activeDotColor,
      inactiveDotColor: inactiveDotColor ?? this.inactiveDotColor,
      dotSize: dotSize ?? this.dotSize,
      showThumbnailStrip: showThumbnailStrip ?? this.showThumbnailStrip,
      thumbnailStripHeight: thumbnailStripHeight ?? this.thumbnailStripHeight,
      enableSlideshow: enableSlideshow ?? this.enableSlideshow,
      slideshowInterval: slideshowInterval ?? this.slideshowInterval,
      precacheImages: precacheImages ?? this.precacheImages,
      precacheCount: precacheCount ?? this.precacheCount,
      httpHeaders: httpHeaders ?? this.httpHeaders,
      cacheKey: cacheKey ?? this.cacheKey,
      maxCacheAge: maxCacheAge ?? this.maxCacheAge,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      onAnalyticsEvent: onAnalyticsEvent ?? this.onAnalyticsEvent,
      appBarBuilder: appBarBuilder ?? this.appBarBuilder,
      loadingBuilder: loadingBuilder ?? this.loadingBuilder,
      errorBuilder: errorBuilder ?? this.errorBuilder,
      placeholderBuilder: placeholderBuilder ?? this.placeholderBuilder,
      zoomIndicatorBuilder: zoomIndicatorBuilder ?? this.zoomIndicatorBuilder,
      imageInfoBuilder: imageInfoBuilder ?? this.imageInfoBuilder,
    );
  }

  /// Creates a configuration from a Flutter [ThemeData].
  ///
  /// Automatically derives colors from the theme for consistent styling.
  factory ProfileImageViewerConfig.fromTheme(
    ThemeData theme, {
    bool enableScreenProtection = true,
    bool enableDoubleTapZoom = true,
    bool enableRotation = false,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return ProfileImageViewerConfig(
      backgroundColor: isDark ? Colors.black : theme.scaffoldBackgroundColor,
      loaderColor: theme.colorScheme.primary,
      placeholderBackgroundColor:
          isDark ? const Color(0xFF2D2D2D) : theme.colorScheme.surfaceContainerHighest,
      placeholderIconColor: isDark
          ? const Color(0xFF757575)
          : theme.colorScheme.onSurfaceVariant,
      activeDotColor: theme.colorScheme.primary,
      inactiveDotColor: theme.colorScheme.primary.withValues(alpha: 0.3),
      shimmerBaseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0),
      shimmerHighlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      enableScreenProtection: enableScreenProtection,
      enableDoubleTapZoom: enableDoubleTapZoom,
      enableRotation: enableRotation,
    );
  }

  /// Default WhatsApp-style configuration.
  static const ProfileImageViewerConfig whatsApp = ProfileImageViewerConfig(
    backgroundColor: Colors.black,
    loaderColor: Color(0xFF25D366), // WhatsApp green
    placeholderBackgroundColor: Color(0xFF2A2A2A),
    placeholderIconColor: Color(0xFF6B6B6B),
    activeDotColor: Color(0xFF25D366),
  );

  /// Dark theme configuration.
  static const ProfileImageViewerConfig dark = ProfileImageViewerConfig(
    backgroundColor: Color(0xFF121212),
    loaderColor: Colors.white,
    placeholderBackgroundColor: Color(0xFF2D2D2D),
    placeholderIconColor: Color(0xFF757575),
  );

  /// Light theme configuration (for light mode apps).
  static const ProfileImageViewerConfig light = ProfileImageViewerConfig(
    backgroundColor: Color(0xFFF5F5F5),
    loaderColor: Color(0xFF1976D2),
    placeholderBackgroundColor: Color(0xFFE0E0E0),
    placeholderIconColor: Color(0xFF9E9E9E),
    hideStatusBar: false,
    activeDotColor: Color(0xFF1976D2),
    inactiveDotColor: Color(0x801976D2),
  );

  /// Instagram-style configuration.
  static const ProfileImageViewerConfig instagram = ProfileImageViewerConfig(
    backgroundColor: Colors.black,
    loaderColor: Color(0xFFE1306C), // Instagram pink/magenta
    placeholderBackgroundColor: Color(0xFF262626),
    placeholderIconColor: Color(0xFF8E8E8E),
    enableDoubleTapZoom: true,
    activeDotColor: Color(0xFFE1306C),
    showAppBarGradient: true,
  );

  /// Telegram-style configuration.
  static const ProfileImageViewerConfig telegram = ProfileImageViewerConfig(
    backgroundColor: Color(0xFF17212B),
    loaderColor: Color(0xFF5EBBEA), // Telegram blue
    placeholderBackgroundColor: Color(0xFF242F3D),
    placeholderIconColor: Color(0xFF6D7F8F),
    activeDotColor: Color(0xFF5EBBEA),
  );

  /// Twitter/X-style configuration.
  static const ProfileImageViewerConfig twitter = ProfileImageViewerConfig(
    backgroundColor: Colors.black,
    loaderColor: Color(0xFF1DA1F2), // Twitter blue
    placeholderBackgroundColor: Color(0xFF2F3336),
    placeholderIconColor: Color(0xFF71767B),
    activeDotColor: Color(0xFF1DA1F2),
  );

  /// Minimal configuration with reduced features.
  static const ProfileImageViewerConfig minimal = ProfileImageViewerConfig(
    backgroundColor: Colors.black,
    loaderColor: Colors.white70,
    enableScreenProtection: false,
    enableHapticFeedback: false,
    hideStatusBar: false,
    enableDoubleTapZoom: false,
    enableRotation: false,
    enableKeyboardShortcuts: false,
    useAnimatedDots: false,
  );

  /// Full-featured configuration with all enhancements enabled.
  static const ProfileImageViewerConfig fullFeatured = ProfileImageViewerConfig(
    backgroundColor: Colors.black,
    loaderColor: Colors.white,
    enableDoubleTapZoom: true,
    doubleTapZoomToPoint: true,
    enableRotation: true,
    showZoomIndicator: true,
    showImageInfo: true,
    enableContextMenu: true,
    enableKeyboardShortcuts: true,
    useBlurBackground: true,
    showAppBarGradient: true,
    useAnimatedDots: true,
    showThumbnailStrip: true,
    precacheImages: true,
    precacheCount: 2,
  );
}

/// Information about an image for display in overlays.
class ViewerImageInfo {
  /// Image width in pixels.
  final int? width;

  /// Image height in pixels.
  final int? height;

  /// File size in bytes.
  final int? sizeBytes;

  /// Image format (e.g., 'JPEG', 'PNG').
  final String? format;

  const ViewerImageInfo({
    this.width,
    this.height,
    this.sizeBytes,
    this.format,
  });

  /// Returns formatted dimensions string (e.g., "1920 x 1080").
  String get dimensionsString {
    if (width == null || height == null) return 'Unknown';
    return '$width × $height';
  }

  /// Returns formatted file size string (e.g., "2.5 MB").
  String get sizeString {
    if (sizeBytes == null) return 'Unknown';
    if (sizeBytes! < 1024) return '$sizeBytes B';
    if (sizeBytes! < 1024 * 1024) return '${(sizeBytes! / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
