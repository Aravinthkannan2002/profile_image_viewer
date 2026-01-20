/// A customizable, WhatsApp-style profile image viewer for Flutter.
///
/// Features:
/// - Pinch-to-zoom with PhotoView
/// - Double-tap to zoom (with zoom-to-point support)
/// - Swipe-down-to-dismiss gesture (with optional swipe-up)
/// - Hero animation support
/// - Screenshot protection (optional, mobile only)
/// - Support for network, local file, asset, and memory images
/// - Image gallery with horizontal swipe navigation
/// - Image rotation support (button and gesture)
/// - Download progress indicator
/// - Accessibility support
/// - Keyboard shortcuts for desktop/web
/// - Zoom level indicator
/// - Image info overlay
/// - Long-press context menu
/// - Blur background effect
/// - Gradient app bar overlay
/// - Animated page indicator dots
/// - Thumbnail strip for gallery
/// - Auto-slideshow mode
/// - Image precaching
/// - Analytics callbacks
/// - Shimmer loading effect
/// - Multiple theme presets (WhatsApp, Instagram, Telegram, Twitter, etc.)
/// - Web platform compatible
///
/// Example:
/// ```dart
/// import 'package:profile_image_viewer/profile_image_viewer.dart';
///
/// // Simple usage
/// final result = await ProfileImageViewer.show(
///   context,
///   imageUrl: 'https://example.com/photo.jpg',
///   title: 'Profile Photo',
/// );
///
/// // With Hero animation
/// GestureDetector(
///   onTap: () => ProfileImageViewer.showWithFade(
///     context,
///     imageUrl: imageUrl,
///     heroTag: 'profile-$userId',
///   ),
///   child: Hero(
///     tag: 'profile-$userId',
///     child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
///   ),
/// );
///
/// // Gallery with multiple images
/// final result = await ProfileImageGallery.show(
///   context,
///   images: [
///     GalleryImage.network('https://example.com/photo1.jpg', title: 'Photo 1'),
///     GalleryImage.network('https://example.com/photo2.jpg', title: 'Photo 2'),
///     GalleryImage.asset('assets/images/photo3.jpg', title: 'Photo 3'),
///   ],
///   initialIndex: 0,
/// );
///
/// // Using theme presets
/// ProfileImageViewer.show(
///   context,
///   imageUrl: imageUrl,
///   config: ProfileImageViewerConfig.instagram,
/// );
///
/// // Creating config from app theme
/// ProfileImageViewer.show(
///   context,
///   imageUrl: imageUrl,
///   config: ProfileImageViewerConfig.fromTheme(Theme.of(context)),
/// );
///
/// // Full-featured configuration
/// ProfileImageViewer.show(
///   context,
///   imageUrl: imageUrl,
///   config: ProfileImageViewerConfig.fullFeatured,
/// );
///
/// // With analytics
/// ProfileImageViewer.show(
///   context,
///   imageUrl: imageUrl,
///   config: ProfileImageViewerConfig(
///     onAnalyticsEvent: (event, data) {
///       analytics.logEvent(event, data);
///     },
///   ),
/// );
/// ```
library;

export 'src/profile_image_viewer.dart'
    show ProfileImageViewer, ProfileImageViewerResult;
export 'src/profile_image_viewer_config.dart'
    show ProfileImageViewerConfig, ContextMenuAction, AnalyticsCallback, ViewerImageInfo;
export 'src/profile_image_loader.dart';
export 'src/profile_image_gallery.dart'
    show ProfileImageGallery, ProfileImageGalleryResult, GalleryImage;
export 'src/shimmer_loading.dart' show ShimmerLoading, ShimmerContainer;
export 'src/animated_dots_indicator.dart'
    show AnimatedDotsIndicator, SmoothPageIndicator, IndicatorEffect;
