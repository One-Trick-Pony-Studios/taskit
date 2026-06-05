import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskit/platform/channels.dart';
import 'package:taskit/screens/splash.dart';

// Generated mock file
import 'main_test.mocks.dart';

@GenerateMocks([Channels])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Tests', () {
    late MockChannels mockChannels;

    setUp(() {
      mockChannels = MockChannels();

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

      await tester.pumpWidget(MaterialApp(
        home: SplashScreen(channels: mockChannels),
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

      await tester.pumpWidget(MaterialApp(
        home: SplashScreen(channels: mockChannels),
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
      when(mockChannels.getSharedText()).thenAnswer((_) async => null);

      await tester.pumpWidget(MaterialApp(
        home: SplashScreen(channels: mockChannels),
      ));

      await tester.pump(); // Let FutureBuilder complete and rebuild
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('TaskIt').first, findsOneWidget);
      await tester.pumpAndSettle();

      verify(mockChannels.getSharedText()).called(1);
      verifyNever(mockChannels.addCalendarEvent(
        title: anyNamed('title'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      ));
    });
  });
}
