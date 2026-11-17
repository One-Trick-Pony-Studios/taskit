import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TaskIt'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create tasks from any app!'**
  String get homeTitle;

  /// No description provided for @createFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Create from Clipboard'**
  String get createFromClipboard;

  /// No description provided for @addQuickSettingsTile.
  ///
  /// In en, this message translates to:
  /// **'Add Quick Settings Tile'**
  String get addQuickSettingsTile;

  /// No description provided for @clipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty or contains no text.'**
  String get clipboardEmpty;

  /// No description provided for @watchTutorial.
  ///
  /// In en, this message translates to:
  /// **'Watch Tutorial'**
  String get watchTutorial;

  /// No description provided for @taskCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully!'**
  String get taskCreated;

  /// No description provided for @creatingTask.
  ///
  /// In en, this message translates to:
  /// **'Creating task...'**
  String get creatingTask;

  /// No description provided for @addNow.
  ///
  /// In en, this message translates to:
  /// **'Add now'**
  String get addNow;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @stepInfo.
  ///
  /// In en, this message translates to:
  /// **'Step {index} of {total}'**
  String stepInfo(int index, int total);

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'This short tour guides you through different ways of using TaskIt.'**
  String get welcomeDescription;

  /// No description provided for @method1Title.
  ///
  /// In en, this message translates to:
  /// **'Method 1: Quick Settings'**
  String get method1Title;

  /// No description provided for @method1Description.
  ///
  /// In en, this message translates to:
  /// **'Create tasks quickly from any app by copying text to your clipboard and tapping the TaskIt Quick Settings Tile.'**
  String get method1Description;

  /// No description provided for @enableTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Tile'**
  String get enableTileTitle;

  /// No description provided for @enableTileDescription.
  ///
  /// In en, this message translates to:
  /// **'Add the TaskIt Quick Settings Tile to your device\'s notification panel for fast access.'**
  String get enableTileDescription;

  /// No description provided for @tileTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Settings Tile'**
  String get tileTitle;

  /// No description provided for @tileDescription.
  ///
  /// In en, this message translates to:
  /// **'TaskIt is now in your Quick Settings.'**
  String get tileDescription;

  /// No description provided for @tileTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Put it on the first screen of quick settings for ease of access.'**
  String get tileTip;

  /// No description provided for @copyTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copyTextTitle;

  /// No description provided for @copyTextDescription.
  ///
  /// In en, this message translates to:
  /// **'Select any text you want to convert into a task/event, and tap \"Copy\".'**
  String get copyTextDescription;

  /// No description provided for @tapTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap TaskIt Tile'**
  String get tapTileTitle;

  /// No description provided for @tapTileDescription.
  ///
  /// In en, this message translates to:
  /// **'Swipe down and tap the TaskIt quick settings tile.'**
  String get tapTileDescription;

  /// No description provided for @eventCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Created'**
  String get eventCreatedTitle;

  /// No description provided for @eventCreatedDescription.
  ///
  /// In en, this message translates to:
  /// **'TaskIt reads the clipboard, automatically parses the task title and time, and opens your calendar with the details pre-filled. Just tap \"Save\"!'**
  String get eventCreatedDescription;

  /// No description provided for @backToWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Back to Work'**
  String get backToWorkTitle;

  /// No description provided for @backToWorkDescription.
  ///
  /// In en, this message translates to:
  /// **'Once saved, you are instantly returned to what you were doing, keeping your flow uninterrupted.'**
  String get backToWorkDescription;

  /// No description provided for @method2Title.
  ///
  /// In en, this message translates to:
  /// **'Method 2: Share Sheet'**
  String get method2Title;

  /// No description provided for @method2Description.
  ///
  /// In en, this message translates to:
  /// **'Send text directly to TaskIt using the system Share Sheet, perfect for apps where copying to clipboard is restricted or slow.'**
  String get method2Description;

  /// No description provided for @shareTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Text'**
  String get shareTextTitle;

  /// No description provided for @shareTextDescription.
  ///
  /// In en, this message translates to:
  /// **'First, select and copy the text as before.'**
  String get shareTextDescription;

  /// No description provided for @shareViaTitle.
  ///
  /// In en, this message translates to:
  /// **'Share via TaskIt'**
  String get shareViaTitle;

  /// No description provided for @shareViaDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Share\" and select \"TaskIt\" from the list of apps. TaskIt will parse it and open the calendar event.'**
  String get shareViaDescription;

  /// No description provided for @method3Title.
  ///
  /// In en, this message translates to:
  /// **'Method 3: Context Menu'**
  String get method3Title;

  /// No description provided for @method3Description.
  ///
  /// In en, this message translates to:
  /// **'Create a task in a single action directly from the text selection context menu without leaving your active app.'**
  String get method3Description;

  /// No description provided for @contextMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Context Menu'**
  String get contextMenuTitle;

  /// No description provided for @contextMenuDescription.
  ///
  /// In en, this message translates to:
  /// **'Simply highlight the text and select \"Create Task\" from the context menu popover.'**
  String get contextMenuDescription;

  /// No description provided for @method4Title.
  ///
  /// In en, this message translates to:
  /// **'Method 4: App Launch'**
  String get method4Title;

  /// No description provided for @method4Description.
  ///
  /// In en, this message translates to:
  /// **'Open the TaskIt app directly to create tasks manually from your copied clipboard contents.'**
  String get method4Description;

  /// No description provided for @appLaunchTitle.
  ///
  /// In en, this message translates to:
  /// **'App Launch'**
  String get appLaunchTitle;

  /// No description provided for @appLaunchDescription.
  ///
  /// In en, this message translates to:
  /// **'First, select and copy the text as before.'**
  String get appLaunchDescription;

  /// No description provided for @createFromAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Create from App'**
  String get createFromAppTitle;

  /// No description provided for @createFromAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Open the TaskIt app directly and tap \"Create from Clipboard\" to parse and save the event.'**
  String get createFromAppDescription;

  /// No description provided for @tileRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent. Tap \'Add\' on the system dialog.'**
  String get tileRequestSent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
