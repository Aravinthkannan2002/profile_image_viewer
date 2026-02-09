import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'profile_image_viewer_config.dart';
import 'profile_image_loader.dart';
import 'shimmer_loading.dart';
import 'animated_dots_indicator.dart';
import 'screen_protector_stub.dart'
    if (dart.library.io) 'screen_protector_io.dart';

/// Represents a single image in the gallery.
class GalleryImage {
  /// URL of the network image.
  final String? imageUrl;

  /// Whether [imageUrl] is a local file path.
  final bool isLocalFile;

  /// Whether [imageUrl] is an asset path.
  final bool isAsset;

  /// Raw image bytes for memory images.
  final Uint8List? imageBytes;

  /// Title for this image.
  final String? title;

  /// Subtitle for this image.
  final String? subtitle;

  /// Hero tag for this specific image.
  final String? heroTag;

  const GalleryImage({
    this.imageUrl,
    this.isLocalFile = false,
    this.isAsset = false,
    this.imageBytes,
    this.title,
    this.subtitle,
    this.heroTag,
  });

  /// Creates a network image.
  const GalleryImage.network(
    String url, {
    this.title,
    this.subtitle,
    this.heroTag,
  })  : imageUrl = url,
        isLocalFile = false,
        isAsset = false,
        imageBytes = null;

  /// Creates a local file image.
  const GalleryImage.file(
    String path, {
    this.title,
    this.subtitle,
    this.heroTag,
  })  : imageUrl = path,
        isLocalFile = true,
        isAsset = false,
        imageBytes = null;

  /// Creates an asset image.
  const GalleryImage.asset(
    String assetPath, {
    this.title,
    this.subtitle,
    this.heroTag,
  })  : imageUrl = assetPath,
        isLocalFile = false,
        isAsset = true,
        imageBytes = null;

  /// Creates a memory image from bytes.
  const GalleryImage.memory(
    Uint8List bytes, {
    this.title,
    this.subtitle,
    this.heroTag,
  })  : imageBytes = bytes,
        imageUrl = null,
        isLocalFile = false,
        isAsset = false;
}

/// Result returned from the ProfileImageGallery when closed.
class ProfileImageGalleryResult {
  /// The index of the image when the gallery was closed.
  final int currentIndex;

  /// Whether the user performed an action.
  final bool actionPerformed;

  /// The action type if an action was performed.
  final String? actionType;

  /// Additional data from the action.
  final dynamic data;

  /// Total view duration in milliseconds.
  final int? viewDurationMs;

  const ProfileImageGalleryResult({
    required this.currentIndex,
    this.actionPerformed = false,
    this.actionType,
    this.data,
    this.viewDurationMs,
  });
}

/// A fullscreen image gallery viewer supporting multiple images with:
/// - Horizontal swipe navigation between images
/// - Pinch-to-zoom using PhotoView
/// - Double-tap to zoom
/// - Swipe-down-to-dismiss gesture
/// - Hero animation support
/// - Screenshot protection (optional)
/// - Animated page indicator dots
/// - Thumbnail strip
/// - Auto-slideshow mode
/// - Image precaching
/// - Keyboard shortcuts for desktop/web
/// - Analytics callbacks
/// - Fully customizable via [ProfileImageViewerConfig]
///
/// Example usage:
/// ```dart
/// final result = await ProfileImageGallery.show(
///   context,
///   images: [
///     GalleryImage.network('https://example.com/photo1.jpg', title: 'Photo 1'),
///     GalleryImage.network('https://example.com/photo2.jpg', title: 'Photo 2'),
///   ],
///   initialIndex: 0,
/// );
/// ```
class ProfileImageGallery extends StatefulWidget {
  /// List of images to display in the gallery.
  final List<GalleryImage> images;

  /// Initial image index to display.
  final int initialIndex;

  /// Default title shown when image has no title.
  final String defaultTitle;

  /// Callback when edit action is tapped.
  final void Function(int index)? onEditTap;

  /// Callback when share action is tapped.
  final void Function(int index)? onShareTap;

  /// Callback when save action is tapped.
  final void Function(int index)? onSaveTap;

  /// Callback when info action is tapped.
  final void Function(int index)? onInfoTap;

