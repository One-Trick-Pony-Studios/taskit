import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../platform/channels.dart';
import 'home.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/homepage/calendar_optimized.gif'), context);
  }

  Future<void> _handleSharedText() async {
    try {
      final data = await widget.channels
          .getSharedText()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return <String, dynamic>{};
      });
      if (data != null && data.isNotEmpty) {
        await _createTaskFromSharedData(data);
      } else {
        await widget.channels.checkAndRequestPermission();
        _navigateToInfoScreen();
      }
    } catch (e) {
      _navigateToInfoScreen();
    }
  }

  void _navigateToInfoScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InfoScreen()),
        );
      }
    });
  }

  Future<void> _createTaskFromSharedData(Map<String, dynamic> data) async {
    try {
      final String title = data['title'] ?? data['text'] ?? 'TaskIt Task';
      final int? startMs = data['startTime'];
      final int? endMs = data['endTime'];

      final DateTime startTime = startMs != null
          ? DateTime.fromMillisecondsSinceEpoch(startMs, isUtc: true)
          : DateTime.now();
      final DateTime endTime = endMs != null
          ? DateTime.fromMillisecondsSinceEpoch(endMs, isUtc: true)
          : DateTime.now().add(const Duration(hours: 1));

      await widget.channels.addCalendarEvent(
        title: title,
        startTime: startTime,
        endTime: endTime,
      );
    } catch (e) {
      // Ignored / handled natively
    }

    _navigateToInfoScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getAndroidSdkInt(),
      builder: (context, sdkSnapshot) {
        if (sdkSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (sdkSnapshot.hasError) {
          return const Center(child: Text('Error loading splash'));
        }

        final sdkInt = sdkSnapshot.data!;

        // Define gradient colors based on SDK version
        final gradientColors = sdkInt >= 30
            ? const <Color>[
                Color(0x80FDFF8E),
                Color(0x80A8D16A),
                Color(0x8001A414),
              ]
            : const <Color>[
                Color(0xFFFDFF8E),
                Color(0xFFA8D16A),
                Color(0xFF01A414),
              ];

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
                stops: [0.0, 0.5, 0.9],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/app_icon.png',
                        width: 100,
                        height: 100,
                        semanticLabel: 'TaskIt logo',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'TaskIt',
                        style: TextStyle(
                          fontFamily: 'RhodiumLibre',
                          fontSize: 40,
                          height: 18 / 40,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const CircularProgressIndicator(),
                    ],
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    } catch (e, stack) {
      print('DEVICE INFO ERROR: $e');
      print('STACK: $stack');
      rethrow;
    }
  }
}