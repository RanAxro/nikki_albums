class Fraction {
  int numerator;
  int denominator;

  Fraction(this.numerator, this.denominator);

  /// 从 num (int 或 double) 创建分数
  factory Fraction.fromNum(num number) {
    // 处理整数
    if (number is int) {
      return Fraction(number, 1);
    }

    // 处理 double
    if (number.isNaN) {
      return Fraction(0, 0);
    }
    if (number.isInfinite) {
      return Fraction(1, 0);
    }

    // 处理负数
    final bool isNegative = number < 0;
    final num absNumber = number.abs();

    // 分离整数部分和小数部分
    final int wholePart = absNumber.floor();
    final double decimalPart = (absNumber - wholePart).toDouble();

    // 如果是纯整数
    if (decimalPart == 0) {
      return Fraction(isNegative ? -wholePart : wholePart, 1);
    }

    // 将小数转换为分数：使用连分数算法或简单精度方法
    // 这里使用基于精度的方法，限制分母大小
    final Fraction result = _decimalToFraction(
      decimalPart,
      maxDenominator: 10000,
    );

    // 合并整数部分
    final int finalNumerator =
        wholePart * result.denominator + result.numerator;
    final Fraction fraction = Fraction(
      isNegative ? -finalNumerator : finalNumerator,
      result.denominator,
    );

    fraction.reduce(); // 自动约分
    return fraction;
  }

  /// 将小数部分转换为分数（使用最佳有理逼近）
  static Fraction _decimalToFraction(
    double decimal, {
    required int maxDenominator,
  }) {
    if (decimal == 0) return Fraction(0, 1);

    double bestError = decimal.abs();
    int bestNumerator = 1;
    int bestDenominator = 1;

    // Stern-Brocot 树搜索最佳逼近
    int lowerN = 0, lowerD = 1;
    int upperN = 1, upperD = 1;

    while (true) {
      final mediantN = lowerN + upperN;
      final mediantD = lowerD + upperD;

      if (mediantD > maxDenominator) break;

      final mediant = mediantN / mediantD;
      final error = (decimal - mediant).abs();

      if (error < bestError) {
        bestError = error;
        bestNumerator = mediantN;
        bestDenominator = mediantD;
      }

      if (mediant < decimal) {
        lowerN = mediantN;
        lowerD = mediantD;
      } else if (mediant > decimal) {
        upperN = mediantN;
        upperD = mediantD;
      } else {
        return Fraction(mediantN, mediantD);
      }
    }

    return Fraction(bestNumerator, bestDenominator);
  }

  int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }

  /// 约分
  void reduce() {
    if (numerator == 0) {
      denominator = 1;
      return;
    }
    if (denominator == 0) {
      numerator = 1;
      return;
    }

    final commonDivisor = _gcd(numerator, denominator);
    numerator ~/= commonDivisor;
    denominator ~/= commonDivisor;

    // 确保负号只在分子上
    if (denominator < 0) {
      numerator = -numerator;
      denominator = -denominator;
    }
  }

  Fraction getReduction() => copy()..reduce();

  Fraction copy() => Fraction(numerator, denominator);

  num toNum() => numerator / denominator;

  double toDouble() => numerator / denominator;

  @override
  String toString() => "$numerator/$denominator";
}
