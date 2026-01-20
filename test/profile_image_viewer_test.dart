import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_image_viewer/profile_image_viewer.dart';

void main() {
  group('ProfileImageViewerConfig', () {
    test('default config has expected values', () {
      const config = ProfileImageViewerConfig();

      expect(config.backgroundColor, Colors.black);
      expect(config.enableSwipeToDismiss, true);
      expect(config.enableScreenProtection, true);
      expect(config.enableHapticFeedback, true);
      expect(config.dismissThreshold, 100.0);
      expect(config.maxDragOffset, 300.0);
      expect(config.minOpacity, 0.3);
    });

    test('whatsApp preset has green loader', () {
      const config = ProfileImageViewerConfig.whatsApp;

      expect(config.loaderColor, const Color(0xFF25D366));
    });

    test('copyWith creates new config with changed values', () {
      const config = ProfileImageViewerConfig();
      final newConfig = config.copyWith(
        backgroundColor: Colors.white,
        enableScreenProtection: false,
      );

      expect(newConfig.backgroundColor, Colors.white);
      expect(newConfig.enableScreenProtection, false);
      // Unchanged values should remain
      expect(newConfig.enableSwipeToDismiss, true);
    });
  });

  group('ProfileImageLoader', () {
    testWidgets('renders with default values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileImageLoader(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileImageLoader(size: 60.0),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 60.0);
      expect(sizedBox.height, 60.0);
    });
  });

  group('ProfileImageViewer', () {
    testWidgets('creates widget with default values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileImageViewer(),
        ),
      );

      // Should show placeholder since no image provided
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('shows title in app bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileImageViewer(
            title: 'Test Title',
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('shows edit button when onEditTap provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileImageViewer(
            onEditTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('shows share button when onShareTap provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProfileImageViewer(
            onShareTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('hides action buttons when callbacks not provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileImageViewer(),
        ),
      );

      expect(find.byIcon(Icons.edit), findsNothing);
      expect(find.byIcon(Icons.share), findsNothing);
    });

    testWidgets('shows back button by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileImageViewer(),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('hides back button when showBackButton is false',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileImageViewer(
            showBackButton: false,
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsNothing);
    });
  });
}
