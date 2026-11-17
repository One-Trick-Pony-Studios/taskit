// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TaskIt';

  @override
  String get homeTitle => 'Créez des tâches depuis n\'importe quelle app !';

  @override
  String get createFromClipboard => 'Créer depuis le presse-papiers';

  @override
  String get addQuickSettingsTile => 'Ajouter aux Paramètres Rapides';

  @override
  String get clipboardEmpty =>
      'Le presse-papiers est vide ou ne contient pas de texte.';

  @override
  String get watchTutorial => 'Voir la vidéo tuto';

  @override
  String get taskCreated => 'Tâche créée avec succès !';

  @override
  String get creatingTask => 'Création de la tâche...';

  @override
  String get addNow => 'Ajouter maintenant';

  @override
  String get back => 'Retour';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Prêt';

  @override
  String stepInfo(int index, int total) {
    return 'Étape $index sur $total';
  }

  @override
  String get getStarted => 'C\'est parti';

  @override
  String get welcomeDescription =>
      'Ce petit guide vous montre comment utiliser TaskIt au quotidien.';

  @override
  String get method1Title => 'Méthode 1: Paramètres Rapides';

  @override
  String get method1Description =>
      'Créez une tâche rapidement en copiant un texte et en appuyant sur le raccourci TaskIt dans vos paramètres rapides.';

  @override
  String get enableTileTitle => 'Activer le raccourci';

  @override
  String get enableTileDescription =>
      'Ajoutez le raccourci TaskIt à vos paramètres rapides dans la barre de notifications pour y accéder en un instant.';

  @override
  String get tileTitle => 'Raccourci Paramètres Rapides';

  @override
  String get tileDescription =>
      'TaskIt est maintenant dans vos Paramètres Rapides.';

  @override
  String get tileTip =>
      'Astuce: Placez-le sur le premier écran des paramètres rapides pour l\'avoir sous la main.';

  @override
  String get copyTextTitle => 'Copier le texte';

  @override
  String get copyTextDescription =>
      'Sélectionnez le texte à convertir en tâche et appuyez sur \"Copier\".';

  @override
  String get tapTileTitle => 'Appuyer sur le raccourci TaskIt';

  @override
  String get tapTileDescription =>
      'Glissez vers le bas et appuyez sur le raccourci TaskIt.';

  @override
  String get eventCreatedTitle => 'Événement créé';

  @override
  String get eventCreatedDescription =>
      'TaskIt lit votre presse-papiers, remplit automatiquement le titre et l\'heure, puis ouvre votre calendrier. Il ne vous reste plus qu\'à faire \"Enregistrer\" !';

  @override
  String get backToWorkTitle => 'Retour à votre appli';

  @override
  String get backToWorkDescription =>
      'Une fois enregistré, vous revenez instantanément à ce que vous faisiez sans couper votre élan.';

  @override
  String get method2Title => 'Méthode 2: Menu Partager';

  @override
  String get method2Description =>
      'Envoyez du texte à TaskIt via le menu de partage du téléphone (idéal si la copie de texte est bloquée).';

  @override
  String get shareTextTitle => 'Partager le texte';

  @override
  String get shareTextDescription =>
      'Sélectionnez et copiez le texte comme d\'habitude.';

  @override
  String get shareViaTitle => 'Partager via TaskIt';

  @override
  String get shareViaDescription =>
      'Appuyez sur \"Partager\" et choisissez \"TaskIt\" dans la liste. TaskIt va créer l\'événement dans votre calendrier.';

  @override
  String get method3Title => 'Méthode 3: Menu contextuel';

  @override
  String get method3Description =>
      'Créez une tâche en une seule action depuis le menu de sélection de texte, sans quitter votre appli.';

  @override
  String get contextMenuTitle => 'Menu contextuel';

  @override
  String get contextMenuDescription =>
      'Surlignez simplement le texte et choisissez \"Créer une tâche\" dans le menu contextuel.';

  @override
  String get method4Title => 'Méthode 4: Ouvrir l\'appli';

  @override
  String get method4Description =>
      'Ouvrez directement l\'application TaskIt pour créer des tâches manuellement à partir de votre presse-papiers.';

  @override
  String get appLaunchTitle => 'Ouvrir l\'appli';

  @override
  String get appLaunchDescription =>
      'Sélectionnez d\'abord le texte et copiez-le comme d\'habitude.';

  @override
  String get createFromAppTitle => 'Créer depuis l\'appli';

  @override
  String get createFromAppDescription =>
      'Ouvrez directement TaskIt et appuyez sur \"Créer depuis le presse-papiers\" pour enregistrer l\'événement.';

  @override
  String get tileRequestSent =>
      'Demande envoyée. Appuyez sur \'Ajouter\' à l\'écran.';
}
