import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskit/main.dart';
import 'package:taskit/platform/channels.dart';

// Generated mock file
import 'main_test.mocks.dart';

@GenerateMocks([Channels])
void main() {
  group('SplashScreen Tests', () {
    late MockChannels mockChannels;

    setUp(() {
      mockChannels = MockChannels();
    });

    testWidgets('Handles Create Task flow', (WidgetTester tester) async {
      when(mockChannels.getSharedText()).thenAnswer((_) async => 'Test Task');
      when(mockChannels.addCalendarEvent(
        title: anyNamed('title'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) async {});

      await tester.pumpWidget(MaterialApp(
        home: SplashScreen(channels: mockChannels),
      ));

      expect(find.text('TaskIt'), findsOneWidget);
      await tester.pumpAndSettle();

      verify(mockChannels.getSharedText()).called(1);
      verify(mockChannels.addCalendarEvent(
        title: 'Test Task',
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).called(1);
    });

    testWidgets('Handles Share flow', (WidgetTester tester) async {
      when(mockChannels.getSharedText()).thenAnswer((_) async => 'Shared Task');
      when(mockChannels.addCalendarEvent(
        title: anyNamed('title'),
        startTime: anyNamed('startTime'),
        endTime: anyNamed('endTime'),
      )).thenAnswer((_) async {});

      await tester.pumpWidget(MaterialApp(
        home: SplashScreen(channels: mockChannels),
      ));

      expect(find.text('TaskIt'), findsOneWidget);
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

      expect(find.text('TaskIt'), findsOneWidget);
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
