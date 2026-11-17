// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'TaskIt';

  @override
  String get homeTitle => 'किसी भी ऐप से टास्क बनाएं!';

  @override
  String get createFromClipboard => 'क्लिपबोर्ड से बनाएं';

  @override
  String get addQuickSettingsTile => 'Quick Settings टाइल जोड़ें';

  @override
  String get clipboardEmpty =>
      'क्लिपबोर्ड खाली है या इसमें कोई टेक्स्ट नहीं है।';

  @override
  String get watchTutorial => 'ट्यूटोरियल वीडियो देखें';

  @override
  String get taskCreated => 'टास्क सफलतापूर्वक बन गया!';

  @override
  String get creatingTask => 'टास्क बन रहा है...';

  @override
  String get addNow => 'अभी जोड़ें';

  @override
  String get back => 'पीछे जाएं';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'आगे बढ़ें';

  @override
  String get done => 'हो गया';

  @override
  String stepInfo(int index, int total) {
    return 'स्टेप $index / $total';
  }

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get welcomeDescription =>
      'यह छोटा सा टूर आपको TaskIt इस्तेमाल करने के अलग-अलग तरीके बताएगा।';

  @override
  String get method1Title => 'तरीका 1: Quick Settings';

  @override
  String get method1Description =>
      'टेक्स्ट कॉपी करके और TaskIt Quick Settings टाइल को टैप करके किसी भी ऐप से तुरंत टास्क बनाएं।';

  @override
  String get enableTileTitle => 'टाइल चालू करें';

  @override
  String get enableTileDescription =>
      'जल्दी एक्सेस के लिए अपने फोन के नोटिफिकेशन पैनल में TaskIt Quick Settings टाइल जोड़ें।';

  @override
  String get tileTitle => 'Quick Settings टाइल';

  @override
  String get tileDescription => 'TaskIt अब आपके Quick Settings में है।';

  @override
  String get tileTip =>
      'सलाह: इसे आसानी से ढूंढने के लिए Quick Settings की पहली स्क्रीन पर रखें।';

  @override
  String get copyTextTitle => 'टेक्स्ट कॉपी करें';

  @override
  String get copyTextDescription =>
      'जिस टेक्स्ट को आप टास्क में बदलना चाहते हैं उसे सेलेक्ट करें और \"Copy\" पर टैप करें।';

  @override
  String get tapTileTitle => 'TaskIt टाइल पर टैप करें';

  @override
  String get tapTileDescription =>
      'नोटिफिकेशन पैनल नीचे खींचें और TaskIt Quick Settings टाइल पर टैप करें।';

  @override
  String get eventCreatedTitle => 'इवेंट बन गया';

  @override
  String get eventCreatedDescription =>
      'TaskIt क्लिपबोर्ड से टेक्स्ट पढ़कर अपने आप टास्क का नाम और समय सेट कर देता है, और कैलेंडर खोल देता है। बस \"Save\" पर टैप करें!';

  @override
  String get backToWorkTitle => 'वापस अपने काम पर';

  @override
  String get backToWorkDescription =>
      'इवेंट सेव होते ही आप तुरंत उसी ऐप में वापस आ जाएंगे जहाँ आप पहले काम कर रहे थे।';

  @override
  String get method2Title => 'तरीका 2: Share Sheet';

  @override
  String get method2Description =>
      'सिस्टम Share Sheet का इस्तेमाल करके सीधे TaskIt पर टेक्स्ट भेजें (उन ऐप्स के लिए जहाँ कॉपी करना बंद या धीमा है)।';

  @override
  String get shareTextTitle => 'टेक्स्ट शेयर करें';

  @override
  String get shareTextDescription => 'सबसे पहले टेक्स्ट सेलेक्ट और कॉपी करें।';

  @override
  String get shareViaTitle => 'TaskIt से शेयर करें';

  @override
  String get shareViaDescription =>
      '\"Share\" पर टैप करें और ऐप्स की लिस्ट में से \"TaskIt\" चुनें। TaskIt इसे टास्क में बदल देगा और कैलेंडर खोल देगा।';

  @override
  String get method3Title => 'तरीка 3: Context Menu';

  @override
  String get method3Description =>
      'बिना ऐप छोड़े, टेक्स्ट सेलेक्ट करते ही सामने आने वाले मेनू से डायरेक्ट एक क्लिक में टास्क बनाएं।';

  @override
  String get contextMenuTitle => 'Context Menu';

  @override
  String get contextMenuDescription =>
      'बस टेक्स्ट को सेलेक्ट करें और पॉपअप मेनू में से \"Create Task\" चुनें।';

  @override
  String get method4Title => 'तरीका 4: ऐप खोलें';

  @override
  String get method4Description =>
      'कॉपी किए गए टेक्स्ट से टास्क बनाने के लिए सीधे TaskIt ऐप खोलें।';

  @override
  String get appLaunchTitle => 'ऐप खोलें';

  @override
  String get appLaunchDescription => 'सबसे पहले टेक्स्ट सेलेक्ट और कॉपी करें।';

  @override
  String get createFromAppTitle => 'ऐप से बनाएं';

  @override
  String get createFromAppDescription =>
      'सीधे TaskIt ऐप खोलें और टास्क सेव करने के लिए \"Create from Clipboard\" पर टैप करें।';

  @override
  String get tileRequestSent =>
      'रिक्वेस्ट भेज दी गई है। सिस्टम डायलॉग पर \'Add\' पर टैप करें।';
}
