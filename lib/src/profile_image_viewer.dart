import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

import 'profile_image_viewer_config.dart';
import 'profile_image_loader.dart';
import 'shimmer_loading.dart';
import 'screen_protector_stub.dart'
    if (dart.library.io) 'screen_protector_io.dart';

/// Result returned from the ProfileImageViewer when closed.
class ProfileImageViewerResult {
  /// Whether the user performed an action (edit, share, save, etc.).
  final bool actionPerformed;

  /// The action type if an action was performed.
  final String? actionType;

  /// Additional data from the action.
  final dynamic data;

  /// Total view duration in milliseconds.
  final int? viewDurationMs;

  /// Maximum zoom level reached.
  final double? maxZoomReached;

  const ProfileImageViewerResult({
    this.actionPerformed = false,
    this.actionType,
    this.data,
    this.viewDurationMs,
    this.maxZoomReached,
  });
}

/// A fullscreen, WhatsApp-style profile image viewer with:
/// - Pinch-to-zoom using PhotoView
/// - Double-tap to zoom (with zoom to point support)
/// - Swipe-down-to-dismiss gesture (with optional swipe-up)
/// - Hero animation support
/// - Screenshot protection (optional)
/// - Support for network, local file, asset, and memory images
/// - Image rotation support (button and gesture)
/// - Keyboard shortcuts for desktop/web
/// - Zoom level indicator
/// - Image info overlay
/// - Long-press context menu
/// - Blur background effect
/// - Gradient app bar overlay
/// - Accessibility support
/// - Analytics callbacks
/// - Fully customizable via [ProfileImageViewerConfig]
///
/// Example usage:
/// ```dart
/// final result = await ProfileImageViewer.show(
///   context,
///   imageUrl: 'https://example.com/photo.jpg',
///   title: 'Profile Photo',
///   heroTag: 'profile-hero',
/// );
/// ```
class ProfileImageViewer extends StatefulWidget {
  /// URL of the network image to display.
  final String? imageUrl;

  /// Set to true if [imageUrl] is a local file path.
  final bool isLocalFile;

  /// Set to true if [imageUrl] is an asset path.
  final bool isAsset;

  /// Raw image bytes for memory images (e.g., device contacts).
  final Uint8List? imageBytes;

  /// Title shown in the app bar.
  final String title;

  /// Subtitle shown below the title in the app bar.
  final String? subtitle;

  /// Callback when edit action is tapped. If null, edit button is hidden.
  final VoidCallback? onEditTap;

  /// Callback when share action is tapped. If null, share button is hidden.
  final VoidCallback? onShareTap;

  /// Callback when save/download action is tapped. If null, save button is hidden.
  final VoidCallback? onSaveTap;

  /// Hero animation tag. Use the same tag on the source widget.
  final String heroTag;

  /// Configuration for customizing the viewer's appearance and behavior.
  final ProfileImageViewerConfig config;

  /// Custom leading widget for the app bar.
  final Widget? leading;

  /// Custom actions for the app bar (replaces default edit/share buttons).
  final List<Widget>? actions;

  /// Whether to show the default back button.
  final bool showBackButton;

  const ProfileImageViewer({
    super.key,
    this.imageUrl,
    this.isLocalFile = false,
    this.isAsset = false,
    this.imageBytes,
    this.title = 'Profile photo',
    this.subtitle,
    this.onEditTap,
    this.onShareTap,
    this.onSaveTap,
    this.heroTag = 'profile-photo',
    this.config = const ProfileImageViewerConfig(),
    this.leading,
    this.actions,
    this.showBackButton = true,
  });

