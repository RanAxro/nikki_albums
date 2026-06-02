import 'package:flutter_test/flutter_test.dart';
import 'package:nikki_albums/utils/radix.dart';

void main() {
  group('toRadix', () {
    test('throws for invalid radix', () {
      expect(() => toRadix(10, 1), throwsArgumentError);
      expect(() => toRadix(10, 37), throwsArgumentError);
    });

    test('returns correct radix representations', () {
      expect(toRadix(0, 16), '0');
      expect(toRadix(255, 16), 'FF');
      expect(toRadix(-255, 16), '-FF');
      expect(toRadix(10, 2), '1010');
      expect(toRadix(35, 36), 'Z');
    });
  });

  group('fromRadix', () {
    test('throws for invalid radix', () {
      expect(() => fromRadix('10', 1), throwsArgumentError);
      expect(() => fromRadix('10', 37), throwsArgumentError);
    });

    test('throws for invalid characters', () {
      expect(() => fromRadix('G', 16), throwsFormatException);
      expect(() => fromRadix(' ', 10), throwsFormatException);
    });

    test('returns correct integers', () {
      expect(fromRadix('FF', 16), 255);
      expect(fromRadix('ff', 16), 255);
      expect(fromRadix('-FF', 16), -255);
      expect(fromRadix('1010', 2), 10);
      expect(fromRadix('Z', 36), 35);
      expect(fromRadix('z', 36), 35);
    });
  });
}
