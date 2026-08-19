import 'package:intl/intl.dart';

class Formatters {
  static String currency(num amount) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: amount is int || amount % 1 == 0 ? 0 : 2,
      locale: 'en_IN',
    );
    return formatter.format(amount);
  }

  static String date(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return dateStr.length >= 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  static String dateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}
