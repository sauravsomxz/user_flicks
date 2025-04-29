import 'package:intl/intl.dart';

class AppHelpers {
  static String formatDateWithSuffix(String dateStr) {
    final date = DateTime.parse(dateStr);

    int day = date.day;
    String suffix = 'th';

    if (!(day >= 11 && day <= 13)) {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
      }
    }

    final formattedDate = DateFormat('MMM yyyy').format(date);
    return '$day$suffix $formattedDate';
  }

  /// Checks for if the String passed is URL based on protocol, domain & path
  static bool isURL(String str) {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?'
      r'([\w\-]+\.)+[\w\-]+'
      r'([\/\w\-.\?\=\&\#]*)*$',
    );
    return urlRegex.hasMatch(str);
  }

  static String formatDurationFromMinutes(int minutes) {
    final duration = Duration(minutes: minutes);
    final int hours = duration.inHours;
    final int mins = duration.inMinutes.remainder(60);
    final int secs = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return secs > 0 ? '${hours}h ${mins}m ${secs}s' : '${hours}h ${mins}m';
    } else if (mins > 0) {
      return secs > 0 ? '${mins}m ${secs}s' : '${mins}m';
    } else {
      return '${secs}s';
    }
  }

  static String formatUSD(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$ ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
