import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Future<void> _handleSharedText() async {
    final text = await widget.channels.getSharedText();
    if (text != null && text.isNotEmpty) {
      await _createTaskFromText(text);
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InfoScreen()),
        );
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x80FDFF8E),
              Color(0x80A8D16A),
              Color(0x8001A414),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/app_icon.svg',
                    width: 100,
                    height: 100,
                    semanticsLabel: 'TaskIt logo',
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