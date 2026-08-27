import 'package:flutter/material.dart';

void main() {
  runApp(const MamaChatApp());
}

class MamaChatApp extends StatelessWidget {
  const MamaChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mama Chat Video Call',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const VideoCallScreen(),
    );
  }
}

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // شاشة الشخص الآخر (تأخذ المساحة كاملة)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF2C2C2C),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'سارة أحمد',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'جاري الاتصال... 00:15',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // كاميرتك الشخصية (صغيرة في الزاوية العلوية اليمنى)
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.videocam, color: Colors.white54, size: 30),
              ),
            ),
          ),

          // أزرار التحكم في المكالمة في الأسفل (كتم، إنهاء، قلب الكاميرا)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر كتم الصوت
                FloatingActionButton(
                  heroTag: 'mic',
                  backgroundColor: Colors.grey[800],
                  onPressed: () {},
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
                const SizedBox(width: 20),

                // زر إنهاء المكالمة باللون الأحمر
                FloatingActionButton(
                  heroTag: 'endCall',
                  backgroundColor: Colors.red,
                  onPressed: () {},
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
                const SizedBox(width: 20),

                // زر قلب الكاميرا
                FloatingActionButton(
                  heroTag: 'camera',
                  backgroundColor: Colors.grey[800],
                  onPressed: () {},
                  child: const Icon(Icons.switch_camera, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
