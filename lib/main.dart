import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'platform/channels.dart';
import 'screens/splash.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  ));

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