  /// Convenience method to navigate to the viewer with a push transition.
  /// Returns a [ProfileImageViewerResult] when the viewer is closed.
  static Future<ProfileImageViewerResult?> show(
    BuildContext context, {
    String? imageUrl,
    bool isLocalFile = false,
    bool isAsset = false,
    Uint8List? imageBytes,
    String title = 'Profile photo',
    String? subtitle,
    VoidCallback? onEditTap,
    VoidCallback? onShareTap,
    VoidCallback? onSaveTap,
    String heroTag = 'profile-photo',
    ProfileImageViewerConfig config = const ProfileImageViewerConfig(),
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    return Navigator.of(context).push<ProfileImageViewerResult>(
      MaterialPageRoute(
        builder: (_) => ProfileImageViewer(
          imageUrl: imageUrl,
          isLocalFile: isLocalFile,
          isAsset: isAsset,
          imageBytes: imageBytes,
          title: title,
          subtitle: subtitle,
          onEditTap: onEditTap,
          onShareTap: onShareTap,
          onSaveTap: onSaveTap,
          heroTag: heroTag,
          config: config,
          leading: leading,
          actions: actions,
          showBackButton: showBackButton,
        ),
      ),
    );
  }

  /// Show with a fade transition for smoother Hero animations.
  /// Returns a [ProfileImageViewerResult] when the viewer is closed.
  static Future<ProfileImageViewerResult?> showWithFade(
    BuildContext context, {
    String? imageUrl,
    bool isLocalFile = false,
    bool isAsset = false,
    Uint8List? imageBytes,
    String title = 'Profile photo',
    String? subtitle,
    VoidCallback? onEditTap,
    VoidCallback? onShareTap,
    VoidCallback? onSaveTap,
    String heroTag = 'profile-photo',
    ProfileImageViewerConfig config = const ProfileImageViewerConfig(),
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) {
    return Navigator.of(context).push<ProfileImageViewerResult>(
      PageRouteBuilder(
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfileImageViewer(
          imageUrl: imageUrl,
          isLocalFile: isLocalFile,
          isAsset: isAsset,
          imageBytes: imageBytes,
          title: title,
          subtitle: subtitle,
          onEditTap: onEditTap,
          onShareTap: onShareTap,
          onSaveTap: onSaveTap,
          heroTag: heroTag,
          config: config,
          leading: leading,
          actions: actions,
          showBackButton: showBackButton,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  State<ProfileImageViewer> createState() => _ProfileImageViewerState();
}

class _ProfileImageViewerState extends State<ProfileImageViewer>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0;
  double _dragOpacity = 1.0;
  bool _isDragging = false;
  double _rotationAngle = 0.0;
  double _currentZoom = 1.0;
  double _maxZoomReached = 1.0;
  Offset? _doubleTapPosition;
  PhotoViewController? _photoViewController;
  ProfileImageViewerResult? _result;
  final FocusNode _focusNode = FocusNode();
  DateTime? _viewStartTime;
  ViewerImageInfo? _imageInfo;
  bool _showInfo = false;

  @override
  void initState() {
    super.initState();
    _viewStartTime = DateTime.now();
    _photoViewController = PhotoViewController();

    // Listen to zoom changes
    _photoViewController?.outputStateStream.listen((state) {
      final newZoom = state.scale ?? 1.0;
      if (newZoom != _currentZoom) {
        setState(() {
          _currentZoom = newZoom;
          if (newZoom > _maxZoomReached) {
            _maxZoomReached = newZoom;
          }
        });
        _trackAnalytics('zoom', {'level': newZoom});
      }
    });

    if (widget.config.enableScreenProtection) {
      ScreenProtectorHelper.preventScreenshotOn();
    }

    if (widget.config.hideStatusBar) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );
    }

    _trackAnalytics('view_start', {'title': widget.title});
  }

  @override
  void dispose() {
    _trackAnalytics('view_end', {
      'duration_ms': DateTime.now().difference(_viewStartTime!).inMilliseconds,
      'max_zoom': _maxZoomReached,
    });

    _photoViewController?.dispose();
    _focusNode.dispose();

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

  void _onVerticalDragStart(DragStartDetails details) {
    if (!widget.config.enableSwipeToDismiss) return;
    _isDragging = true;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!widget.config.enableSwipeToDismiss) return;

    final delta = details.delta.dy;
    final allowUp = widget.config.enableSwipeUpToDismiss;

    // Handle swipe down
    if (delta > 0 || _dragOffset > 0) {
      setState(() {
        _dragOffset = (_dragOffset + delta).clamp(0.0, widget.config.maxDragOffset);
        _dragOpacity = (1 - (_dragOffset.abs() / widget.config.maxDragOffset)).clamp(
          widget.config.minOpacity,
          1.0,
        );
      });
    }
    // Handle swipe up if enabled
    else if (allowUp && (delta < 0 || _dragOffset < 0)) {
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
      _trackAnalytics('swipe_dismiss', {'direction': shouldDismissDown ? 'down' : 'up'});
      _close();
    } else {
      setState(() {
        _dragOffset = 0;
        _dragOpacity = 1.0;
      });
    }
  }

  void _handleDoubleTap() {
    if (!widget.config.enableDoubleTapZoom) return;

    final controller = _photoViewController;
    if (controller == null) return;

    final currentScale = controller.scale ?? 1.0;
    final minScale = widget.config.minScale;
    final targetScale = widget.config.doubleTapZoomScale;

    // Toggle between min scale and target scale
    if (currentScale > minScale * 1.1) {
      controller.scale = minScale;
      controller.position = Offset.zero;
    } else {
      controller.scale = targetScale;
      // Zoom to tap point if enabled
      if (widget.config.doubleTapZoomToPoint && _doubleTapPosition != null) {
        final screenSize = MediaQuery.of(context).size;
        final center = Offset(screenSize.width / 2, screenSize.height / 2);
        final offset = center - _doubleTapPosition!;
        controller.position = offset * (targetScale - 1);
      }
    }

    if (widget.config.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    _trackAnalytics('double_tap_zoom', {'scale': controller.scale});
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.globalPosition;
  }

  void _rotateImage() {
    setState(() {
      _rotationAngle = (_rotationAngle + 90) % 360;
    });
    if (widget.config.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    _trackAnalytics('rotate', {'angle': _rotationAngle});
  }

  void _resetRotation() {
    setState(() {
      _rotationAngle = 0;
    });
    if (widget.config.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
  }

  void _setResult(String actionType, [dynamic data]) {
    final duration = DateTime.now().difference(_viewStartTime!).inMilliseconds;
    _result = ProfileImageViewerResult(
      actionPerformed: true,
      actionType: actionType,
      data: data,
      viewDurationMs: duration,
      maxZoomReached: _maxZoomReached,
    );
    _trackAnalytics('action', {'type': actionType});
  }

  void _close() {
    final duration = DateTime.now().difference(_viewStartTime!).inMilliseconds;
    _result ??= ProfileImageViewerResult(
      viewDurationMs: duration,
      maxZoomReached: _maxZoomReached,
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

    // R to rotate
    if (key == LogicalKeyboardKey.keyR) {
      _rotateImage();
      return KeyEventResult.handled;
    }

    // + or = to zoom in
    if (key == LogicalKeyboardKey.equal || key == LogicalKeyboardKey.numpadAdd) {
      final controller = _photoViewController;
      if (controller != null) {
        final newScale = (controller.scale ?? 1.0) * 1.2;
        controller.scale = newScale.clamp(
          widget.config.minScale,
          widget.config.maxScaleMultiplier * 2,
        );
      }
      return KeyEventResult.handled;
    }

    // - to zoom out
    if (key == LogicalKeyboardKey.minus || key == LogicalKeyboardKey.numpadSubtract) {
      final controller = _photoViewController;
      if (controller != null) {
        final newScale = (controller.scale ?? 1.0) / 1.2;
        controller.scale = newScale.clamp(
          widget.config.minScale,
          widget.config.maxScaleMultiplier * 2,
        );
      }
      return KeyEventResult.handled;
    }

    // 0 to reset zoom
    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
      final controller = _photoViewController;
      if (controller != null) {
        controller.scale = widget.config.minScale;
        controller.position = Offset.zero;
      }
      return KeyEventResult.handled;
    }

    // I to toggle info
    if (key == LogicalKeyboardKey.keyI) {
      setState(() {
        _showInfo = !_showInfo;
      });
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _showContextMenu(BuildContext context, Offset position) {
    if (!widget.config.enableContextMenu) return;

    final config = widget.config;
    final actions = config.contextMenuActions ?? [];

    final menuItems = <PopupMenuEntry<String>>[
      if (widget.onSaveTap != null)
        const PopupMenuItem(
          value: 'save',
          child: ListTile(
            leading: Icon(Icons.download),
            title: Text('Save'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      if (widget.onShareTap != null)
        const PopupMenuItem(
          value: 'share',
          child: ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      if (config.enableRotation)
        const PopupMenuItem(
          value: 'rotate',
          child: ListTile(
            leading: Icon(Icons.rotate_right),
            title: Text('Rotate'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      if (config.showImageInfo)
        const PopupMenuItem(
          value: 'info',
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Image Info'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ...actions.map((action) => PopupMenuItem(
            value: 'custom_${action.label}',
            child: ListTile(
              leading: action.icon != null ? Icon(action.icon) : null,
              title: Text(action.label),
              contentPadding: EdgeInsets.zero,
            ),
          )),
    ];

    if (menuItems.isEmpty) return;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: menuItems,
    ).then((value) {
      if (value == null) return;

      switch (value) {
        case 'save':
          _setResult('save');
          widget.onSaveTap?.call();
          break;
        case 'share':
          _setResult('share');
          widget.onShareTap?.call();
          break;
        case 'rotate':
          _rotateImage();
          break;
        case 'info':
          setState(() => _showInfo = !_showInfo);
          break;
        default:
          if (value.startsWith('custom_')) {
            final label = value.substring(7);
            final action = actions.firstWhere((a) => a.label == label);
            action.onTap();
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final semanticLabel = config.semanticLabel ?? 'Profile image of ${widget.title}';

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

              // Main content
              Semantics(
                label: semanticLabel,
                image: true,
                child: GestureDetector(
                  onVerticalDragStart: _onVerticalDragStart,
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragEnd: _onVerticalDragEnd,
                  onDoubleTapDown: _handleDoubleTapDown,
                  onDoubleTap: _handleDoubleTap,
                  onLongPressStart: config.enableContextMenu
                      ? (details) => _showContextMenu(context, details.globalPosition)
                      : null,
                  child: AnimatedContainer(
                    duration: _isDragging ? Duration.zero : config.resetAnimationDuration,
                    transform: Matrix4.translationValues(0, _dragOffset, 0),
                    child: Center(
                      child: Hero(
                        tag: widget.heroTag,
                        child: Transform.rotate(
                          angle: _rotationAngle * 3.14159 / 180,
                          child: _buildImageViewer(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Gradient overlay for app bar
              if (config.showAppBarGradient && _dragOffset == 0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 120,
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

              // Zoom indicator
              if (config.showZoomIndicator && _currentZoom != 1.0)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 60,
                  right: 16,
                  child: _buildZoomIndicator(context),
                ),

              // Image info overlay
              if (_showInfo && _imageInfo != null)
                Positioned(
                  bottom: 100,
                  left: 16,
                  right: 16,
                  child: _buildImageInfoOverlay(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurBackground(BuildContext context) {
    final imageProvider = _getImageProvider();
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

  Widget _buildZoomIndicator(BuildContext context) {
    final config = widget.config;

    if (config.zoomIndicatorBuilder != null) {
      return config.zoomIndicatorBuilder!(context, _currentZoom);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${(_currentZoom * 100).toInt()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageInfoOverlay(BuildContext context) {
    final config = widget.config;
    final info = _imageInfo!;

    if (config.imageInfoBuilder != null) {
      return config.imageInfoBuilder!(context, info);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Image Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow('Dimensions', info.dimensionsString),
          _infoRow('Size', info.sizeString),
          if (info.format != null) _infoRow('Format', info.format!),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    final config = widget.config;

    // Use custom app bar builder if provided
    if (config.appBarBuilder != null) {
      return config.appBarBuilder!(context, widget.title);
    }

    // Build default app bar actions
    final List<Widget> appBarActions = widget.actions ??
        [
          if (config.showImageInfo)
            IconButton(
              icon: Icon(
                _showInfo ? Icons.info : Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () => setState(() => _showInfo = !_showInfo),
              tooltip: 'Image info',
            ),
          if (config.enableRotation)
            IconButton(
              icon: const Icon(Icons.rotate_right, color: Colors.white),
              onPressed: _rotateImage,
              tooltip: 'Rotate image',
            ),
          if (config.enableRotation &&
              config.showRotationResetButton &&
              _rotationAngle != 0)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _resetRotation,
              tooltip: 'Reset rotation',
            ),
          if (widget.onSaveTap != null)
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () {
                _setResult('save');
                widget.onSaveTap!();
              },
              tooltip: 'Save image',
            ),
          if (widget.onEditTap != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                _setResult('edit');
                widget.onEditTap!();
              },
              tooltip: 'Edit image',
            ),
          if (widget.onShareTap != null)
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {
                _setResult('share');
                widget.onShareTap!();
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: _close,
                  tooltip: 'Go back',
                )
              : null),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          if (widget.subtitle != null)
            Text(
              widget.subtitle!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
        ],
      ),
      actions: appBarActions,
    );
  }

  ImageProvider? _getImageProvider() {
    // Memory image (Uint8List)
    if (widget.imageBytes != null && widget.imageBytes!.isNotEmpty) {
      return MemoryImage(widget.imageBytes!);
    }

    // No image
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return null;
    }

    // Asset image
    if (widget.isAsset) {
      return AssetImage(widget.imageUrl!);
    }

    // Local file (only on non-web platforms)
    if (widget.isLocalFile && !kIsWeb) {
      final file = File(widget.imageUrl!);
      if (file.existsSync()) {
        return FileImage(file);
      }
      return null;
    }

    // Network image
    return CachedNetworkImageProvider(
      widget.imageUrl!,
      headers: widget.config.httpHeaders,
      cacheKey: widget.config.cacheKey,
    );
  }

  Widget _buildImageViewer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageProvider = _getImageProvider();

    if (imageProvider == null) {
      return _buildPlaceholder(screenWidth);
    }

    return _buildPhotoView(imageProvider, screenWidth);
  }

  Widget _buildPhotoView(ImageProvider imageProvider, double screenWidth) {
    final config = widget.config;

    return PhotoView(
      controller: _photoViewController,
      imageProvider: imageProvider,
      minScale: PhotoViewComputedScale.contained * config.minScale,
      maxScale: PhotoViewComputedScale.covered * config.maxScaleMultiplier,
      backgroundDecoration: BoxDecoration(
        color: config.useBlurBackground ? Colors.transparent : config.backgroundColor,
      ),
      enableRotation: config.enableRotation,
      onScaleEnd: (context, details, value) {
        // Edge bounce effect when at limits
        final scale = value.scale ?? 1.0;
        if (scale < config.minScale) {
          _photoViewController?.scale = config.minScale;
        } else if (scale > config.maxScaleMultiplier * 2) {
          _photoViewController?.scale = config.maxScaleMultiplier * 2;
        }
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
      errorBuilder: (context, error, stackTrace) {
        if (config.errorBuilder != null) {
          return config.errorBuilder!(context, error);
        }
        return _buildPlaceholder(screenWidth);
      },
    );
  }

  Widget _buildPlaceholder(double screenWidth) {
    final config = widget.config;

    // Use custom placeholder if provided
    if (config.placeholderBuilder != null) {
      return config.placeholderBuilder!(context);
    }

    final size = screenWidth * config.placeholderSizeRatio;
    final iconSize = size * config.placeholderIconRatio;

    return Semantics(
      label: 'No profile image available',
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
}
