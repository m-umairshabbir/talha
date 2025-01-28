import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../CameraPreviewScreen/camera_preview_screen.dart';
import '../CareTakerScreen/care_taker_screen.dart';
import '../DashBoardScreen/dashboard.dart';
import '../ImagePreviewScreen/image_picker_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  CameraController? _cameraController; // Made nullable to handle late initialization
  bool _isCameraInitialized = false; // Track initialization state
  List<String> imagePaths = [];
  Offset _dragPosition = const Offset(300, 100);

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Fetch available cameras
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Initialize the camera controller
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      } else {
        print('No cameras found');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Safely dispose of the camera controller
    super.dispose();
  }

  Future<void> _captureAndSaveImage() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          imagePaths.add(image.path);
        });
      } catch (e) {
        print('Error capturing picture: $e');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      DashboardScreen(), // Set Dashboard as the first screen
      CameraPreviewScreen(
        cameraController: _cameraController,
        onCapture: _captureAndSaveImage,
        isCameraInitialized: _isCameraInitialized,
      ),
      CapturedImagesScreen(imagePaths: imagePaths),
      CaretakerProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff253244),
                Color(0xff378acf),
                Color(0xffd7e8fc),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/1.png', // Logo path
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Smart Assistance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          screens[_selectedIndex],
          Positioned(
            top: _dragPosition.dy,
            left: _dragPosition.dx,
            child: Draggable(
              feedback: Image.asset(
                'images/ICON.png', // Draggable icon path
                height: 70,
                width: 70,
              ),
              child: Image.asset(
                'images/ICON.png',
                height: 70,
                width: 70,
              ),
              onDragEnd: (details) {
                final screenSize = MediaQuery.of(context).size;
                setState(() {
                  _dragPosition = Offset(
                    details.offset.dx.clamp(0, screenSize.width - 50),
                    details.offset.dy.clamp(0, screenSize.height - 50),
                  );
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,color: Colors.blue,),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt,color: Colors.blue,),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image,color: Colors.blue,),
            label: 'Captured Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,color: Colors.blue,),
            label: 'CareTaker',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff378acf),
        unselectedItemColor: Colors.white, // Ensure unselected items are visible
        backgroundColor: const Color(0xff253244), // Add background color for visibility
        onTap: _onItemTapped,
      ),
    );
  }
}