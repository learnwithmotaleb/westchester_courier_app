import 'package:get/get.dart';
import 'bgg/bgg.dart';
import 'eng/eng.dart';

class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': english,
        'bg_BG': bulgarian,
      };
}
