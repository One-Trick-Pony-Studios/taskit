import 'package:flutter/material.dart';
import 'common.dart';
import 'onboarding.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section with white background
          Container(
            width: double.infinity,
            color: Colors.white,
            child: const TaskItHeader(),
          ),

          // Bottom section with gradient overlays and content
          Expanded(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  // Base white layer
                  Positioned.fill(
                    child: Container(color: Colors.white),
                  ),

                  // Gradient layers (unchanged)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(24)),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x33FDFF8E),
                              Color(0x33A8D16A),
                              Color(0x3301A414),
                            ],
                            stops: [0.0, 0.5, 0.9],
                          ),
                        ),
                      ),
                    ),
                  ),
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

                  // Foreground content (now inside Positioned.fill)
                  Positioned.fill(
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // GIF centered above the text
                        Image.asset(
                          'assets/homepage/calendar_gif.gif',
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
                                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                                );
                              },
                              child: const Icon(Icons.arrow_forward, color: Colors.green, size: 36),
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
  }
}
