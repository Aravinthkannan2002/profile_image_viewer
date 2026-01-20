import 'package:screen_protector/screen_protector.dart';

/// IO implementation of ScreenProtectorHelper using screen_protector package.
class ScreenProtectorHelper {
  /// Enable screenshot protection.
  static void preventScreenshotOn() {
    ScreenProtector.preventScreenshotOn();
  }

  /// Disable screenshot protection.
  static void preventScreenshotOff() {
    ScreenProtector.preventScreenshotOff();
  }
}
