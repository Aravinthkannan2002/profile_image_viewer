## 1.0.2

- Fixed demo GIF URL to use absolute GitHub raw URL for pub.dev compatibility

## 1.0.1

- Added demo GIF to README
- Added Empty Placeholder feature demo to example app
- Updated documentation

## 1.0.0

### Features

#### Core Viewer
- WhatsApp-style profile image viewer
- Pinch-to-zoom with PhotoView
- Double-tap to zoom with zoom-to-point support
- Swipe-down-to-dismiss gesture (with optional swipe-up)
- Hero animation support
- Screenshot protection (optional, mobile only)
- Support for network, local file, asset, and memory images

#### Image Gallery
- Image gallery with horizontal swipe navigation
- Animated page indicator dots (worm, expanding, jumping, scale effects)
- Thumbnail strip for quick navigation
- Auto-slideshow mode with configurable interval
- Image precaching for smooth transitions

#### UI Enhancements
- Zoom level indicator overlay
- Image info overlay
- Blur background effect
- Gradient app bar overlay
- Shimmer loading effect
- Long-press context menu with custom actions

#### Additional Features
- Image rotation support (button and gesture)
- Download progress indicator
- Accessibility support with semantic labels
- Keyboard shortcuts for desktop/web
- Analytics callbacks for tracking user interactions
- Return value with view duration and max zoom reached

#### Theme Presets
- WhatsApp theme (green accents)
- Instagram theme (gradient accents)
- Telegram theme (blue accents)
- Twitter/X theme
- Dark theme
- Light theme
- Minimal theme
- Full-featured preset (all features enabled)
- `fromTheme()` factory to match your app theme

#### Platform Support
- Android, iOS, macOS, Windows, Linux, Web
- Web platform compatible (screenshot protection disabled on web)

### Configuration Options
- Fully customizable via `ProfileImageViewerConfig`
- Custom builders for loading, error, placeholder, and app bar
- Over 40 configuration options available
