import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

abstract class Channels {
  Future<Map<String, dynamic>?> getSharedText();
  Future<void> addCalendarEvent({
    required String title,
    DateTime? startTime,
    DateTime? endTime,
  });
  Future<bool> requestAddQuickSettingsTile();
}

class MethodChannelChannels implements Channels {
  static const MethodChannel _processTextChannel = MethodChannel('app.channel.process.data');
  static const MethodChannel _calendarChannel = MethodChannel('app.channel.calendar');

  @override
  Future<Map<String, dynamic>?> getSharedText() async {
    try {
      final sharedData = await _processTextChannel.invokeMethod('getSharedText');
      if (sharedData is Map) {
        if (kDebugMode) {
          print('Shared text retrieved: $sharedData');
        }
        return Map<String, dynamic>.from(sharedData);
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

  @override
  Future<bool> requestAddQuickSettingsTile() async {
    try {
      final bool? success = await _calendarChannel.invokeMethod('requestAddTile');
      return success ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting Quick Settings Tile: $e');
      }
      return false;
    }
  }
}