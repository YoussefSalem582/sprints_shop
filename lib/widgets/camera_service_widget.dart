import 'dart:io';
import 'package:flutter/material.dart';
import '../services/native_features_service.dart';
import '../utils/responsive_helper.dart';

class CameraServiceWidget extends StatefulWidget {
  final Function(File)? onImageSelected;
  final String? title;
  final String? description;

  const CameraServiceWidget({
    super.key,
    this.onImageSelected,
    this.title,
    this.description,
  });

  @override
  State<CameraServiceWidget> createState() => _CameraServiceWidgetState();
}

class _CameraServiceWidgetState extends State<CameraServiceWidget> {
  File? _selectedImage;
  bool _isLoading = false;

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

          // Image preview
          if (_selectedImage != null)
            Container(
              height: ResponsiveHelper.responsive(
                context,
                mobile: 200.0,
                tablet: 250.0,
                desktop: 300.0,
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              ),
            ),

          // Action buttons
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Column(
              children: [
                // Camera and Gallery buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _takePicture,
                        icon: Icon(
                          Icons.camera_alt,
                          size: ResponsiveHelper.getIconSize(context),
                        ),
                        label: Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getTextSize(context, 14),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickFromGallery,
                        icon: Icon(
                          Icons.photo_library,
                          size: ResponsiveHelper.getIconSize(context),
                        ),
                        label: Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getTextSize(context, 14),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: ResponsiveHelper.responsivePadding(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Clear button (if image is selected)
                if (_selectedImage != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _clearImage,
                      icon: Icon(
                        Icons.clear,
                        size: ResponsiveHelper.getIconSize(
                          context,
                          baseSize: 18,
                        ),
                      ),
                      label: Text(
                        'Clear Image',
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
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (!NativeFeaturesService.isPhysicalDevice) {
      _showErrorDialog(
        'Camera not available',
        'Camera is not available on this device.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final image = await NativeFeaturesService.pickImageFromCamera();
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });

        // Haptic feedback
        NativeFeaturesService.lightHapticFeedback();

        // Notify parent widget
        widget.onImageSelected?.call(image);

        _showSuccessMessage('Photo taken successfully!');
      }
    } catch (e) {
      _showErrorDialog('Camera Error', 'Failed to take picture: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final image = await NativeFeaturesService.pickImageFromGallery();
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });

        // Haptic feedback
        NativeFeaturesService.lightHapticFeedback();

        // Notify parent widget
        widget.onImageSelected?.call(image);

        _showSuccessMessage('Image selected successfully!');
      }
    } catch (e) {
      _showErrorDialog('Gallery Error', 'Failed to pick image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });

    // Haptic feedback
    NativeFeaturesService.selectionHapticFeedback();
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
            Icon(Icons.check_circle, color: Colors.white),
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

// Utility function to show camera service in a bottom sheet
class CameraServiceHelper {
  static Future<File?> showCameraBottomSheet(
    BuildContext context, {
    String? title,
    String? description,
  }) async {
    File? selectedImage;

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
          child: CameraServiceWidget(
            title: title ?? 'Add Photo',
            description: description ?? 'Take a photo or select from gallery',
            onImageSelected: (image) {
              selectedImage = image;
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );

    return selectedImage;
  }

  static Future<File?> showCameraDialog(
    BuildContext context, {
    String? title,
    String? description,
  }) async {
    File? selectedImage;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: CameraServiceWidget(
          title: title ?? 'Add Photo',
          description: description ?? 'Take a photo or select from gallery',
          onImageSelected: (image) {
            selectedImage = image;
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    return selectedImage;
  }
}
