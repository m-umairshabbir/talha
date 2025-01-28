import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CameraPreviewScreen extends StatelessWidget {
  final CameraController? cameraController; // Nullable CameraController
  final VoidCallback onCapture; // Callback for capture button
  final bool isCameraInitialized; // Track if the camera is initialized

  const CameraPreviewScreen({
    required this.cameraController,
    required this.onCapture,
    required this.isCameraInitialized,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Handle uninitialized camera or null controller
    if (!isCameraInitialized || cameraController == null) {
      return const Center(
        child: SpinKitPulse(
          color: Color(0xff253244),
        ),
      );
    }

    // Camera preview with floating action button for capture
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CameraPreview(cameraController!), // Safe usage of cameraController
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            backgroundColor: const Color(0xff253244), // Button background color
            foregroundColor: Colors.white, // Button foreground color
            onPressed: onCapture, // Capture button action
            child: const Icon(
              Icons.camera, // Camera icon
              color: Color(0xffd7e8fc), // Icon color
            ),
          ),
        ),
      ],
    );
  }
}
