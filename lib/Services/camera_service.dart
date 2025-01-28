import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> captureImage() async {
    try {
      // Open the camera to capture an image
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      // Return the captured image (or null if canceled)
      return image;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }
}
