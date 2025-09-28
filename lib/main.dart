import 'package:flutter/material.dart';
import 'platform/channels.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to TaskIt')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset('assets/icons/app_icon.png', height: 100),
            const SizedBox(height: 16),
            const Text('TaskIt is ready to help',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              'Create tasks from any app using Share or Select Text.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()));
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  final List<Map<String, String>> steps = [
    {'image': 'assets/onboarding/seq_1.png', 'caption': 'Select or copy task text'},
    {'image': 'assets/onboarding/seq_2_a.png', 'caption': 'Option 1: Use "Create Task" from context menu'},
    {'image': 'assets/onboarding/seq_2_b.png', 'caption': 'Option 2: Share text via TaskIt'},
    {'image': 'assets/onboarding/seq_3.png', 'caption': 'Task details are pre-filled'},
    {'image': 'assets/onboarding/seq_4.png', 'caption': 'Task is created in the calendar'},
    {'image': 'assets/onboarding/seq_5.png', 'caption': 'Save and return to your app'},
  ];

  void _exitOnboarding() {
    Navigator.pop(context); // or pushReplacement to splash
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How TaskIt Works'),
        actions: [
          TextButton(
            onPressed: _exitOnboarding,
            child: const Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final imageHeight = constraints.maxHeight * 0.8;
                        final captionHeight = constraints.maxHeight * 0.2;

                        return Column(
                          children: [
                            SizedBox(
                              height: imageHeight,
                              child: Image.asset(step['image']!, fit: BoxFit.contain),
                            ),
                            SizedBox(
                              height: captionHeight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      step['caption']!,
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if (index == steps.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: ElevatedButton(
                                        onPressed: _exitOnboarding,
                                        child: const Text('Done'),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SmoothPageIndicator(
                controller: _controller,
                count: steps.length,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}