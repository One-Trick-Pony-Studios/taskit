import 'package:flutter/material.dart';
import 'platform/channels.dart';
import 'screens/splash.dart';

void main() {
  runApp(const TaskitApp());
}

class TaskitApp extends StatelessWidget {
  const TaskitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskIt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(channels: MethodChannelChannels()),
    );
  }
}
