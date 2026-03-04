import 'package:permission_handler/permission_handler.dart';

class AppPermissionService {
  /// Call this once at app startup to request all required permissions.
  static Future<void> requestAllPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.photos,
      Permission.notification,
    ].request();

    // Log results (optional — remove in production)
    statuses.forEach((permission, status) {
      // ignore: avoid_print
      print('[Permission] $permission → $status');
    });
  }
}
