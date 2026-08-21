import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import 'camera_stream_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  String? childUrl;
  String? sessionId;
  String? errorMessage;

  Future<void> createSession() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final Map<String, dynamic> result =
          await CameraService.createCameraSession();

      setState(() {
        childUrl = result["child_url"]?.toString();
        sessionId = result["session_id"]?.toString();
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void openCamera() {
    if (sessionId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraStreamScreen(
          sessionId: sessionId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Parent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: loading ? null : createSession,
              child: Text(
                loading ? 'جاري الإنشاء...' : 'إنشاء جلسة كاميرا',
              ),
            ),

            const SizedBox(height: 20),

            if (childUrl != null)
              SelectableText(
                'رابط الطفل:\n\n$childUrl',
              ),

            const SizedBox(height: 20),

            if (sessionId != null)
              ElevatedButton(
                onPressed: openCamera,
                child: const Text('فتح الكاميرا'),
              ),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
