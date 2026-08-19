import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _standardDate = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _shortDate = DateFormat('dd/MM/yyyy');

  static String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return _standardDate.format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  static String formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return _dateTime.format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  static String formatShortDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return _shortDate.format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }
}
