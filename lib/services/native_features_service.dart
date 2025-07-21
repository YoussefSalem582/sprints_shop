import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NativeFeaturesService {
  static final ImagePicker _picker = ImagePicker();

  // Camera and Gallery functionality
  static Future<File?> pickImageFromCamera() async {
    try {
      // Request camera permission
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image from camera: $e');
      }
      rethrow;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      // Request photo library permission
      final photoPermission = await Permission.photos.request();
      if (photoPermission != PermissionStatus.granted) {
        throw Exception('Photo library permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image from gallery: $e');
      }
      rethrow;
    }
  }

  // Location functionality
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
      rethrow;
    }
  }

  // Check if device has location capability
  static Future<bool> isLocationAvailable() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      return serviceEnabled &&
          permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }

  // Connectivity functionality
  static Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  // Listen to connectivity changes
  static Stream<ConnectivityResult> get connectivityStream {
    return Connectivity().onConnectivityChanged;
  }

  // Haptic feedback
  static void lightHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  static void mediumHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  static void heavyHapticFeedback() {
    HapticFeedback.heavyImpact();
  }

  static void selectionHapticFeedback() {
    HapticFeedback.selectionClick();
  }

  // Device info helpers
  static bool get isPhysicalDevice {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static bool get isMobileDevice {
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool get isAndroid {
    return Platform.isAndroid;
  }

  static bool get isIOS {
    return Platform.isIOS;
  }

  // Request all necessary permissions at once
  static Future<Map<Permission, PermissionStatus>>
  requestAllPermissions() async {
    return await [
      Permission.camera,
      Permission.photos,
      Permission.location,
      Permission.notification,
    ].request();
  }

  // Check if all critical permissions are granted
  static Future<bool> arePermissionsGranted() async {
    final permissions = await [
      Permission.camera,
      Permission.photos,
      Permission.location,
    ].request();

    return permissions.values.every(
      (status) => status == PermissionStatus.granted,
    );
  }
}
