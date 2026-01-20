# Profile Image Viewer

[![pub package](https://img.shields.io/pub/v/profile_image_viewer.svg)](https://pub.dev/packages/profile_image_viewer)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)

A customizable, WhatsApp-style profile image viewer for Flutter with pinch-to-zoom, swipe-to-dismiss gestures, Hero animations, image gallery, and screenshot protection.

## Features

### Core Features
- **Pinch-to-Zoom** - Smooth zoom powered by PhotoView
- **Double-tap to Zoom** - Zoom to point with configurable scale
- **Swipe-to-Dismiss** - Drag down (or up) to close with opacity fade
- **Hero Animations** - Seamless transitions from thumbnails
- **Screenshot Protection** - Prevent screen capture (mobile only)

### Gallery Features
- **Image Gallery** - Horizontal swipe navigation for multiple images
- **Thumbnail Strip** - Quick navigation via thumbnail preview
- **Auto-Slideshow** - Automatic image advancement with configurable interval
- **Animated Page Indicators** - Multiple indicator styles (worm, expanding, jumping, scale)
- **Image Precaching** - Preload adjacent images for smooth transitions

### UI Enhancements
- **Zoom Level Indicator** - Real-time zoom percentage display
- **Image Info Overlay** - Display image metadata and details
- **Blur Background** - Blurred image as background effect
- **Gradient App Bar** - Smooth gradient overlay on app bar
- **Shimmer Loading** - Animated loading placeholder effect
- **Context Menu** - Long-press for custom actions

### Additional Features
- **Image Rotation** - Button or gesture-based rotation
- **Keyboard Shortcuts** - Full desktop/web keyboard support
- **Accessibility** - Screen reader support with semantic labels
- **Analytics Callbacks** - Track user interactions
- **Multiple Image Sources** - Network, asset, local file, and memory images
- **Empty Placeholder** - Customizable placeholder when no image is available
- **Theme Presets** - WhatsApp, Instagram, Telegram, Twitter, and more

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  profile_image_viewer: ^1.0.0
```

Or install via command line:

```bash
flutter pub add profile_image_viewer
```

## Quick Start

### Basic Usage

```dart
import 'package:profile_image_viewer/profile_image_viewer.dart';

// Simple navigation
ProfileImageViewer.show(
  context,
  imageUrl: 'https://example.com/photo.jpg',
  title: 'Profile Photo',
);
```

### With Hero Animation

```dart
// In your list/grid
GestureDetector(
  onTap: () => ProfileImageViewer.showWithFade(
    context,
    imageUrl: imageUrl,
    heroTag: 'profile-$userId',
    title: userName,
  ),
  child: Hero(
    tag: 'profile-$userId',
    child: CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
    ),
  ),
);
```

### Image Gallery

```dart
ProfileImageGallery.show(
  context,
  images: [
    GalleryImage.network('https://example.com/photo1.jpg', title: 'Photo 1'),
    GalleryImage.network('https://example.com/photo2.jpg', title: 'Photo 2'),
    GalleryImage.asset('assets/images/photo3.jpg', title: 'Photo 3'),
  ],
  initialIndex: 0,
  config: const ProfileImageViewerConfig(
    useAnimatedDots: true,
    showThumbnailStrip: true,
    enableSlideshow: true,
  ),
);
```

## Theme Presets

Choose from pre-configured themes to match popular apps:

```dart
// WhatsApp style (green accents)
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig.whatsApp,
);

// Instagram style (gradient accents)
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig.instagram,
);

// Telegram style (blue accents)
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig.telegram,
);

// Twitter/X style
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig.twitter,
);

// Match your app theme
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig.fromTheme(Theme.of(context)),
);

// Full-featured (all features enabled)
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig.fullFeatured,
);
```

## Configuration

### Custom Configuration

```dart
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig(
    // Colors
    backgroundColor: Colors.black,
    loaderColor: Colors.purple,

    // Zoom
    enableDoubleTapZoom: true,
    doubleTapZoomScale: 2.5,
    doubleTapZoomToPoint: true,
    showZoomIndicator: true,

    // Swipe behavior
    enableSwipeToDismiss: true,
    enableSwipeUpToDismiss: true,
    dismissThreshold: 100.0,

    // Visual effects
    useBlurBackground: true,
    showAppBarGradient: true,
    useShimmerLoading: true,

    // Rotation
    enableRotation: true,
    showRotationResetButton: true,

    // Context menu
    enableContextMenu: true,
    contextMenuActions: [
      ContextMenuAction(
        icon: Icons.download,
        label: 'Download',
        onTap: () => downloadImage(),
      ),
    ],

    // Features
    enableScreenProtection: true,
    enableHapticFeedback: true,
  ),
);
```

### Gallery Configuration

```dart
ProfileImageGallery.show(
  context,
  images: images,
  config: ProfileImageViewerConfig(
    // Page indicators
    useAnimatedDots: true,
    indicatorEffect: IndicatorEffect.worm,

    // Thumbnail strip
    showThumbnailStrip: true,
    thumbnailSize: 48.0,

    // Slideshow
    enableSlideshow: true,
    slideshowInterval: Duration(seconds: 5),

    // Precaching
    precacheImages: true,
    precacheCount: 2,
  ),
);
```

### Analytics Tracking

```dart
ProfileImageViewer.show(
  context,
  imageUrl: imageUrl,
  config: ProfileImageViewerConfig(
    onAnalyticsEvent: (event, data) {
      // Track events: view_started, zoom_changed, rotation_changed,
      // swipe_dismissed, double_tap_zoom, context_menu_opened, etc.
      analytics.logEvent(event, data);
    },
  ),
);