  /// Callback when page changes.
  final void Function(int index)? onPageChanged;

  /// Configuration for customizing the viewer's appearance and behavior.
  final ProfileImageViewerConfig config;

  /// Custom leading widget for the app bar.
  final Widget? leading;

  /// Custom actions for the app bar.
  final List<Widget>? actions;

  /// Whether to show the default back button.
  final bool showBackButton;

  /// Whether to show the page indicator.
  final bool showPageIndicator;

  /// Custom page indicator builder.
  final Widget Function(BuildContext context, int currentIndex, int totalCount)?
      pageIndicatorBuilder;

  const ProfileImageGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.defaultTitle = 'Gallery',
    this.onEditTap,
    this.onShareTap,
    this.onSaveTap,
    this.onInfoTap,
    this.onPageChanged,
    this.config = const ProfileImageViewerConfig(),
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.showPageIndicator = true,
    this.pageIndicatorBuilder,
  });

  /// Convenience method to navigate to the gallery with a push transition.
  static Future<ProfileImageGalleryResult?> show(
    BuildContext context, {
    required List<GalleryImage> images,
    int initialIndex = 0,
    String defaultTitle = 'Gallery',
    void Function(int index)? onEditTap,
    void Function(int index)? onShareTap,
    void Function(int index)? onSaveTap,
    void Function(int index)? onInfoTap,
    void Function(int index)? onPageChanged,
    ProfileImageViewerConfig config = const ProfileImageViewerConfig(),
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
    bool showPageIndicator = true,
    Widget Function(BuildContext context, int currentIndex, int totalCount)?
        pageIndicatorBuilder,
  }) {
    return Navigator.of(context).push<ProfileImageGalleryResult>(
      MaterialPageRoute(
        builder: (_) => ProfileImageGallery(
          images: images,
          initialIndex: initialIndex,
          defaultTitle: defaultTitle,
          onEditTap: onEditTap,
          onShareTap: onShareTap,
          onSaveTap: onSaveTap,
          onInfoTap: onInfoTap,
          onPageChanged: onPageChanged,
          config: config,
          leading: leading,
          actions: actions,
          showBackButton: showBackButton,
          showPageIndicator: showPageIndicator,
          pageIndicatorBuilder: pageIndicatorBuilder,
        ),
      ),
    );
  }

  /// Show with a fade transition.
  static Future<ProfileImageGalleryResult?> showWithFade(
    BuildContext context, {
    required List<GalleryImage> images,
    int initialIndex = 0,
    String defaultTitle = 'Gallery',
    void Function(int index)? onEditTap,
    void Function(int index)? onShareTap,
    void Function(int index)? onSaveTap,
    void Function(int index)? onInfoTap,
    void Function(int index)? onPageChanged,
    ProfileImageViewerConfig config = const ProfileImageViewerConfig(),
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
    bool showPageIndicator = true,
    Widget Function(BuildContext context, int currentIndex, int totalCount)?
        pageIndicatorBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<ProfileImageGalleryResult>(
      PageRouteBuilder(
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfileImageGallery(
          images: images,
          initialIndex: initialIndex,
          defaultTitle: defaultTitle,
          onEditTap: onEditTap,
          onShareTap: onShareTap,
          onSaveTap: onSaveTap,
          onInfoTap: onInfoTap,
          onPageChanged: onPageChanged,
          config: config,
          leading: leading,
          actions: actions,
          showBackButton: showBackButton,
          showPageIndicator: showPageIndicator,
          pageIndicatorBuilder: pageIndicatorBuilder,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<ProfileImageGallery> createState() => _ProfileImageGalleryState();
}

class _ProfileImageGalleryState extends State<ProfileImageGallery> {
  late PageController _pageController;
  late int _currentIndex;
  double _dragOffset = 0;
  double _dragOpacity = 1.0;
  bool _isDragging = false;
  bool _isSlideshow = false;
  Timer? _slideshowTimer;
  ProfileImageGalleryResult? _result;
  final FocusNode _focusNode = FocusNode();
  DateTime? _viewStartTime;
  ScrollController? _thumbnailController;
  final Set<int> _loadedIndices = {};

  @override
  void initState() {
    super.initState();
    _viewStartTime = DateTime.now();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    if (widget.config.showThumbnailStrip) {
      _thumbnailController = ScrollController();
    }

    if (widget.config.enableScreenProtection) {
      ScreenProtectorHelper.preventScreenshotOn();
    }

    if (widget.config.hideStatusBar) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );
    }

    // Resolve current image and precache adjacent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveImage(_currentIndex);
      if (widget.config.precacheImages) {
        _precacheImages();
      }
    });

    // Start slideshow if enabled
    if (widget.config.enableSlideshow) {
      _startSlideshow();
    }

    _trackAnalytics('gallery_view_start', {
      'total_images': widget.images.length,
      'initial_index': widget.initialIndex,
    });
  }

  @override
  void dispose() {
    _trackAnalytics('gallery_view_end', {
      'duration_ms': DateTime.now().difference(_viewStartTime!).inMilliseconds,
      'final_index': _currentIndex,
    });

    _pageController.dispose();
    _slideshowTimer?.cancel();
    _focusNode.dispose();
    _thumbnailController?.dispose();

    if (widget.config.enableScreenProtection) {
      ScreenProtectorHelper.preventScreenshotOff();
    }

    if (widget.config.hideStatusBar) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values,
      );
    }

    super.dispose();
  }

  void _trackAnalytics(String event, Map<String, dynamic> data) {
    widget.config.onAnalyticsEvent?.call(event, data);
  }

  void _resolveImage(int index) {
    if (_loadedIndices.contains(index)) return;
    final image = widget.images[index];
    final provider = _getImageProvider(image);
    if (provider == null || !mounted) return;

    precacheImage(
      provider,
      context,
      onError: (_, __) {},
    ).then((_) {
      if (mounted && !_loadedIndices.contains(index)) {
        setState(() => _loadedIndices.add(index));
      }
    }).catchError((_) {});
  }

  void _precacheImages() {
    final config = widget.config;
    final count = config.precacheCount;

    for (int i = 1; i <= count; i++) {
      // Precache next images
      final nextIndex = _currentIndex + i;
      if (nextIndex < widget.images.length) {
        _precacheImage(nextIndex);
      }

      // Precache previous images
      final prevIndex = _currentIndex - i;
      if (prevIndex >= 0) {
        _precacheImage(prevIndex);
      }
    }
  }

  void _precacheImage(int index) {
    final image = widget.images[index];
    final provider = _getImageProvider(image);

    if (provider != null && mounted) {
      precacheImage(
        provider,
        context,
        onError: (exception, stackTrace) {
          // Silently ignore precache errors (e.g., 403 from expired URLs)
          // The image will still load when viewed, just not pre-cached
        },
      );
    }
  }

  void _startSlideshow() {
    _isSlideshow = true;
    _slideshowTimer = Timer.periodic(widget.config.slideshowInterval, (_) {
      if (!mounted) return;

      final nextIndex = (_currentIndex + 1) % widget.images.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopSlideshow() {
    _isSlideshow = false;
    _slideshowTimer?.cancel();
    _slideshowTimer = null;
  }

  void _toggleSlideshow() {
    setState(() {
      if (_isSlideshow) {
        _stopSlideshow();
      } else {
        _startSlideshow();
      }
    });
    _trackAnalytics('slideshow_toggle', {'enabled': _isSlideshow});
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _resolveImage(index);
    widget.onPageChanged?.call(index);
    _trackAnalytics('page_change', {'index': index});

    // Precache adjacent images on page change
    if (widget.config.precacheImages) {
      _precacheImages();
    }

    // Scroll thumbnail strip to show current image
    _scrollThumbnailToIndex(index);
  }

  void _scrollThumbnailToIndex(int index) {
    if (_thumbnailController == null || !_thumbnailController!.hasClients) return;

    final thumbWidth = widget.config.thumbnailStripHeight;
    final targetOffset = (index * thumbWidth) - (MediaQuery.of(context).size.width / 2) + (thumbWidth / 2);

    _thumbnailController!.animateTo(
      targetOffset.clamp(0.0, _thumbnailController!.position.maxScrollExtent),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _onVerticalDragStart(DragStartDetails details) {
    if (!widget.config.enableSwipeToDismiss) return;
    _isDragging = true;
    _stopSlideshow();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.config.enableSwipeToDismiss) return;

    final delta = details.delta.dy;
    final allowUp = widget.config.enableSwipeUpToDismiss;

    if (delta > 0 || _dragOffset > 0) {
      setState(() {
        _dragOffset = (_dragOffset + delta).clamp(0.0, widget.config.maxDragOffset);
        _dragOpacity = (1 - (_dragOffset.abs() / widget.config.maxDragOffset)).clamp(
          widget.config.minOpacity,
          1.0,
        );
      });
    } else if (allowUp && (delta < 0 || _dragOffset < 0)) {
      setState(() {
        _dragOffset = (_dragOffset + delta).clamp(-widget.config.maxDragOffset, 0.0);
        _dragOpacity = (1 - (_dragOffset.abs() / widget.config.maxDragOffset)).clamp(
          widget.config.minOpacity,
          1.0,
        );
      });
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (!widget.config.enableSwipeToDismiss) return;

    _isDragging = false;

    final velocity = details.velocity.pixelsPerSecond.dy;
    final shouldDismissDown = _dragOffset > widget.config.dismissThreshold ||
        velocity > widget.config.dismissVelocity;
    final shouldDismissUp = widget.config.enableSwipeUpToDismiss &&
        (_dragOffset < -widget.config.dismissThreshold ||
            velocity < -widget.config.dismissVelocity);

    if (shouldDismissDown || shouldDismissUp) {
      if (widget.config.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
      _close();
    } else {
      setState(() {
        _dragOffset = 0;
        _dragOpacity = 1.0;
      });
    }
  }

  void _setResult(String actionType, [dynamic data]) {
    final duration = DateTime.now().difference(_viewStartTime!).inMilliseconds;
    _result = ProfileImageGalleryResult(
      currentIndex: _currentIndex,
      actionPerformed: true,
      actionType: actionType,
      data: data,
      viewDurationMs: duration,
    );
    _trackAnalytics('action', {'type': actionType, 'index': _currentIndex});
  }

  void _close() {
    final duration = DateTime.now().difference(_viewStartTime!).inMilliseconds;
    _result ??= ProfileImageGalleryResult(
      currentIndex: _currentIndex,
      viewDurationMs: duration,
    );
    Navigator.of(context).pop(_result);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.config.enableKeyboardShortcuts) return KeyEventResult.ignored;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Escape to close
    if (key == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }

    // Arrow keys to navigate
    if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.arrowUp) {
      if (_currentIndex > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.arrowDown) {
      if (_currentIndex < widget.images.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      return KeyEventResult.handled;
    }

    // Home to go to first image
    if (key == LogicalKeyboardKey.home) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    }

    // End to go to last image
    if (key == LogicalKeyboardKey.end) {
      _pageController.animateToPage(
        widget.images.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    }

    // Space to toggle slideshow
    if (key == LogicalKeyboardKey.space) {
      _toggleSlideshow();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  GalleryImage get _currentImage => widget.images[_currentIndex];

  String get _currentTitle => _currentImage.title ?? widget.defaultTitle;

  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return Focus(
      focusNode: _focusNode,
      autofocus: config.enableKeyboardShortcuts,
      onKeyEvent: _handleKeyEvent,
      child: Theme(
        data: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: config.backgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: config.backgroundColor,
            elevation: 0,
          ),
        ),
        child: Scaffold(
          backgroundColor: config.backgroundColor.withValues(alpha: _dragOpacity),
          extendBodyBehindAppBar: config.showAppBarGradient,
          appBar: _dragOffset != 0 ? null : _buildAppBar(context),
          body: Stack(
            children: [
              // Blur background
              if (config.useBlurBackground)
                Positioned.fill(
                  child: _buildBlurBackground(context),
                ),

              // Main gallery
              GestureDetector(
                onVerticalDragStart: _onVerticalDragStart,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: AnimatedContainer(
                  duration: _isDragging ? Duration.zero : config.resetAnimationDuration,
                  transform: Matrix4.translationValues(0, _dragOffset, 0),
                  child: _buildGallery(context),
                ),
              ),

              // Gradient overlay for app bar
              if (config.showAppBarGradient && _dragOffset == 0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 120,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Thumbnail strip
              if (config.showThumbnailStrip && widget.images.length > 1)
                Positioned(
                  bottom: config.useAnimatedDots ? 50 : 20,
                  left: 0,
                  right: 0,
                  height: config.thumbnailStripHeight,
                  child: _buildThumbnailStrip(context),
                ),

              // Page indicator
              if (widget.showPageIndicator && widget.images.length > 1)
                Positioned(
                  bottom: config.showThumbnailStrip ? config.thumbnailStripHeight + 60 : 20,
                  left: 0,
                  right: 0,
                  child: _buildPageIndicator(context),
                ),

              // Slideshow indicator
              if (_isSlideshow)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 60,
                  right: 16,
                  child: _buildSlideshowIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurBackground(BuildContext context) {
    final imageProvider = _getImageProvider(_currentImage);
    if (imageProvider == null) return const SizedBox.shrink();

    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: widget.config.blurSigma,
        sigmaY: widget.config.blurSigma,
      ),
      child: Opacity(
        opacity: 0.3,
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildSlideshowIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            'Slideshow',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final config = widget.config;

    if (config.appBarBuilder != null) {
      return config.appBarBuilder!(context, _currentTitle)!;
    }

    final List<Widget> appBarActions = widget.actions ??
        [
          if (config.enableSlideshow)
            IconButton(
              icon: Icon(
                _isSlideshow ? Icons.pause : Icons.play_arrow,
                color: config.iconColor,
              ),
              onPressed: _toggleSlideshow,
              tooltip: _isSlideshow ? 'Pause slideshow' : 'Start slideshow',
            ),
          if (widget.onSaveTap != null && _loadedIndices.contains(_currentIndex))
            IconButton(
              icon: config.saveIcon ?? Icon(Icons.download, color: config.iconColor),
              onPressed: () {
                _setResult('save');
                widget.onSaveTap!(_currentIndex);
              },
              tooltip: 'Save image',
            ),
          if (widget.onInfoTap != null && _loadedIndices.contains(_currentIndex))
            IconButton(
              icon: config.infoIcon ?? Icon(Icons.info_outline, color: config.iconColor),
              onPressed: () {
                _setResult('info');
                widget.onInfoTap!(_currentIndex);
              },
              tooltip: 'Image info',
            ),
          if (widget.onEditTap != null)
            IconButton(
              icon: config.editIcon ?? Icon(Icons.edit, color: config.iconColor),
              onPressed: () {
                _setResult('edit');
                widget.onEditTap!(_currentIndex);
              },
              tooltip: 'Edit image',
            ),
          if (widget.onShareTap != null)
            IconButton(
              icon: config.shareIcon ?? Icon(Icons.share, color: config.iconColor),
              onPressed: () {
                _setResult('share');
                widget.onShareTap!(_currentIndex);
              },
              tooltip: 'Share image',
            ),
        ];

    return AppBar(
      backgroundColor: config.showAppBarGradient
          ? Colors.transparent
          : config.backgroundColor,
      elevation: 0,
      leading: widget.leading ??
          (widget.showBackButton
              ? IconButton(
                  icon: config.backIcon ?? Icon(Icons.arrow_back, color: config.iconColor),
                  onPressed: _close,
                  tooltip: 'Go back',
                )
              : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _currentTitle,
            style: config.titleStyle ?? const TextStyle(color: Colors.white, fontSize: 18),
          ),
          if (_currentImage.subtitle != null)
            Text(
              _currentImage.subtitle!,
              style: config.subtitleStyle ?? TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
        ],
      ),
      actions: appBarActions,
    );
  }

  Widget _buildGallery(BuildContext context) {
    final config = widget.config;
    final screenWidth = MediaQuery.of(context).size.width;

    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      itemCount: widget.images.length,
      onPageChanged: _onPageChanged,
      backgroundDecoration: BoxDecoration(
        color: config.useBlurBackground ? Colors.transparent : config.backgroundColor,
      ),
      builder: (context, index) {
        final image = widget.images[index];
        final imageProvider = _getImageProvider(image);

        if (imageProvider == null) {
          return PhotoViewGalleryPageOptions.customChild(
            child: _buildPlaceholder(context),
            minScale: PhotoViewComputedScale.contained * config.minScale,
            maxScale: PhotoViewComputedScale.covered * config.maxScaleMultiplier,
          );
        }

        return PhotoViewGalleryPageOptions(
          imageProvider: imageProvider,
          heroAttributes: image.heroTag != null
              ? PhotoViewHeroAttributes(tag: image.heroTag!)
              : null,
          minScale: PhotoViewComputedScale.contained * config.minScale,
          maxScale: PhotoViewComputedScale.covered * config.maxScaleMultiplier,
          errorBuilder: (context, error, stackTrace) {
            if (config.errorBuilder != null) {
              return config.errorBuilder!(context, error);
            }
            return _buildPlaceholder(context);
          },
        );
      },
      loadingBuilder: (context, event) {
        double? progress;
        if (event != null && event.expectedTotalBytes != null) {
          progress = event.cumulativeBytesLoaded / event.expectedTotalBytes!;
        }

        if (config.loadingBuilder != null) {
          return config.loadingBuilder!(context, progress);
        }

        if (config.useShimmerLoading) {
          return Center(
            child: ShimmerLoading(
              width: screenWidth * 0.6,
              height: screenWidth * 0.6,
              baseColor: config.shimmerBaseColor,
              highlightColor: config.shimmerHighlightColor,
              isCircular: true,
            ),
          );
        }

        return Center(
          child: ProfileImageLoader(
            size: config.loaderSize,
            color: config.loaderColor,
            strokeWidth: config.loaderStrokeWidth,
            progress: config.showDownloadProgress ? progress : null,
            showProgressText: config.showDownloadProgress,
          ),
        );
      },
    );
  }

  ImageProvider? _getImageProvider(GalleryImage image) {
    // Memory image
    if (image.imageBytes != null && image.imageBytes!.isNotEmpty) {
      return MemoryImage(image.imageBytes!);
    }

    // No URL
    if (image.imageUrl == null || image.imageUrl!.isEmpty) {
      return null;
    }

    // Asset image
    if (image.isAsset) {
      return AssetImage(image.imageUrl!);
    }

    // Local file (only on non-web)
    if (image.isLocalFile && !kIsWeb) {
      return FileImage(File(image.imageUrl!));
    }

    // Network image (default)
    return CachedNetworkImageProvider(
      image.imageUrl!,
      headers: widget.config.httpHeaders,
      cacheKey: widget.config.cacheKey,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final config = widget.config;
    final screenWidth = MediaQuery.of(context).size.width;

    if (config.placeholderBuilder != null) {
      return config.placeholderBuilder!(context);
    }

    final size = screenWidth * config.placeholderSizeRatio;
    final iconSize = size * config.placeholderIconRatio;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: config.placeholderBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          config.placeholderIcon,
          size: iconSize,
          color: config.placeholderIconColor,
        ),
      ),
    );
  }

  Widget _buildThumbnailStrip(BuildContext context) {
    final config = widget.config;
    final thumbSize = config.thumbnailStripHeight - 8;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        controller: _thumbnailController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];
          final isSelected = index == _currentIndex;
          final imageProvider = _getImageProvider(image);

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? config.activeDotColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: imageProvider != null
                    ? Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildThumbnailPlaceholder(config),
                      )
                    : _buildThumbnailPlaceholder(config),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnailPlaceholder(ProfileImageViewerConfig config) {
    return Container(
      color: config.placeholderBackgroundColor,
      child: Icon(
        config.placeholderIcon,
        size: 24,
        color: config.placeholderIconColor,
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    if (widget.pageIndicatorBuilder != null) {
      return widget.pageIndicatorBuilder!(
        context,
        _currentIndex,
        widget.images.length,
      );
    }

    final config = widget.config;

    // Use animated dots if enabled
    if (config.useAnimatedDots) {
      return Center(
        child: AnimatedDotsIndicator(
          count: widget.images.length,
          currentIndex: _currentIndex,
          activeColor: config.activeDotColor,
          inactiveColor: config.inactiveDotColor,
          dotSize: config.dotSize,
        ),
      );
    }

    // Fallback to text indicator
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
