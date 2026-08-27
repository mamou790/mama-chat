import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

// ضع مفتاح Agora الخاص بك هنا بين العلامتين ""
const String appId = "YOUR_AGORA_APP_ID"; 
const String channelName = "mama_chat_channel";

void main() {
  runApp(const MamaChatApp());
}

class MamaChatApp extends StatelessWidget {
  const MamaChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mama Chat',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String currentUser = 'مامو';
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  final String _firebaseUrl =
      'https://mama-chat-default-rtdb.firebaseio.com/messages.json';

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(_firebaseUrl));
      if (response.statusCode == 200 && response.body != 'null') {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> loadedMessages = [];
        data.forEach((key, value) {
          loadedMessages.add({
            'id': key,
            'sender': value['sender'] ?? '',
            'text': value['text'] ?? '',
          });
        });
        setState(() {
          _messages = loadedMessages.reversed.toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage({String? customText}) async {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    try {
      await http.post(
        Uri.parse(_firebaseUrl),
        body: json.encode({
          'sender': currentUser,
          'text': text,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }),
      );
      _fetchMessages();
    } catch (e) {
      // التعامل مع الأخطاء
    }
  }

  // اختيار وصور وفيديوهات
  Future<void> _pickMedia(bool isVideo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery);

    if (media != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم اختيار ${isVideo ? "الفيديو" : "الصورة"}: ${media.name}')),
      );
      _sendMessage(customText: '[تم إرسال ${isVideo ? "فيديو" : "صورة"}: ${media.name}]');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: const Text('شات العائلة'), // عنوان التطبيق من الأعلى
  actions: [
    // هذا هو زر الكاميرا الجديد
    IconButton(
      icon: const Icon(Icons.videocam), // شكل الأيقونة (كاميرا فيديو)
      onPressed: () {
        // ماذا سيحدث عند الضغط عليه؟ سينتقل لشاشة المكالمة فوراً
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoCallScreen(),
          ),
        );
      },
    ),
  ],
),
       
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          // زر المكالمة الصوتية
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CallScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _fetchMessages,
          ),
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => currentUser = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'مامو', child: Text('الدخول كـ مامو')),
              const PopupMenuItem(value: 'ماما', child: Text('الدخول كـ ماما')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['sender'] == currentUser;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.teal.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${msg['sender']}: ${msg['text']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // شريط الإرسال السفلي المعدل
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendMessage(),
                ),
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.teal),
                  onPressed: () => _pickMedia(false),
                ),
                IconButton(
                  icon: const Icon(Icons.videocam, color: Colors.teal),
                  onPressed: () => _pickMedia(true),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك هنا...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.enableAudio();
    await _engine.joinChannel(
      token: '',
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مكالمة صوتية'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            Text(
              _remoteUid != null ? 'المكالمة متصلة الآن' : 'جاري الاتصال...',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.call_end, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}