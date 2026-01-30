/// 将 [int] 型的十进制数 [number] 转成任意 2–36 进制字符串
/// 返回的字母统一大写。
String toRadix(int number, int radix) {
  if (radix < 2 || radix > 36) {
    throw ArgumentError('radix must be 2..36');
  }
  if (number == 0) return '0';

  final digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final negative = number < 0;
  var n = negative ? -number : number;
  final result = <String>[];

  while (n > 0) {
    result.add(digits[n % radix]);
    n ~/= radix;
  }
  if (negative) result.add('-');

  return result.reversed.join();
}

/// 将任意 2–36 进制字符串 [text] 转回十进制 [int]
/// 支持负号、大小写混合。
int fromRadix(String text, int radix) {
  if (radix < 2 || radix > 36) {
    throw ArgumentError('radix must be 2..36');
  }
  text = text.trim();
  if (text.isEmpty) throw FormatException('empty string');

  final digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final map = <String, int>{
    for (var i = 0; i < digits.length; i++) digits[i]: i,
    for (var i = 0; i < digits.length; i++) digits[i].toLowerCase(): i,
  };

  var negative = false;
  var i = 0;
  if (text[0] == '-') {
    negative = true;
    i = 1;
  }

  int result = 0;
  for (; i < text.length; i++) {
    final ch = text[i];
    final val = map[ch];
    if (val == null || val >= radix) {
      throw FormatException('invalid character "$ch" for radix $radix');
    }
    result = result * radix + val;
  }
  return negative ? -result : result;
}