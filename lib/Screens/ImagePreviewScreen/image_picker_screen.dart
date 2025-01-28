
import 'dart:io';

import 'package:flutter/material.dart';

class CapturedImagesScreen extends StatelessWidget {
  final List<String> imagePaths;

  const CapturedImagesScreen({required this.imagePaths, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Captured Images'),
      ),
      body: imagePaths.isEmpty
          ? const Center(
        child: Text('No images captured yet.'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(imagePaths[index]),
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
