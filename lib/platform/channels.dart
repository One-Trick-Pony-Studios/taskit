import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

abstract class Channels {
  Future<String?> getSharedText();
  Future<void> addCalendarEvent({
    required String title,
    DateTime? startTime,
    DateTime? endTime,
  });
}

class MethodChannelChannels implements Channels {
  static const MethodChannel _processTextChannel = MethodChannel('app.channel.process.data');
  static const MethodChannel _calendarChannel = MethodChannel('app.channel.calendar');

  @override
  Future<String?> getSharedText() async {
    try {
      final sharedData = await _processTextChannel.invokeMethod('getSharedText');
      if (sharedData is String) {
        if (kDebugMode) {
          print('Shared text retrieved: $sharedData');
        }
        return sharedData;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving shared text: $e');
      }
      return null;
    }
  }

  @override
  Future<void> addCalendarEvent({required String title, DateTime? startTime, DateTime? endTime}) async {
    await _calendarChannel.invokeMethod('addCalendarEvent', {
      'title': title,
      'startTime': startTime?.toUtc().millisecondsSinceEpoch ?? DateTime.now().toUtc().millisecondsSinceEpoch,
      'endTime': endTime?.toUtc().millisecondsSinceEpoch ?? DateTime.now().toUtc().add(const Duration(hours: 1)).millisecondsSinceEpoch,
    });
  }  
}