import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CapturedVideosScreen extends StatefulWidget {
  final List<String> videoPaths;

  const CapturedVideosScreen({required this.videoPaths, super.key});

  @override
  _CapturedVideosScreenState createState() => _CapturedVideosScreenState();
}

class _CapturedVideosScreenState extends State<CapturedVideosScreen> {
  void _openFullScreenVideo(String videoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(videoPath: videoPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Captured Videos")),
      body: widget.videoPaths.isEmpty
          ? const Center(child: Text("No videos recorded yet."))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns in grid
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: widget.videoPaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _openFullScreenVideo(widget.videoPaths[index]),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// 🎥 Full-Screen Video Player (Fixed Stretching Issue)
class FullScreenVideoPlayer extends StatefulWidget {
  final String videoPath;

  const FullScreenVideoPlayer({required this.videoPath, super.key});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? FittedBox(  // 🎯 Prevents Stretching (Maintains Aspect Ratio)
              fit: BoxFit.contain,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
                : const Center(child: CircularProgressIndicator()),
          ),

          // 🎮 Play/Pause Button (Bottom Center)
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 60,
                ),
                onPressed: _togglePlayPause,
              ),
            ),
          ),

          // ❌ Close Button (Top Left)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 35),
              onPressed: () {
                _controller.pause();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
