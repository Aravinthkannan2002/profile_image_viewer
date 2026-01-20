import 'package:flutter/material.dart';
import 'package:profile_image_viewer/profile_image_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Image Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<DemoUser> users = [
    DemoUser(
      name: 'Sarah Wilson',
      role: 'Product Designer',
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    ),
    DemoUser(
      name: 'James Chen',
      role: 'Software Engineer',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
    ),
    DemoUser(
      name: 'Emily Rodriguez',
      role: 'Marketing Lead',
      image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
    ),
    DemoUser(
      name: 'Michael Park',
      role: 'Data Scientist',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    ),
    DemoUser(
      name: 'Lisa Thompson',
      role: 'UX Researcher',
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar.large(
            title: const Text('Profile Viewer'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showAboutDialog(context),
              ),
            ],
          ),

          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Text(
                'Tap any profile to preview. Try pinch-to-zoom, double-tap, and swipe down to dismiss.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Gallery Section
          SliverToBoxAdapter(
            child: _buildSection(
              context,
              title: 'Gallery Mode',
              subtitle: 'View multiple images with swipe navigation',
              child: _GalleryCard(users: users),
            ),
          ),

          // Theme Presets Section
          SliverToBoxAdapter(
            child: _buildSection(
              context,
              title: 'Theme Presets',
              subtitle: 'Pre-configured styles for popular apps',
              child: _ThemePresetsGrid(users: users),
            ),
          ),

          // Features Section
          SliverToBoxAdapter(
            child: _buildSection(
              context,
              title: 'Features',
              subtitle: 'Explore individual capabilities',
              child: _FeaturesList(users: users, isDark: isDark),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Image Viewer'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A customizable, WhatsApp-style profile image viewer for Flutter.'),
            SizedBox(height: 16),
            Text('Features:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Pinch-to-zoom & double-tap zoom'),
            Text('• Swipe-to-dismiss gesture'),
            Text('• Hero animations'),
            Text('• Gallery with slideshow'),
            Text('• Multiple theme presets'),
            Text('• Keyboard shortcuts'),
            Text('• And much more...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Data Model
class DemoUser {
  final String name;
  final String role;
  final String image;

  const DemoUser({required this.name, required this.role, required this.image});
}

// Gallery Card
class _GalleryCard extends StatelessWidget {
  final List<DemoUser> users;

  const _GalleryCard({required this.users});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openGallery(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Stacked Avatars
              SizedBox(
                width: 100,
                height: 56,
                child: Stack(
                  children: [
                    for (int i = 0; i < 4; i++)
                      Positioned(
                        left: i * 22.0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.colorScheme.surface, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(users[i].image),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${users.length} Photos',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thumbnails • Slideshow • Animated dots',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) {
    ProfileImageGallery.showWithFade(
      context,
      images: users
          .map((u) => GalleryImage.network(u.image, title: u.name, subtitle: u.role))
          .toList(),
      config: const ProfileImageViewerConfig(
        useAnimatedDots: true,
        showThumbnailStrip: true,
        enableSlideshow: true,
        slideshowInterval: Duration(seconds: 4),
        showAppBarGradient: true,
        useBlurBackground: true,
        precacheImages: true,
      ),
      onSaveTap: (i) => _showSnackBar(context, 'Save ${users[i].name}\'s photo'),
      onShareTap: (i) => _showSnackBar(context, 'Share ${users[i].name}\'s photo'),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }
}

// Theme Presets Grid
class _ThemePresetsGrid extends StatelessWidget {
  final List<DemoUser> users;

  const _ThemePresetsGrid({required this.users});

  @override
  Widget build(BuildContext context) {
    final presets = [
      _ThemePreset('WhatsApp', const Color(0xFF25D366), ProfileImageViewerConfig.whatsApp, users[0]),
      _ThemePreset('Instagram', const Color(0xFFE1306C), ProfileImageViewerConfig.instagram, users[1]),
      _ThemePreset('Telegram', const Color(0xFF5EBBEA), ProfileImageViewerConfig.telegram, users[2]),
      _ThemePreset('Twitter', const Color(0xFF1DA1F2), ProfileImageViewerConfig.twitter, users[3]),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: presets.length,
      itemBuilder: (context, index) => _ThemePresetCard(preset: presets[index]),
    );
  }
}

class _ThemePreset {
  final String name;
  final Color color;
  final ProfileImageViewerConfig config;
  final DemoUser user;

  _ThemePreset(this.name, this.color, this.config, this.user);
}

class _ThemePresetCard extends StatelessWidget {
  final _ThemePreset preset;

  const _ThemePresetCard({required this.preset});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'preset-${preset.name}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(preset.user.image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preset.name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: preset.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    ProfileImageViewer.showWithFade(
      context,
      imageUrl: preset.user.image,
      title: preset.user.name,
      subtitle: '${preset.name} Theme',
      heroTag: 'preset-${preset.name}',
      config: preset.config,
    );
  }
}

// Features List
class _FeaturesList extends StatelessWidget {
  final List<DemoUser> users;
  final bool isDark;

  const _FeaturesList({required this.users, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final features = [
      _Feature(
        icon: Icons.zoom_in,
        title: 'Zoom Indicator',
        subtitle: 'Shows zoom percentage',
        user: users[0],
        config: const ProfileImageViewerConfig(
          showZoomIndicator: true,
          enableDoubleTapZoom: true,
          doubleTapZoomToPoint: true,
        ),
      ),
      _Feature(
        icon: Icons.rotate_right,
        title: 'Rotation',
        subtitle: 'Rotate with button or gesture',
        user: users[1],
        config: const ProfileImageViewerConfig(
          enableRotation: true,
          showRotationResetButton: true,
        ),
      ),
      _Feature(
        icon: Icons.blur_on,
        title: 'Blur Background',
        subtitle: 'Blurred image as background',
        user: users[2],
        config: const ProfileImageViewerConfig(
          useBlurBackground: true,
          showAppBarGradient: true,
        ),
      ),
      _Feature(
        icon: Icons.menu,
        title: 'Context Menu',
        subtitle: 'Long-press for options',
        user: users[3],
        config: const ProfileImageViewerConfig(
          enableContextMenu: true,
          showImageInfo: true,
        ),
        hasActions: true,
      ),
      _Feature(
        icon: Icons.auto_awesome,
        title: 'Shimmer Loading',
        subtitle: 'Animated loading effect',
        user: users[4],
        config: const ProfileImageViewerConfig(
          useShimmerLoading: true,
        ),
      ),
      _Feature(
        icon: Icons.analytics_outlined,
        title: 'Analytics',
        subtitle: 'Track user interactions',
        user: users[0],
        config: null, // Special handling
        isAnalytics: true,
      ),
      _Feature(
        icon: Icons.person_off_outlined,
        title: 'Empty Placeholder',
        subtitle: 'No image available state',
        user: users[0],
        config: null, // Special handling
        isEmpty: true,
      ),
    ];

    return Column(
      children: features.map((f) => _FeatureCard(feature: f, isDark: isDark)).toList(),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  final DemoUser user;
  final ProfileImageViewerConfig? config;
  final bool hasActions;
  final bool isAnalytics;
  final bool isEmpty;

  _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.user,
    required this.config,
    this.hasActions = false,
    this.isAnalytics = false,
    this.isEmpty = false,
  });
}

class _FeatureCard extends StatelessWidget {
  final _Feature feature;
  final bool isDark;

  const _FeatureCard({required this.feature, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(feature.icon, color: theme.colorScheme.primary),
        ),
        title: Text(feature.title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(feature.subtitle),
        trailing: Hero(
          tag: 'feature-${feature.title}',
          child: feature.isEmpty
              ? CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant),
                )
              : CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(feature.user.image),
                ),
        ),
        onTap: () => _open(context),
      ),
    );
  }

  void _open(BuildContext context) {
    if (feature.isAnalytics) {
      _openWithAnalytics(context);
      return;
    }

    if (feature.isEmpty) {
      _openEmpty(context);
      return;
    }

    ProfileImageViewer.showWithFade(
      context,
      imageUrl: feature.user.image,
      title: feature.user.name,
      subtitle: feature.title,
      heroTag: 'feature-${feature.title}',
      config: feature.config ?? const ProfileImageViewerConfig(),
      onSaveTap: feature.hasActions ? () => _showSnackBar(context, 'Save tapped') : null,
      onEditTap: feature.hasActions ? () => _showSnackBar(context, 'Edit tapped') : null,
      onShareTap: feature.hasActions ? () => _showSnackBar(context, 'Share tapped') : null,
    );
  }

  void _openEmpty(BuildContext context) {
    ProfileImageViewer.showWithFade(
      context,
      imageUrl: null,
      title: 'No Photo',
      subtitle: 'Placeholder Demo',
      heroTag: 'feature-${feature.title}',
      config: const ProfileImageViewerConfig(
        placeholderIcon: Icons.person,
        placeholderSizeRatio: 0.5,
      ),
    );
  }

  void _openWithAnalytics(BuildContext context) async {
    final result = await ProfileImageViewer.showWithFade(
      context,
      imageUrl: feature.user.image,
      title: feature.user.name,
      subtitle: 'Analytics Demo',
      heroTag: 'feature-${feature.title}',
      config: ProfileImageViewerConfig(
        showZoomIndicator: true,
        enableDoubleTapZoom: true,
        onAnalyticsEvent: (event, data) {
          debugPrint('📊 $event: $data');
        },
      ),
    );

    if (result != null && context.mounted) {
      final duration = (result.viewDurationMs ?? 0) / 1000;
      final zoom = result.maxZoomReached?.toStringAsFixed(1) ?? '1.0';
      _showSnackBar(context, 'Viewed ${duration.toStringAsFixed(1)}s • Max zoom: ${zoom}x');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
