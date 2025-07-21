import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/native_features_service.dart';
import '../utils/responsive_helper.dart';

class LocationServiceWidget extends StatefulWidget {
  final Function(Position)? onLocationSelected;
  final String? title;
  final String? description;

  const LocationServiceWidget({
    super.key,
    this.onLocationSelected,
    this.title,
    this.description,
  });

  @override
  State<LocationServiceWidget> createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  Position? _currentLocation;
  bool _isLoading = false;
  String? _locationAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.responsivePadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          if (widget.title != null)
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: ResponsiveHelper.getTextSize(context, 18),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

          if (widget.title != null) const SizedBox(height: 8),

          // Description
          if (widget.description != null)
            Text(
              widget.description!,
              style: TextStyle(
                fontSize: ResponsiveHelper.getTextSize(context, 14),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

          if (widget.description != null) const SizedBox(height: 16),

          // Location info card
          if (_currentLocation != null)
            Container(
              width: double.infinity,
              padding: ResponsiveHelper.responsivePadding(context),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.blue[600],
                        size: ResponsiveHelper.getIconSize(
                          context,
                          baseSize: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getTextSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Latitude: ${_currentLocation!.latitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getTextSize(context, 12),
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Longitude: ${_currentLocation!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getTextSize(context, 12),
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Accuracy: ±${_currentLocation!.accuracy.toStringAsFixed(1)}m',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getTextSize(context, 12),
                      color: Colors.grey[700],
                    ),
                  ),
                  if (_locationAddress != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Address: $_locationAddress',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getTextSize(context, 12),
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // Action buttons
          if (_isLoading)
            Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(
                  'Getting your location...',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getTextSize(context, 14),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                // Get location button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: Icon(
                      Icons.my_location,
                      size: ResponsiveHelper.getIconSize(context),
                    ),
                    label: Text(
                      _currentLocation != null
                          ? 'Update Location'
                          : 'Get Current Location',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getTextSize(context, 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: ResponsiveHelper.responsivePadding(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Clear location button (if location is selected)
                if (_currentLocation != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _clearLocation,
                      icon: Icon(
                        Icons.clear,
                        size: ResponsiveHelper.getIconSize(
                          context,
                          baseSize: 18,
                        ),
                      ),
                      label: Text(
                        'Clear Location',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getTextSize(context, 14),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[600]!),
                        padding: ResponsiveHelper.responsivePadding(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],

                // Location info
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[600],
                        size: ResponsiveHelper.getIconSize(
                          context,
                          baseSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your location will be used for delivery address and nearby store recommendations.',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getTextSize(context, 12),
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (!NativeFeaturesService.isPhysicalDevice) {
      _showErrorDialog(
        'Location not available',
        'Location services are not available on this device.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if location is available
      final isAvailable = await NativeFeaturesService.isLocationAvailable();
      if (!isAvailable) {
        _showLocationPermissionDialog();
        return;
      }

      final position = await NativeFeaturesService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentLocation = position;
        });

        // Get address (this would typically involve reverse geocoding)
        await _getAddressFromCoordinates(position);

        // Haptic feedback
        NativeFeaturesService.lightHapticFeedback();

        // Notify parent widget
        widget.onLocationSelected?.call(position);

        _showSuccessMessage('Location retrieved successfully!');
      } else {
        _showErrorDialog('Location Error', 'Failed to get current location.');
      }
    } catch (e) {
      _showErrorDialog('Location Error', 'Failed to get location: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(Position position) async {
    try {
      // In a real app, you would use a geocoding service like:
      // - Google Geocoding API
      // - Mapbox Geocoding
      // - OpenStreetMap Nominatim

      // For now, we'll simulate an address
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _locationAddress =
            'Near ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      // Address retrieval failed, but location is still valid
      setState(() {
        _locationAddress = 'Address lookup failed';
      });
    }
  }

  void _clearLocation() {
    setState(() {
      _currentLocation = null;
      _locationAddress = null;
    });

    // Haptic feedback
    NativeFeaturesService.selectionHapticFeedback();
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange[600]),
            const SizedBox(width: 8),
            const Text('Location Permission'),
          ],
        ),
        content: const Text(
          'This app needs location permission to provide delivery services and store recommendations. Please enable location permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // In a real app, you might open app settings here
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red[600]),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Utility function to show location service in a bottom sheet
class LocationServiceHelper {
  static Future<Position?> showLocationBottomSheet(
    BuildContext context, {
    String? title,
    String? description,
  }) async {
    Position? selectedLocation;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: LocationServiceWidget(
            title: title ?? 'Set Delivery Location',
            description: description ?? 'We need your location for delivery',
            onLocationSelected: (location) {
              selectedLocation = location;
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );

    return selectedLocation;
  }

  static Future<Position?> showLocationDialog(
    BuildContext context, {
    String? title,
    String? description,
  }) async {
    Position? selectedLocation;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: LocationServiceWidget(
          title: title ?? 'Set Delivery Location',
          description: description ?? 'We need your location for delivery',
          onLocationSelected: (location) {
            selectedLocation = location;
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    return selectedLocation;
  }

  // Utility method to format location for display
  static String formatLocation(Position position) {
    return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }

  // Utility method to calculate distance between two positions
  static double calculateDistance(Position from, Position to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }
}
