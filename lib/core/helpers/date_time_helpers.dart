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
}
