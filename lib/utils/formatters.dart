/// Shared display helpers for Indian market prices.
class Formatters {
  static String inr(num value) {
    final rounded = value.round();
    final digits = rounded.toString();
    final buffer = StringBuffer('₹');

    // Indian grouping: last 3, then pairs (e.g. 12,34,567)
    final len = digits.length;
    for (var i = 0; i < len; i++) {
      final remaining = len - i;
      if (i != 0 && remaining == 3) {
        buffer.write(',');
      } else if (i != 0 && remaining > 3 && (remaining - 3) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String percent(num value, {bool showSign = true}) {
    final sign = showSign && value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)}%';
  }

  static String priceAndChange(num price, num changePercent) {
    return '${inr(price)}  · ${percent(changePercent)}';
  }
}
