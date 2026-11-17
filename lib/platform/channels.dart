import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

abstract class Channels {
  Future<Map<String, dynamic>?> getSharedText();
  Future<void> addCalendarEvent({
    required String title,
    DateTime? startTime,
    DateTime? endTime,
  });
  Future<void> addCalendarEventFromText(String text);
  Future<bool> requestAddQuickSettingsTile();
  Future<bool> checkAndRequestPermission();
  Future<Map<String, dynamic>> getAiStatus();
  Future<bool> setAiEnabled(bool enabled);
  Future<bool> downloadAiModel();
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
  Future<void> addCalendarEventFromText(String text) async {
    await _calendarChannel.invokeMethod('addCalendarEventFromText', {
      'text': text,
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

  @override
  Future<bool> checkAndRequestPermission() async {
    try {
      final bool? success = await _calendarChannel.invokeMethod('checkAndRequestPermission');
      return success ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking/requesting calendar permission: $e');
      }
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getAiStatus() async {
    try {
      final result = await _calendarChannel.invokeMethod('getAiStatus');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'status': 'unavailable', 'enabled': false};
    } catch (e) {
      if (kDebugMode) {
        print('Error getting AI status: $e');
      }
      return {'status': 'unavailable', 'enabled': false};
    }
  }

  @override
  Future<bool> setAiEnabled(bool enabled) async {
    try {
      final bool? success = await _calendarChannel.invokeMethod('setAiEnabled', {'enabled': enabled});
      return success ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error setting AI enabled: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> downloadAiModel() async {
    try {
      final bool? success = await _calendarChannel.invokeMethod('downloadAiModel');
      return success ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading AI model: $e');
      }
      return false;
    }
  }
}