import 'package:url_launcher/url_launcher.dart';

class URLLauncherHelper {
  /// Launches a URL (http, https, tel, mailto, etc.)
  static Future<void> launch(
    String url, {
    launchMode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: launchMode);
    }
  }
}
