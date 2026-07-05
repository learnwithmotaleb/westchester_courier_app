import 'package:share_plus/share_plus.dart';
import '../utils/static_strings/static_strings.dart';

class AppShare {
  static void shareApp() {
    Share.share(
      "Check out BestKits — the best kids marketplace app!\n"
          "https://play.google.com/store/apps/details?id=com.bestkits.app",
      subject: "Download ${AppStrings.appName}",
    );
  }

  static void shareText(String text, {String? subject}) {
    Share.share(text, subject: subject);
  }
}