import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common.dart';
import 'onboarding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../platform/channels.dart';

class InfoScreen extends StatefulWidget {
  final Channels channels;
  final bool isDirectLaunch;

  InfoScreen({super.key, Channels? channels, this.isDirectLaunch = false})
      : channels = channels ?? MethodChannelChannels();

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late Future<int> _sdkVersionFuture;
  String _aiStatus = 'unavailable';
  bool _isAiEnabled = false;
  bool _isAiDownloading = false;

  @override
  void initState() {
    super.initState();
    _sdkVersionFuture = _getAndroidSdkInt();
    _checkFirstRun();
    _loadAiStatus();
  }

  Future<void> _loadAiStatus() async {
    try {
      final statusMap = await widget.channels.getAiStatus();
      if (mounted) {
        setState(() {
          _aiStatus = statusMap['status'] as String? ?? 'unavailable';
          _isAiEnabled = statusMap['enabled'] as bool? ?? false;
          _isAiDownloading = _aiStatus == 'downloading';
        });
      }
    } catch (_) {}
  }

  Future<void> _checkFirstRun() async {
    if (!widget.isDirectLaunch) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    if (!hasSeenOnboarding) {
      await prefs.setBool('hasSeenOnboarding', true);
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OnboardingScreen(channels: widget.channels)),
          );
        });
      }
    }
  }

  Future<int> _getAndroidSdkInt() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  Widget _buildAiToggleCard() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Material(
        key: ValueKey<String>('ai_card_${_aiStatus}_$_isAiDownloading'),
        color: Colors.white,
        elevation: 3,
        shadowColor: const Color(0x33000000),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
          constraints: const BoxConstraints(maxWidth: 320),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF01A414), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.geminiNanoTitle,
                      style: const TextStyle(
                        color: Color(0xFF01A414),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _isAiDownloading
                          ? AppLocalizations.of(context)!.geminiNanoDownloading
                          : AppLocalizations.of(context)!.geminiNanoSubtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  // ignore: deprecated_member_use
                  activeColor: const Color(0xFF01A414),
                  value: _isAiEnabled,
                  onChanged: (value) async {
                    setState(() {
                      _isAiEnabled = value;
                    });
                    await widget.channels.setAiEnabled(value);
                    if (value && _aiStatus == 'downloadable') {
                      setState(() {
                        _isAiDownloading = true;
                      });
                      await widget.channels.downloadAiModel();
                      final status = await widget.channels.getAiStatus();
                      if (mounted) {
                        setState(() {
                          _aiStatus = status['status'] as String? ?? 'available';
                          _isAiDownloading = _aiStatus == 'downloading';
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _sdkVersionFuture,
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
                                child: Text(
                                  AppLocalizations.of(context)!.homeTitle,
                                  style: const TextStyle(
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

                            ElevatedButton.icon(
                              icon: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF01A414), size: 22),
                              label: Text(
                                AppLocalizations.of(context)!.createFromClipboard,
                                style: const TextStyle(
                                  color: Color(0xFF01A414),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF01A414),
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              onPressed: () async {
                                final data = await Clipboard.getData(Clipboard.kTextPlain);
                                final text = data?.text;
                                if (text == null || text.trim().isEmpty) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.clipboardEmpty),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                  return;
                                }
                                await widget.channels.addCalendarEventFromText(text.trim());
                              },
                            ),

                            const SizedBox(height: 12),

                            // Conditional action based on Android version
                            if (sdkInt >= 33) ...[
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add_circle_outline, color: Color(0xFF01A414)),
                                  label: Text(
                                    AppLocalizations.of(context)!.addQuickSettingsTile,
                                    style: const TextStyle(color: Color(0xFF01A414), fontWeight: FontWeight.bold),
                                  ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF01A414),
                                  elevation: 3,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                onPressed: () async {
                                  final success = await widget.channels.requestAddQuickSettingsTile();
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(AppLocalizations.of(context)!.tileRequestSent)),
                                    );
                                  }
                                },
                              ),
                            ] else if (sdkInt < minSdk) ...[
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
                                  child: Text(
                                    AppLocalizations.of(context)!.watchTutorial,
                                    style: const TextStyle(
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
                            ],

                            // Progressive disclosure on-device AI card (hidden if unsupported)
                            if (_aiStatus != 'unavailable') ...[
                              const SizedBox(height: 12),
                              _buildAiToggleCard(),
                            ],

                            const Spacer(flex: 2),
                          ],
                        ),
                      ),

                      // Help button (?) tucked under the bottom right corner
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF01A414),
                            elevation: 4,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OnboardingScreen(channels: widget.channels),
                              ),
                            );
                          },
                          child: const Text(
                            '?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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