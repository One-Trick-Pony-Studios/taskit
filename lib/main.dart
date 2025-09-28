import 'package:flutter/material.dart';
import 'platform/channels.dart';

void main() {
  runApp(const TaskitApp());
}

class TaskitApp extends StatelessWidget {
  const TaskitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskIt',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(channels: MethodChannelChannels()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Channels channels;
  const SplashScreen({super.key, required this.channels});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleSharedText();
  }

  Future<void> _handleSharedText() async {
    final text = await widget.channels.getSharedText();
    if (text != null && text.isNotEmpty) {
      await _createTaskFromText(text);
    } else {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _createTaskFromText(String text) async {
    await widget.channels.addCalendarEvent(
      title: text,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
    );
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/app_icon.png', height: 100, width: 100),
            const SizedBox(height: 16),
            const Text('TaskIt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
