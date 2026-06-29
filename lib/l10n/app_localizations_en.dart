// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaskIt';

  @override
  String get homeTitle => 'Create tasks from any app!';

  @override
  String get createFromClipboard => 'Create from Clipboard';

  @override
  String get addQuickSettingsTile => 'Add Quick Settings Tile';

  @override
  String get clipboardEmpty => 'Clipboard is empty or contains no text.';

  @override
  String get watchTutorial => 'Watch Tutorial';

  @override
  String get taskCreated => 'Task created successfully!';

  @override
  String get creatingTask => 'Creating task...';

  @override
  String get addNow => 'Add now';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String stepInfo(int index, int total) {
    return 'Step $index of $total';
  }

  @override
  String get getStarted => 'Get Started';

  @override
  String get welcomeDescription =>
      'This short tour guides you through different ways of using TaskIt.';

  @override
  String get method1Title => 'Method 1: Quick Settings';

  @override
  String get method1Description =>
      'Create tasks quickly from any app by copying text to your clipboard and tapping the TaskIt Quick Settings Tile.';

  @override
  String get enableTileTitle => 'Enable Tile';

  @override
  String get enableTileDescription =>
      'Add the TaskIt Quick Settings Tile to your device\'s notification panel for fast access.';

  @override
  String get tileTitle => 'Quick Settings Tile';

  @override
  String get tileDescription => 'TaskIt is now in your Quick Settings.';

  @override
  String get tileTip =>
      'Tip: Put it on the first screen of quick settings for ease of access.';

  @override
  String get copyTextTitle => 'Method 1: Copy Text';

  @override
  String get copyTextDescription =>
      'Select any text you want to convert into a task/event, and tap \"Copy\".';

  @override
  String get tapTileTitle => 'Tap TaskIt Tile';

  @override
  String get tapTileDescription =>
      'Swipe down and tap the TaskIt quick settings tile.';

  @override
  String get eventCreatedTitle => 'Event Created';

  @override
  String get eventCreatedDescription =>
      'TaskIt reads the clipboard, automatically parses the task title and time, and opens your calendar with the details pre-filled. Just tap \"Save\"!';

  @override
  String get backToWorkTitle => 'Back to Work';

  @override
  String get backToWorkDescription =>
      'Once saved, you are instantly returned to what you were doing, keeping your flow uninterrupted.';

  @override
  String get method2Title => 'Method 2: Share Sheet';

  @override
  String get method2Description =>
      'Send text directly to TaskIt using the system Share Sheet, perfect for apps where copying to clipboard is restricted or slow.';

  @override
  String get shareTextTitle => 'Method 2: Share Text';

  @override
  String get shareTextDescription =>
      'First, select and copy the text as before.';

  @override
  String get shareViaTitle => 'Share via TaskIt';

  @override
  String get shareViaDescription =>
      'Tap \"Share\" and select \"TaskIt\" from the list of apps. TaskIt will parse it and open the calendar event.';

  @override
  String get method3Title => 'Method 3: Context Menu';

  @override
  String get method3Description =>
      'Create a task in a single action directly from the text selection context menu without leaving your active app.';

  @override
  String get contextMenuTitle => 'Method 3: Context Menu';

  @override
  String get contextMenuDescription =>
      'Simply highlight the text and select \"Create Task\" from the context menu popover.';

  @override
  String get method4Title => 'Method 4: App Launch';

  @override
  String get method4Description =>
      'Open the TaskIt app directly to create tasks manually from your copied clipboard contents.';

  @override
  String get appLaunchTitle => 'Method 4: App Launch';

  @override
  String get appLaunchDescription =>
      'First, select and copy the text as before.';

  @override
  String get createFromAppTitle => 'Create from App';

  @override
  String get createFromAppDescription =>
      'Open the TaskIt app directly and tap \"Create from Clipboard\" to parse and save the event.';

  @override
  String get tileRequestSent =>
      'Request sent. Tap \'Add\' on the system dialog.';
}
