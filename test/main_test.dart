import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskit/platform/channels.dart';
import 'package:taskit/screens/splash.dart';
import 'package:taskit/screens/home.dart';
import 'package:taskit/screens/onboarding.dart';
import 'package:taskit/l10n/app_localizations.dart';

// Generated mock file
import 'main_test.mocks.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('es'),
      Locale('hi'),
      Locale('de'),
      Locale('fr'),
    ],
    home: child,
  );
}

@GenerateMocks([Channels])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Tests', () {
    late MockChannels mockChannels;

    setUp(() {
      SharedPreferences.setMockInitialValues({'hasSeenOnboarding': true});
      mockChannels = MockChannels();
      when(mockChannels.checkAndRequestPermission()).thenAnswer((_) async => true);

      String clipboardText = '';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/platform', JSONMethodCodec()),
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            final Map? args = methodCall.arguments as Map?;
            clipboardText = args?['text'] ?? '';
            return null;
          }
          if (methodCall.method == 'Clipboard.getData') {
            return <String, dynamic>{'text': clipboardText};
          }
          return null;
        },
      );

      final mockAndroidInfo = {
        'version': {
          'sdkInt': 33,
          'codename': 'REL',
          'release': '13',
          'incremental': '123',
          'securityPatch': '2023-01-01',
          'baseOS': '',
          'previewSdkInt': 0,
        },
        'board': 'board',
        'bootloader': 'bootloader',
        'brand': 'brand',
        'device': 'device',
        'display': 'display',
        'fingerprint': 'fingerprint',
        'hardware': 'hardware',
        'host': 'host',
        'id': 'id',
        'manufacturer': 'manufacturer',
        'model': 'model',
        'product': 'product',
        'supported32BitAbis': <String>[],
        'supported64BitAbis': <String>[],
        'supportedAbis': <String>[],
        'tags': 'tags',
        'type': 'type',
        'isPhysicalDevice': true,
        'systemFeatures': <String>[],
        'freeDiskSize': 0,
        'totalDiskSize': 0,
        'isLowRamDevice': false,
        'physicalRamSize': 0,
        'availableRamSize': 0,
      };

      // Register mock method call handler for device_info_plus on both old and new channels
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/device_info'),
        (MethodCall methodCall) async {
          return mockAndroidInfo;
        },
      );

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('dev.fluttercommunity.plus/device_info'),
        (MethodCall methodCall) async {
          return mockAndroidInfo;
        },
      );
    });

    testWidgets('Handles Create Task flow', (WidgetTester tester) async {
      when(mockChannels.getSharedText()).thenAnswer((_) async => {
        'text': 'Test Task',
        'title': 'Test Task',
        'startTime': null,
        'endTime': null,
      });
      when(mockChannels.addCalendarEvent(
        title: anyNamed('title'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestWidget(
        SplashScreen(channels: mockChannels),
      ));

      await tester.pump(); // Let FutureBuilder complete and rebuild
      await tester.pump(const Duration(milliseconds: 100)); // Additional pump for any microtasks

      // Verify if the text is displayed
      expect(find.text('TaskIt').first, findsOneWidget);
      await tester.pumpAndSettle();

      verify(mockChannels.getSharedText()).called(1);
      verify(mockChannels.addCalendarEvent(
        title: 'Test Task',
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).called(1);
    });

    testWidgets('Handles Share flow', (WidgetTester tester) async {
      when(mockChannels.getSharedText()).thenAnswer((_) async => {
        'text': 'Shared Task',
        'title': 'Shared Task',
        'startTime': null,
        'endTime': null,
      });
      when(mockChannels.addCalendarEvent(
        title: anyNamed('title'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestWidget(
        SplashScreen(channels: mockChannels),
      ));

      await tester.pump(); // Let FutureBuilder complete and rebuild
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('TaskIt').first, findsOneWidget);
      await tester.pumpAndSettle();

      verify(mockChannels.getSharedText()).called(1);
      verify(mockChannels.addCalendarEvent(
        title: 'Shared Task',
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).called(1);
    });

    testWidgets('Handles no shared text', (WidgetTester tester) async {
      when(mockChannels.getSharedText()).thenAnswer((_) => Future<Map<String, dynamic>?>.value(null));

      await tester.pumpWidget(buildTestWidget(
        SplashScreen(channels: mockChannels),
      ));

      await tester.pump(); // Let FutureBuilder complete and rebuild
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('TaskIt').first, findsOneWidget);
      await tester.pumpAndSettle();

      verify(mockChannels.getSharedText()).called(1);
      verify(mockChannels.checkAndRequestPermission()).called(1);
      verifyNever(mockChannels.addCalendarEvent(
        title: anyNamed('title'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      ));
    });

    testWidgets('Renders Create from Clipboard button and handles tap', (WidgetTester tester) async {
      when(mockChannels.addCalendarEventFromText(any)).thenAnswer((_) async {});

      await Clipboard.setData(const ClipboardData(text: 'Meeting at 3pm tomorrow'));

      await tester.pumpWidget(buildTestWidget(
        InfoScreen(channels: mockChannels),
      ));
      await tester.pump();

      // Look for localized button label
      final buttonFinder = find.widgetWithText(ElevatedButton, 'Create from Clipboard');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      verify(mockChannels.addCalendarEventFromText('Meeting at 3pm tomorrow')).called(1);
    });

    testWidgets('Shows SnackBar when clipboard is empty', (WidgetTester tester) async {
      await Clipboard.setData(const ClipboardData(text: ''));

      await tester.pumpWidget(buildTestWidget(
        InfoScreen(channels: mockChannels),
      ));
      await tester.pump();

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Create from Clipboard');
      await tester.tap(buttonFinder);
      await tester.pump();

      expect(find.text('Clipboard is empty or contains no text.'), findsOneWidget);
      verifyNever(mockChannels.addCalendarEventFromText(any));
    });

    testWidgets('Auto-triggers onboarding on first use', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'hasSeenOnboarding': false});

      // Set a larger size for the tester to prevent overflow errors in OnboardingScreen
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(
        InfoScreen(channels: mockChannels, isDirectLaunch: true),
      ));

      // InfoScreen builds and schedules push of OnboardingScreen
      await tester.pump(); 
      // Handle the navigation transition
      await tester.pumpAndSettle();

      // Verify OnboardingScreen is shown (by finding the localized 'Skip' button text)
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('OnboardingScreen renders Add now button on Enable Tile step and triggers channel call', (WidgetTester tester) async {
      when(mockChannels.requestAddQuickSettingsTile()).thenAnswer((_) async => true);

      // Set a larger size for the tester to prevent overflow errors in OnboardingScreen
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(
        OnboardingScreen(channels: mockChannels),
      ));

      // The first page is "Get Started" overview slide (text-only)
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Add now'), findsNothing);

      // Tap Next to navigate through "Method 1: Quick Settings" to "Enable Tile" step
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // We are now on "Enable Tile" step, which should render the "Add now" button
      expect(find.text('Enable Tile'), findsOneWidget);
      final addNowButton = find.widgetWithText(ElevatedButton, 'Add now');
      expect(addNowButton, findsOneWidget);

      // Tap "Add now" button
      await tester.tap(addNowButton);
      await tester.pump();

      // Verify channel method was called
      verify(mockChannels.requestAddQuickSettingsTile()).called(1);
    });
  });
}
