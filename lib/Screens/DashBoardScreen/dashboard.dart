import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:untitled/Screens/CareTakerScreen/care_taker_screen.dart';
import 'package:untitled/Screens/ImagePreviewScreen/image_picker_screen.dart';
import 'package:untitled/Screens/Profile/profile_screen.dart';
import 'package:untitled/Screens/Videos%20Screen/video_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  int imageCount = 20;
  int videoCount = 45;
  String userName = "Talha";
  double soundLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _speech = stt.SpeechToText();
  }
  void _toggleListening() async {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
        _controller.stop();
      });
    } else {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == "notListening") {
            setState(() {
              _isListening = false;
              _controller.stop();
            });
          }
        },
      );
      if (available) {
        setState(() {
          _isListening = true;
          _controller.repeat(reverse: true);
        });
        _speech.listen(
          onResult: (result) {},
          listenMode: stt.ListenMode.dictation,
          onSoundLevelChange: (level) {
            setState(() {
              soundLevel = level.clamp(0.0, 1.0); // Normalize the sound level
            });
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xff253244),
      drawer: Drawer(
        child: Container(
          color: const Color(0xff378acf),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xff253244)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _showAvatarDialog(context),
                      child: const Icon(Icons.account_circle, size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.person, "Profile",(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                );

              }),
              _buildDrawerItem(Icons.info, "About",(){

              }),
              _buildDrawerItem(Icons.logout, "Logout",(){

              }),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff253244),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, $userName", style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child:  _buildStatBox("Images", Icons.image, Colors.blue, imageCount),

                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CapturedImagesScreen(imagePaths: [])),
                    );
                  },
                ),
                GestureDetector(
                  child: _buildStatBox("Videos", Icons.videocam, Colors.red, videoCount),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    List<String> videoPaths = prefs.getStringList('saved_videos') ?? []; // ✅ Load saved videos
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CapturedVideosScreen(videoPaths: videoPaths),
                      ),
                    );
                  },

                ),


              ],
            ),
            const SizedBox(height: 20),
            const Text("App Usage: 75%", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            const LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _toggleListening,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(200, 200),
                      painter: SiriWavePainter(_isListening ? soundLevel : 0, _controller.value),
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildStatBox(String title, IconData icon, Color color, int count) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text("$title: $count", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class SiriWavePainter extends CustomPainter {
  final double soundLevel;
  final double animationValue;
  SiriWavePainter(this.soundLevel, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint baseCirclePaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xffd7e8fc), Color(0xff378acf), Color(0xff253244)],
        radius: 0.9,
      ).createShader(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));

    double dynamicRadius = size.width / 4 + (soundLevel * 50);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), dynamicRadius, baseCirclePaint);

    Paint fluidPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xffd7e8fc), Color(0xff378acf), Color(0xff253244)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (double angle = 0; angle < 2 * pi; angle += pi / 6) {
      Path wavePath = Path();
      for (double radius = 0; radius <= dynamicRadius; radius += 5) {
        double x = size.width / 2 + cos(angle) * radius;
        double y = size.height / 2 + sin(angle) * radius + sin((radius / dynamicRadius * 2 * pi) + animationValue * 2 * pi) * (5 + soundLevel * 10);
        if (radius == 0) {
          wavePath.moveTo(x, y);
        } else {
          wavePath.lineTo(x, y);
        }
      }
      canvas.drawPath(wavePath, fluidPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
void _showAvatarDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(// Re
                  radius: 50,
                  backgroundColor: Colors.grey,// place with your avatar image path
                  child: Icon(Icons.person,size: 50,),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "User Name", // Replace with dynamic username if needed
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close",style: TextStyle(color: Colors.grey),),
              )
            ],
          ),
        ),
      );
    },
  );
}
