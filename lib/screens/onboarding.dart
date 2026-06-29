import 'package:flutter/material.dart';
import 'common.dart';
import '../platform/channels.dart';

class OnboardingStep {
  final String? imagePath;
  final String title;
  final String description;
  final Rect? highlightRect; // Proportional coordinates (0.0 to 1.0)
  final String? tip;
  final bool isTextOnly;

  const OnboardingStep({
    this.imagePath,
    required this.title,
    required this.description,
    this.highlightRect,
    this.tip,
    this.isTextOnly = false,
  });
}

class OnboardingScreen extends StatefulWidget {
  final Channels channels;
  const OnboardingScreen({super.key, required this.channels});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<OnboardingStep> steps = const [
    // Welcome / Get Started Slide
    OnboardingStep(
      isTextOnly: true,
      title: 'Get Started',
      description: 'This short tour guides you through different ways of using TaskIt.',
    ),
    
    // Method 1 Demarcation Slide (Text-only)
    OnboardingStep(
      isTextOnly: true,
      title: 'Method 1: Quick Settings',
      description: 'Create tasks quickly from any app by copying text to your clipboard and tapping the TaskIt Quick Settings Tile.',
    ),
    // Quick Settings setup slide (image-based)
    OnboardingStep(
      imagePath: 'assets/onboarding/main_page.png',
      title: 'Enable Tile',
      description: 'Add the TaskIt Quick Settings Tile to your device\'s notification panel for fast access.',
      highlightRect: Rect.fromLTRB(0.18, 0.83, 0.82, 0.90),
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/quick_settings.png',
      title: 'Quick Settings Tile',
      description: 'TaskIt is now in your Quick Settings.',
      highlightRect: Rect.fromLTRB(0.04, 0.36, 0.49, 0.44),
      tip: 'Tip: Put it on the first screen of quick settings for ease of access.',
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/copy_text.png',
      title: 'Copy Text',
      description: 'Select any text you want to convert into a task/event, and tap "Copy".',
      highlightRect: Rect.fromLTRB(0.04, 0.44, 0.96, 0.59),
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/quick_settings.png',
      title: 'Tap TaskIt Tile',
      description: 'Swipe down and tap the TaskIt quick settings tile.',
      highlightRect: Rect.fromLTRB(0.04, 0.36, 0.49, 0.44),
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/calendar.png',
      title: 'Event Created',
      description: 'TaskIt prefills the details in your calendar app. Verify, adjust and tap "Save"!',
      highlightRect: Rect.fromLTRB(0.04, 0.10, 0.96, 0.35),
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/content_page.png',
      title: 'Back to Work',
      description: 'Once saved, instantly return to what you were doing, keeping your flow uninterrupted.',
      highlightRect: Rect.fromLTRB(0.04, 0.25, 0.96, 0.72),
    ),

    // Method 2 Demarcation Slide (Text-only)
    OnboardingStep(
      isTextOnly: true,
      title: 'Method 2: Share Sheet',
      description: 'Send text directly to TaskIt using the system Share Sheet.',
      tip: 'Tip: Depends on availability of Quickshare feature in the phone.',
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/copy_text.png',
      title: 'Share Text',
      description: 'First, select and copy the text as before.',
      highlightRect: Rect.fromLTRB(0.04, 0.44, 0.96, 0.59),
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/share_via.png',
      title: 'Share via TaskIt',
      description: 'Tap "Share" and select "TaskIt" from the list of apps. TaskIt will fill out the calendar event for you.',
      highlightRect: Rect.fromLTRB(0.20, 0.85, 0.39, 0.98),
    ),

    // Method 3 Demarcation Slide (Text-only)
    OnboardingStep(
      isTextOnly: true,
      title: 'Method 3: Context Menu',
      description: 'Create a task in a single action directly from the text selection context menu (if available).',
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/context_menu.png',
      title: 'Context Menu',
      description: 'Simply highlight the text and select "Create Task" from the context menu popover.',
      highlightRect: Rect.fromLTRB(0.40, 0.33, 0.76, 0.38),
    ),

    // Method 4 Demarcation Slide (Text-only)
    OnboardingStep(
      isTextOnly: true,
      title: 'Method 4: App Launch',
      description: 'Open the TaskIt app directly to create tasks manually from your copied clipboard contents.',
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/copy_text.png',
      title: 'App Launch',
      description: 'First, select and copy the text as before.',
      highlightRect: Rect.fromLTRB(0.04, 0.44, 0.96, 0.59),
    ),
    OnboardingStep(
      imagePath: 'assets/onboarding/main_page.png',
      title: 'Create from App',
      description: 'Open the TaskIt app directly and tap "Create from Clipboard" to parse and save the event.',
      highlightRect: Rect.fromLTRB(0.14, 0.72, 0.86, 0.79),
    ),
  ];

  void _exitOnboarding() {
    Navigator.pop(context);
  }

