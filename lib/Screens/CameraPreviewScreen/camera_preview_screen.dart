import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ImagePreviewScreen/image_picker_screen.dart';

class CameraPreviewScreen extends StatefulWidget {
  final CameraController? cameraController;
  final VoidCallback onCapture;
  final bool isCameraInitialized;

  const CameraPreviewScreen({
    required this.cameraController,
    required this.onCapture,
    required this.isCameraInitialized,
    super.key,
  });

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  bool _isRecording = false;
  List<String> _videoPaths = [];
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadSavedMedia(); // Load saved videos & images
  }

  void _showNotification(String message, IconData icon, Color color) {
    Flushbar(
      message: message,
      icon: Icon(icon, size: 28, color: Colors.white),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: color,
      margin: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  Future<void> _captureImage() async {
    if (widget.cameraController == null || !widget.isCameraInitialized) return;
    try {
      final XFile? image = await widget.cameraController!.takePicture();
      if (image != null) {
        final savedPath = await _saveImageToLocal(image.path);
        setState(() => _imagePaths.add(savedPath));
        await _saveImagePathsToStorage();
        _showNotification("Image Captured Successfully!", Icons.camera_alt, Colors.green);
      }
    } catch (e) {
      _showNotification("Error capturing image", Icons.error, Colors.red);
      print("Error capturing image: $e");
    }
  }

  Future<void> _startVideoRecording() async {
    if (_isRecording || widget.cameraController == null || !widget.isCameraInitialized) return;
    try {
      await widget.cameraController!.startVideoRecording();
      if (mounted) {
        setState(() => _isRecording = true);
      }
      _showNotification("Video Recording Started", Icons.videocam, Colors.blue);
    } catch (e) {
      _showNotification("Error starting video recording", Icons.error, Colors.red);
      print("Error starting video recording: $e");
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_isRecording || widget.cameraController == null || !widget.isCameraInitialized) return;
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay to ensure smooth stop
      final XFile? video = await widget.cameraController!.stopVideoRecording();
      if (video != null) {
        final savedPath = await _saveVideoToLocal(video.path);
        setState(() => _videoPaths.add(savedPath));
        await _saveVideoPathsToStorage();
        _showNotification("Video Saved Successfully!", Icons.save, Colors.green);
      } else {
        _showNotification("Failed to stop video recording", Icons.error, Colors.red);
      }
    } catch (e) {
      _showNotification("Error stopping video: ${e.toString()}", Icons.error, Colors.red);
      print("Error stopping video recording: $e");
    }
  }

  Future<String> _saveImageToLocal(String originalPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
    final savedPath = "${directory.path}/$fileName";
    await File(originalPath).copy(savedPath);
    return savedPath;
  }

  Future<void> _saveImagePathsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_images', _imagePaths);
  }

  Future<String> _saveVideoToLocal(String originalPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = "video_${DateTime.now().millisecondsSinceEpoch}.mp4";
    final savedPath = "${directory.path}/$fileName";
    await File(originalPath).copy(savedPath);
    return savedPath;
  }

  Future<void> _saveVideoPathsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_videos', _videoPaths);
  }

  Future<void> _loadSavedMedia() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePaths = prefs.getStringList('saved_images') ?? [];
      _videoPaths = prefs.getStringList('saved_videos') ?? [];
    });
  }

  void _navigateToImagesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CapturedImagesScreen(imagePaths: _imagePaths),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isCameraInitialized || widget.cameraController == null) {
      return const Center(child: SpinKitPulse(color: Color(0xff253244)));
    }

    final size = MediaQuery.of(context).size;
    final double aspectRatio = widget.cameraController!.value.aspectRatio;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: CameraPreview(widget.cameraController!),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: const Color(0xff253244),
                foregroundColor: Colors.white,
                onPressed: _captureImage,
                child: const Icon(Icons.camera, color: Color(0xffd7e8fc)),
              ),

              const SizedBox(width: 20),
              FloatingActionButton(
                backgroundColor: _isRecording ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
                onPressed: _isRecording ? _stopVideoRecording : _startVideoRecording,
                child: Icon(_isRecording ? Icons.stop : Icons.videocam),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