// Get result after viewer closes
final result = await ProfileImageViewer.show(context, imageUrl: imageUrl);
print('View duration: ${result?.viewDurationMs}ms');
print('Max zoom reached: ${result?.maxZoomReached}x');
```

## Image Sources

```dart
// Network image
ProfileImageViewer.show(context, imageUrl: 'https://example.com/photo.jpg');

// Asset image
ProfileImageViewer.show(context, assetPath: 'assets/images/photo.jpg');

// Local file
ProfileImageViewer.show(context, imageUrl: '/path/to/file.jpg', isLocalFile: true);

// Memory bytes
ProfileImageViewer.show(context, imageBytes: uint8ListData);

// No image (shows placeholder)
ProfileImageViewer.show(
  context,
  imageUrl: null,
  title: 'No Photo',
  config: ProfileImageViewerConfig(
    placeholderIcon: Icons.person,
    placeholderSizeRatio: 0.5,
  ),
);

// Gallery with mixed sources
ProfileImageGallery.show(context, images: [
  GalleryImage.network('https://example.com/photo.jpg'),
  GalleryImage.asset('assets/photo.png'),
  GalleryImage.file(File('/path/to/photo.jpg')),
  GalleryImage.memory(uint8ListBytes),
]);
```

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Escape` | Close viewer |
| `R` | Rotate image 90° |
| `+` / `=` | Zoom in |
| `-` | Zoom out |
| `0` | Reset zoom |
| `←` / `→` | Previous/Next image (gallery) |
| `Home` / `End` | First/Last image (gallery) |
| `Space` | Toggle slideshow (gallery) |

## API Reference

### ProfileImageViewer Methods

| Method | Description |
|--------|-------------|
| `show()` | Show viewer with standard navigation |
| `showWithFade()` | Show viewer with fade transition |

### ProfileImageViewer Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `imageUrl` | `String?` | `null` | URL or path to the image |
| `assetPath` | `String?` | `null` | Asset path for bundled images |
| `imageBytes` | `Uint8List?` | `null` | Raw image bytes |
| `isLocalFile` | `bool` | `false` | Set true for local file paths |
| `title` | `String` | `'Profile photo'` | App bar title |
| `subtitle` | `String?` | `null` | App bar subtitle |
| `heroTag` | `String` | `'profile-photo'` | Hero animation tag |
| `config` | `ProfileImageViewerConfig` | default | Configuration |
| `onSaveTap` | `VoidCallback?` | `null` | Save/download callback |
| `onEditTap` | `VoidCallback?` | `null` | Edit button callback |
| `onShareTap` | `VoidCallback?` | `null` | Share button callback |

### ProfileImageViewerConfig Options

<details>
<summary>View all configuration options</summary>

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backgroundColor` | `Color` | `Colors.black` | Background color |
| `loaderColor` | `Color` | `#004C99` | Loader color |
| `enableSwipeToDismiss` | `bool` | `true` | Enable swipe down gesture |
| `enableSwipeUpToDismiss` | `bool` | `false` | Enable swipe up gesture |
| `dismissThreshold` | `double` | `100.0` | Drag distance to dismiss |
| `enableScreenProtection` | `bool` | `true` | Prevent screenshots |
| `enableHapticFeedback` | `bool` | `true` | Haptic on dismiss |
| `enableDoubleTapZoom` | `bool` | `true` | Double-tap to zoom |
| `doubleTapZoomScale` | `double` | `2.0` | Double-tap zoom level |
| `doubleTapZoomToPoint` | `bool` | `true` | Zoom to tap point |
| `showZoomIndicator` | `bool` | `false` | Show zoom percentage |
| `enableRotation` | `bool` | `false` | Enable image rotation |
| `showRotationResetButton` | `bool` | `false` | Show reset button |
| `useBlurBackground` | `bool` | `false` | Blurred background |
| `showAppBarGradient` | `bool` | `false` | Gradient on app bar |
| `useShimmerLoading` | `bool` | `false` | Shimmer loading effect |
| `enableContextMenu` | `bool` | `false` | Long-press menu |
| `showImageInfo` | `bool` | `false` | Show image info overlay |
| `useAnimatedDots` | `bool` | `false` | Animated page dots |
| `indicatorEffect` | `IndicatorEffect` | `worm` | Dot animation style |
| `showThumbnailStrip` | `bool` | `false` | Show thumbnail strip |
| `thumbnailSize` | `double` | `48.0` | Thumbnail dimensions |
| `enableSlideshow` | `bool` | `false` | Enable auto-slideshow |
| `slideshowInterval` | `Duration` | `3s` | Slideshow timing |
| `precacheImages` | `bool` | `false` | Preload images |
| `precacheCount` | `int` | `1` | Images to preload |
| `onAnalyticsEvent` | `Function?` | `null` | Analytics callback |

</details>

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android | ✅ | Full support |
| iOS | ✅ | Full support |
| Web | ✅ | No screenshot protection |
| macOS | ✅ | Full support |
| Windows | ✅ | Full support |
| Linux | ✅ | Full support |

## Dependencies

- [cached_network_image](https://pub.dev/packages/cached_network_image) - Network image caching
- [photo_view](https://pub.dev/packages/photo_view) - Pinch-to-zoom functionality
- [screen_protector](https://pub.dev/packages/screen_protector) - Screenshot prevention

## Example

Check out the [example](example/) directory for a complete demo app showcasing all features.

```bash
cd example
flutter run
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
