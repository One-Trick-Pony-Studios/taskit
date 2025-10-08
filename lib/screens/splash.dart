import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

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
  void dispose() {
    debugPrint('SplashScreen disposed');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('SplashScreen initState');
    _handleSharedText();
    precacheImage(
        const AssetImage('assets/homepage/calendar_optimized.gif'), context);
  }

  Future<void> _handleSharedText() async {
    debugPrint('Handling shared text');
    try {
      final text = await widget.channels
          .getSharedText()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        debugPrint('getSharedText timed out');
        return null;
      });
      debugPrint('Shared text received: $text');
      if (text != null && text.isNotEmpty) {
        debugPrint('Processing text: $text');
        await _createTaskFromText(text);
      } else {
        debugPrint('Navigating to InfoScreen, mounted: true');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const InfoScreen()),
            );
          } else {
            debugPrint('Navigating to InfoScreen, mounted: false');
          }
        });
      }
    } catch (e) {
      debugPrint('Error in _handleSharedText: $e');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const InfoScreen()),
          );
        }
      });
    }
  }

  Future<void> _createTaskFromText(String text) async {
    try {
      await widget.channels.addCalendarEvent(
        title: text,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
      );
      debugPrint('Calendar event created successfully');
    } catch (e) {
      debugPrint('Failed to create calendar event: $e');
    }

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InfoScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDFF8E),
              Color(0xFFA8D16A),
              Color(0xFF01A414),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Column(
                children: [
                  // SvgPicture.asset(
                  //   'assets/icons/app_icon.svg',
                  //   width: 100,
                  //   height: 100,
                  //   semanticsLabel: 'TaskIt logo',
                  // ),
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
  }
}
