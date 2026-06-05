import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'common.dart';
import '../platform/channels.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;
  int _sdkInt = 0;

  final List<Map<String, String>> steps = [
    {
      'image': 'assets/onboarding/shareit.png',
      'caption':
          'Option 1\nSelect and copy text that you want to add to your Calendar app via TaskIt'
    },
    {
      'video': 'assets/onboarding/onboarding_blur_2.mp4',
      'caption': 'Share\nShare copied text as a text via TaskIt'
    },
    {
      'image': 'assets/onboarding/taskit.png',
      'caption':
          'Option 2\nHighlight text and select "Create Task" from context menu'
    },
    {
      'video': 'assets/onboarding/onboarding_blur_1.mp4',
      'caption': 'Create\nCreate task from highlighted text'
    },
    {
      'final': 'true',
      'caption':
          'You’re all set!\nReturn to your app and start creating tasks.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchSdkInt();
  }

  Future<void> _fetchSdkInt() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _sdkInt = androidInfo.version.sdkInt;
      });
    } catch (_) {}
  }

  void _exitOnboarding() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                  const TaskItHeader(showTitle: false),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: steps.length,
                      onPageChanged: (index) =>
                          setState(() => currentPage = index),
                      itemBuilder: (context, index) {
                        final step = steps[index];

                        if (step.containsKey('final')) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 36),
                                Image.asset(
                                  'assets/homepage/calendar_optimized.gif',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                                const SizedBox(height: 36),
                                const Text(
                                  'That’s it!',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 24,
                                    height: 28 / 24,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                if (_sdkInt >= 33) ...[
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                    label: const Text(
                                      "Add Quick Settings Tile",
                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 3,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final Channels channels = MethodChannelChannels();
                                      final success = await channels.requestAddQuickSettingsTile();
                                      if (success && mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Request sent. Tap 'Add' on the system dialog.")),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                ],
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(12),
                                    backgroundColor: Colors.white,
                                    elevation: 4,
                                  ),
                                  onPressed: _exitOnboarding,
                                  child: const Icon(Icons.home,
                                      color: Colors.green, size: 28),
                                ),
                                const Spacer(flex: 1),
                              ],
                            ),
                          );
                        }

                        final isVideo = step.containsKey('video');
                        final isImage = step.containsKey('image');
                        final captionParts = step['caption']?.split('\n') ?? [];
                        final title =
                            captionParts.isNotEmpty ? captionParts.first : '';
                        final body = captionParts.length > 1
                            ? captionParts.sublist(1).join('\n')
                            : '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isImage)
                                Column(
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      body,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              if (!isVideo)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.53,
                                  child: Image.asset(step['image']!,
                                      fit: BoxFit.contain),
                                ),
                              if (isVideo)
                                Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.53,
                                      child: _VideoSlide(
                                        videoPath: step['video']!,
                                        framePath:
                                            'assets/onboarding/pixel8_front.png',
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      body,
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.green),
                            onPressed: () {
                              if (currentPage == 0) {
                                _exitOnboarding();
                              } else {
                                _controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                        SmoothPageIndicator(
                          controller: _controller,
                          count: steps.length,
                          effect: const ExpandingDotsEffect(
                            expansionFactor: 4,
                            dotHeight: 10,
                            dotWidth: 10,
                            activeDotColor: Colors.blue,
                            dotColor: Colors.grey,
                            spacing: 6,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(
                              currentPage == steps.length - 1
                                  ? Icons.home
                                  : Icons.arrow_forward,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              if (currentPage == steps.length - 1) {
                                _exitOnboarding();
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Skip button overlay
          Positioned(
            top: 64,
            right: 24,
            child: SafeArea(
              child: TextButton(
                onPressed: _exitOnboarding,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoSlide extends StatefulWidget {
  final String videoPath;
  final String framePath;

  const _VideoSlide({required this.videoPath, required this.framePath});

  @override
  State<_VideoSlide> createState() => _VideoSlideState();
}

class _VideoSlideState extends State<_VideoSlide> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                Transform.scale(
                  scale: 1.05, // slightly enlarge the frame
                  child: Image.asset(widget.framePath, fit: BoxFit.contain),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
