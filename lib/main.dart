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
      title: 'Mama Chat Pro',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

// 1. شاشة القائمة الرئيسية للتطبيق
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mama Chat - الرئيسية'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.chat_bubble_outline,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'أهلاً بك يا مامو في تطبيقك الخاص',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // زر الانتقال لمكالمة الفيديو
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoCallScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.videocam, color: Colors.white),
              label: const Text(
                'بدء مكالمة فيديو',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة مكالمة الفيديو الاحترافية
class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // شاشة الشخص الآخر في الخلفية
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

          // كاميرتك الشخصية في الزاوية
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

          // أزرار التحكم في الأسفل (مع زر الرجوع للشاشة السابقة)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'mic',
                  backgroundColor: Colors.grey[800],
                  onPressed: () {},
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
                const SizedBox(width: 20),

                // زر إنهاء المكالمة والرجوع للخلف
                FloatingActionButton(
                  heroTag: 'endCall',
                  backgroundColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.call_end, color: Colors.white),
                ),
                const SizedBox(width: 20),

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
