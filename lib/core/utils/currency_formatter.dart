import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num? amount, {String symbol = '₹'}) {
    if (amount == null) return '${symbol}0.00';
    if (symbol == '₹') {
      return _inrFormatter.format(amount);
    }
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCompact(num? amount, {String symbol = '₹'}) {
    if (amount == null) return '${symbol}0';
    if (amount >= 10000000) {
      return '$symbol${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '$symbol${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)} k';
    }
    return format(amount, symbol: symbol);
  }
}
