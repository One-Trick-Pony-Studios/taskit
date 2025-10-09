import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'common.dart';
import 'onboarding.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  Future<int> _getAndroidSdkInt() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getAndroidSdkInt(),
      builder: (context, sdkSnapshot) {
        if (sdkSnapshot.connectionState == ConnectionState.waiting) {
          //debugPrint('Waiting for SDK version');
          return const Center(child: CircularProgressIndicator());
        }
        if (sdkSnapshot.hasError) {
          //debugPrint('Error getting SDK version: ${sdkSnapshot.error}');
          return const Center(child: Text('Error loading screen'));
        }

        final sdkInt = sdkSnapshot.data!;
        final minSdk = 30;
        //debugPrint('Detected Android SDK: $sdkInt');

        return Scaffold(
          body: Column(
            children: [
              // Top section with white background
              Container(
                width: double.infinity,
                color: Colors.white,
                child: const TaskItHeader(),
              ),

              // Bottom section with conditional content
              Expanded(
                child: SizedBox.expand(
                  child: Stack(
                    children: [
                      // Base white layer (common to all versions)
                      Positioned.fill(
                        child: Container(color: Colors.white),
                      ),

                      // Single gradient layer matching SplashScreen (conditional opacity)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24)),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: sdkInt >= minSdk
                                    ? const <Color>[
                                        Color(0x80FDFF8E),
                                        Color(0x80A8D16A),
                                        Color(0x8001A414),
                                      ]
                                    : const <Color>[
                                        Color(0x80FDFF8E),
                                        Color(0x80A8D16A),
                                        Color(0x8001A414),
                                      ],
                                  stops: [0.0, 0.5, 0.9],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Additional gradient layers (only for Android 11+)
                      if (sdkInt >= minSdk)
                        Positioned.fill(
                          child: Transform.translate(
                            offset: const Offset(20, 20),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x4DFDFF8E),
                                      Color(0x4DA8D16A),
                                      Color(0x4D01A414),
                                    ],
                                    stops: [0.0, 0.5, 0.9],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (sdkInt >= minSdk)
                        Positioned.fill(
                          child: Transform.translate(
                            offset: const Offset(40, 40),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x66FDFF8E),
                                      Color(0x66A8D16A),
                                      Color(0x6601A414),
                                    ],
                                    stops: [0.0, 0.5, 0.9],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Foreground content with conditional layout
                      Positioned.fill(
                        child: Column(
                          children: [
                            const Spacer(flex: 2),

                            // Image/GIF based on Android version
                            if (sdkInt >= minSdk)
                              Image.asset(
                                'assets/homepage/calendar_optimized.gif',
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              )
                            else
                              Image.asset(
                                'assets/homepage/calendar.png', // Replace with your static image path
                                width: 150,
                                height: 150,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),

                            const SizedBox(height: 24),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Align(
                                alignment: Alignment.center,
                                widthFactor: 0.7,
                                child: const Text(
                                  'Create tasks from\nany app!',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24,
                                    height: 30 / 24,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            const Spacer(flex: 2),
                            // Conditional action based on Android version
                            if (sdkInt >= minSdk)
                              Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(12),
                                      backgroundColor: Colors.white,
                                      elevation: 4,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const OnboardingScreen()),
                                      );
                                    },
                                    child: const Icon(Icons.arrow_forward,
                                        color: Colors.green, size: 36),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 24,
                                      height: 28 / 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            else
                              InkWell(
                                onTap: () async {
                                  final Uri url = Uri.parse('https://youtube.com/shorts/Q_Ia-PNysoE');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF01A414), // Your logo's green
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(25, 0, 0, 0), // ~10% opacity black
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Watch Tutorial',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      height: 1.2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}