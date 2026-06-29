// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'TaskIt';

  @override
  String get homeTitle => '¡Crea tareas desde cualquier app!';

  @override
  String get createFromClipboard => 'Crear desde el portapapeles';

  @override
  String get addQuickSettingsTile => 'Añadir botón a Ajustes Rápidos';

  @override
  String get clipboardEmpty => 'El portapapeles está vacío o no tiene texto.';

  @override
  String get watchTutorial => 'Ver video tutorial';

  @override
  String get taskCreated => '¡Tarea creada con éxito!';

  @override
  String get creatingTask => 'Creando tarea...';

  @override
  String get addNow => 'Añadir ahora';

  @override
  String get back => 'Atrás';

  @override
  String get skip => 'Omitir';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Listo';

  @override
  String stepInfo(int index, int total) {
    return 'Paso $index de $total';
  }

  @override
  String get getStarted => 'Empezar';

  @override
  String get welcomeDescription =>
      'Esta guía rápida te muestra las diferentes formas de usar TaskIt.';

  @override
  String get method1Title => 'Método 1: Ajustes Rápidos';

  @override
  String get method1Description =>
      'Crea tareas rápido desde cualquier app copiando texto al portapapeles y tocando el botón de TaskIt en tus Ajustes Rápidos.';

  @override
  String get enableTileTitle => 'Activar botón';

  @override
  String get enableTileDescription =>
      'Añade el botón de TaskIt a tus Ajustes Rápidos en la barra de notificaciones para un acceso al instante.';

  @override
  String get tileTitle => 'Botón de Ajustes Rápidos';

  @override
  String get tileDescription => 'TaskIt ya está en tus Ajustes Rápidos.';

  @override
  String get tileTip =>
      'Tip: Ponlo en la primera pantalla de ajustes rápidos para tenerlo más a mano.';

  @override
  String get copyTextTitle => 'Método 1: Copiar texto';

  @override
  String get copyTextDescription =>
      'Selecciona el texto que quieras convertir en tarea y toca \"Copiar\".';

  @override
  String get tapTileTitle => 'Toca el botón de TaskIt';

  @override
  String get tapTileDescription =>
      'Desliza hacia abajo la barra y toca el botón de TaskIt.';

  @override
  String get eventCreatedTitle => 'Evento creado';

  @override
  String get eventCreatedDescription =>
      'TaskIt lee tu portapapeles, detecta el título y la hora del evento, y te abre el calendario con los datos ya listos. ¡Solo dale a \"Guardar\"!';

  @override
  String get backToWorkTitle => 'De vuelta al trabajo';

  @override
  String get backToWorkDescription =>
      'Una vez guardado, volverás de inmediato a lo que estabas haciendo sin interrumpir tu ritmo.';

  @override
  String get method2Title => 'Método 2: Menú de Compartir';

  @override
  String get method2Description =>
      'Envía texto directo a TaskIt usando el menú de Compartir de tu celular, ideal para apps donde no se puede copiar.';

  @override
  String get shareTextTitle => 'Método 2: Compartir texto';

  @override
  String get shareTextDescription =>
      'Primero, selecciona y copia el texto como antes.';

  @override
  String get shareViaTitle => 'Compartir con TaskIt';

  @override
  String get shareViaDescription =>
      'Toca \"Compartir\" y elige \"TaskIt\" de la lista de apps. TaskIt se encargará de crear el evento en tu calendario.';

  @override
  String get method3Title => 'Método 3: Menú Contextual';

  @override
  String get method3Description =>
      'Crea una tarea en un solo paso directamente desde el menú que sale al seleccionar texto, sin salir de tu app.';

  @override
  String get contextMenuTitle => 'Método 3: Menú Contextual';

  @override
  String get contextMenuDescription =>
      'Solo selecciona el texto y elige \"Crear tarea\" en el menú flotante.';

  @override
  String get method4Title => 'Método 4: Abrir la App';

  @override
  String get method4Description =>
      'Abre directamente la app de TaskIt para crear tareas de forma manual con lo que tengas en el portapapeles.';

  @override
  String get appLaunchTitle => 'Método 4: Abrir la App';

  @override
  String get appLaunchDescription =>
      'Primero, selecciona y copia el texto como antes.';

  @override
  String get createFromAppTitle => 'Crear desde la App';

  @override
  String get createFromAppDescription =>
      'Abre la app de TaskIt y toca \"Crear desde el portapapeles\" para guardar el evento.';

  @override
  String get tileRequestSent =>
      'Solicitud enviada. Toca \'Añadir\' en la pantalla.';
}
