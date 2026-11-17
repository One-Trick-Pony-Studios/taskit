// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TaskIt';

  @override
  String get homeTitle => 'Aufgaben aus jeder App erstellen!';

  @override
  String get createFromClipboard => 'Aus Zwischenablage erstellen';

  @override
  String get addQuickSettingsTile => 'Kachel in Quick Settings hinzufügen';

  @override
  String get clipboardEmpty =>
      'Zwischenablage ist leer oder enthält keinen Text.';

  @override
  String get watchTutorial => 'Video-Tutorial ansehen';

  @override
  String get taskCreated => 'Aufgabe erfolgreich erstellt!';

  @override
  String get creatingTask => 'Aufgabe wird erstellt...';

  @override
  String get addNow => 'Jetzt hinzufügen';

  @override
  String get back => 'Zurück';

  @override
  String get skip => 'Überspringen';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String stepInfo(int index, int total) {
    return 'Schritt $index von $total';
  }

  @override
  String get getStarted => 'Loslegen';

  @override
  String get welcomeDescription =>
      'Diese kurze Tour zeigt dir, wie du TaskIt auf verschiedene Weise nutzen kannst.';

  @override
  String get method1Title => 'Methode 1: Quick Settings';

  @override
  String get method1Description =>
      'Erstelle Aufgaben blitzschnell aus jeder App, indem du Text kopierst und auf die TaskIt-Kachel in deinen Quick Settings tippst.';

  @override
  String get enableTileTitle => 'Kachel aktivieren';

  @override
  String get enableTileDescription =>
      'Füge die TaskIt-Kachel für schnellen Zugriff zu deinem Benachrichtigungsfeld hinzu.';

  @override
  String get tileTitle => 'Quick Settings-Kachel';

  @override
  String get tileDescription => 'TaskIt ist jetzt in deinen Quick Settings.';

  @override
  String get tileTip =>
      'Tipp: Platziere die Kachel auf der ersten Seite der Quick Settings, um sie sofort griffbereit zu haben.';

  @override
  String get copyTextTitle => 'Text kopieren';

  @override
  String get copyTextDescription =>
      'Wähle einfach den gewünschten Text aus und tippe auf \"Kopieren\".';

  @override
  String get tapTileTitle => 'Auf TaskIt-Kachel tippen';

  @override
  String get tapTileDescription =>
      'Ziehe die Statusleiste nach unten und tippe auf die TaskIt-Kachel.';

  @override
  String get eventCreatedTitle => 'Termin erstellt';

  @override
  String get eventCreatedDescription =>
      'TaskIt liest den kopierten Text, erkennt Titel und Uhrzeit und öffnet deinen Kalender mit vorausgefüllten Daten. Tippe nur noch auf \"Speichern\"!';

  @override
  String get backToWorkTitle => 'Zurück zur App';

  @override
  String get backToWorkDescription =>
      'Sobald der Termin gespeichert ist, bist du sofort wieder in deiner vorherigen App.';

  @override
  String get method2Title => 'Methode 2: Teilen-Menü';

  @override
  String get method2Description =>
      'Sende Text direkt über das System-Teilen-Menü an TaskIt – perfekt für Apps, in denen du keinen Text kopieren kannst.';

  @override
  String get shareTextTitle => 'Text teilen';

  @override
  String get shareTextDescription =>
      'Wähl zuerst den Text aus und kopiere ihn.';

  @override
  String get shareViaTitle => 'Mit TaskIt teilen';

  @override
  String get shareViaDescription =>
      'Tippe auf \"Teilen\" und wähle \"TaskIt\" aus der Liste. TaskIt erstellt direkt den passenden Kalendertermin für dich.';

  @override
  String get method3Title => 'Methode 3: Kontextmenü';

  @override
  String get method3Description =>
      'Erstelle eine Aufgabe direkt über das Textauswahl-Kontextmenü, ohne deine aktuelle App zu verlassen.';

  @override
  String get contextMenuTitle => 'Kontextmenü';

  @override
  String get contextMenuDescription =>
      'Markiere einfach den Text und wähle im Popup-Menü \"Aufgabe erstellen\".';

  @override
  String get method4Title => 'Methode 4: App öffnen';

  @override
  String get method4Description =>
      'Öffne die TaskIt-App direkt, um Aufgaben manuell aus deiner Zwischenablage zu erstellen.';

  @override
  String get appLaunchTitle => 'App öffnen';

  @override
  String get appLaunchDescription =>
      'Wähle zuerst den Text aus und kopiere ihn.';

  @override
  String get createFromAppTitle => 'Aus App erstellen';

  @override
  String get createFromAppDescription =>
      'Öffne die TaskIt-App direkt und tippe auf \"Aus Zwischenablage erstellen\", um den Termin zu speichern.';

  @override
  String get tileRequestSent =>
      'Anfrage gesendet. Tippe im Systemdialog auf \'Hinzufügen\'.';
}