  Widget _buildInstructionCard(OnboardingStep step, int index, int total) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01A414),
                  ),
                ),
                Text(
                  'Step ${index + 1} of $total',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            if (step.tip != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x1F01A414),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0x3301A414)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Color(0xFF01A414), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step.tip!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF01A414),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (step.title == 'Enable Tile') ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01A414),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () async {
                  final success = await widget.channels.requestAddQuickSettingsTile();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Request sent. Check your quick settings panel!'
                              : 'Failed to request adding tile.',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  'Add now',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (index > 0)
                  TextButton.icon(
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF01A414)),
                    label: const Text(
                      'Back',
                      style: TextStyle(color: Color(0xFF01A414)),
                    ),
                  )
                else
                  TextButton(
                    onPressed: _exitOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01A414),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onPressed: () {
                    if (index < total - 1) {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _exitOnboarding();
                    }
                  },
                  icon: Icon(
                    index == total - 1 ? Icons.done : Icons.arrow_forward,
                    size: 18,
                  ),
                  label: Text(
                    index == total - 1 ? 'Done' : 'Next',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = steps[currentPage];
    final total = steps.length;
    final showCardAtTop = step.highlightRect != null && step.highlightRect!.top >= 0.5;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9FFF9),
              Color(0xFFE8F5E9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main PageView with screenshots/slides
              PageView.builder(
                controller: _controller,
                itemCount: total,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final s = steps[index];

                  if (s.isTextOnly) {
                    return OnboardingTextSlide(
                      step: s,
                      index: index,
                      total: total,
                      onNext: () {
                        if (index < total - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _exitOnboarding();
                        }
                      },
                      onBack: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      onSkip: _exitOnboarding,
                    );
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 80, bottom: 80, left: 24, right: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: AspectRatio(
                            aspectRatio: 1008 / 2244,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  s.imagePath!,
                                  fit: BoxFit.cover,
                                ),
                                CustomPaint(
                                  painter: OnboardingMaskPainter(
                                    highlightRect: s.highlightRect,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Floating Instruction Card (only visible for screenshot slides)
              if (!step.isTextOnly)
                Positioned(
                  left: 16,
                  right: 16,
                  top: showCardAtTop ? 16 : null,
                  bottom: showCardAtTop ? null : 16,
                  child: _buildInstructionCard(step, currentPage, total),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingTextSlide extends StatelessWidget {
  final OnboardingStep step;
  final int index;
  final int total;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingTextSlide({
    super.key,
    required this.step,
    required this.index,
    required this.total,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  IconData _getMethodIcon() {
    if (step.title.contains('Method 1')) return Icons.bolt;
    if (step.title.contains('Method 2')) return Icons.share_outlined;
    if (step.title.contains('Method 3')) return Icons.ads_click_outlined;
    if (step.title.contains('Method 4')) return Icons.smartphone_outlined;
    return Icons.rocket_launch_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getMethodIcon();
    final isFirst = index == 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: double.infinity,
          height: 480,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color(0x1F01A414)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isFirst) ...[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF01A414).withOpacity(0.15),
                          blurRadius: 16,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/icons/app_icon.png'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'TaskIt',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF01A414),
                      letterSpacing: 1.2,
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x1F01A414),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0x4D01A414), width: 2),
                    ),
                    child: Icon(
                      iconData,
                      size: 40,
                      color: const Color(0xFF01A414),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01A414),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: isFirst ? Alignment.centerLeft : Alignment.center,
                      child: Text(
                        step.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                        textAlign: isFirst ? TextAlign.left : TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Row of buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (index > 0)
                      TextButton.icon(
                        onPressed: onBack,
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF01A414)),
                        label: const Text(
                          'Back',
                          style: TextStyle(color: Color(0xFF01A414)),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: onSkip,
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01A414),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onPressed: onNext,
                      icon: Icon(
                        index == total - 1 ? Icons.done : Icons.arrow_forward,
                        size: 18,
                      ),
                      label: Text(
                        index == total - 1 ? 'Done' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingMaskPainter extends CustomPainter {
  final Rect? highlightRect;
  final Color maskColor;

  OnboardingMaskPainter({
    this.highlightRect,
    this.maskColor = const Color(0x99000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = maskColor
      ..style = PaintingStyle.fill;

    if (highlightRect == null) {
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }

    final absoluteRect = Rect.fromLTRB(
      highlightRect!.left * size.width,
      highlightRect!.top * size.height,
      highlightRect!.right * size.width,
      highlightRect!.bottom * size.height,
    );

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRRect(RRect.fromRectAndRadius(absoluteRect, const Radius.circular(12))),
    );

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = const Color(0xFF01A414)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(absoluteRect, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant OnboardingMaskPainter oldDelegate) {
    return oldDelegate.highlightRect != highlightRect || oldDelegate.maskColor != maskColor;
  }
}
